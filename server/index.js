require('dotenv').config();
const fs = require('fs');
const { google } = require('googleapis');
const formidable = require('formidable');
const express = require('express');
const User = require('./models/User');
const Token = require('./models/Token');
const Report = require('./models/Report');
const Notification = require('./models/Notification');
const connectDB = require('./db/index');
const cloudinary = require('cloudinary').v2;

// Configuración de Cloudinary
cloudinary.config({
    cloud_name: 'deqspgsn4',
    api_key: '791472898121285',
    api_secret: 'bylWI1EMDWHoEcBpwAi-OEIjQWg'
});


const app = express();
app.use(express.json());
const cors = require('cors');
app.use(cors());
connectDB();

const oauth2Client = new google.auth.OAuth2(
    process.env.CLIENT_ID,
    process.env.CLIENT_SECRET,
    process.env.REDIRECT_URI
);

const getStoredRefreshToken = async () => {
    const token = await Token.findOne();
    return token ? token.refreshToken : null;
};

app.get("/auth/google", (req, res) => {
    const url = oauth2Client.generateAuthUrl({
        access_type: "offline",
        scope: [
            "https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/drive",
        ],
    });
    res.redirect(url);
});

// Ruta de redirección de Google
app.get("/google/redirect", async (req, res) => {
    const { code } = req.query;
    const { tokens } = await oauth2Client.getToken(code);
    oauth2Client.setCredentials(tokens);

    if (tokens.refresh_token) {
        await storeRefreshToken(tokens.refresh_token);
    }
    fs.writeFileSync("credentials.json", JSON.stringify(tokens));
    res.send("Authenticated");
});

oauth2Client.on("tokens", async (tokens) => {
    if (tokens.refresh_token) {
        await storeRefreshToken(tokens.refresh_token);
    }
});

async function initializeOAuthClient() {
    try {
        const storedRefreshToken = await getStoredRefreshToken();
        if (storedRefreshToken) {
            oauth2Client.setCredentials({ refresh_token: storedRefreshToken });
            console.log("OAuth client initialized with stored refresh token.");
        } else {
            console.log("No stored refresh token found.");
        }
    } catch (error) {
        console.error("Error initializing OAuth client", error);
    }
}

// Store refresh token
const storeRefreshToken = async (refreshToken) => {
    const existingToken = await Token.findOne();
    if (existingToken) {
        existingToken.refreshToken = refreshToken;
        await existingToken.save();
    } else {
        const token = new Token({ refreshToken });
        await token.save();
    }
};

// Register User
app.post('/api/register-user', async (req, res) => {
    const form = new formidable.IncomingForm();

    form.parse(req, async (err, fields, files) => {
        if (err) {
            console.error("Error parsing the form", err);
            return res.status(500).send("Error processing the form");
        }

        // Extrae y asegura que cada campo sea una cadena
        const email = Array.isArray(fields.email) ? fields.email[0] : fields.email;
        const password = Array.isArray(fields.password) ? fields.password[0] : fields.password;
        const neighborhood = Array.isArray(fields.neighborhood) ? fields.neighborhood[0] : fields.neighborhood;
        const gender = Array.isArray(fields.gender) ? fields.gender[0] : fields.gender;
        const age = parseInt(Array.isArray(fields.age) ? fields.age[0] : fields.age, 10);
        const fullName = Array.isArray(fields.fullName) ? fields.fullName[0] : fields.fullName;

        let imageUrl = '';
        if (files.image) {
            const imageFile = Array.isArray(files.image) ? files.image[0] : files.image;
            try {
                const result = await uploadToCloudinary(imageFile.filepath);
                imageUrl = result;
            } catch (uploadError) {
                console.error("Error uploading image to Cloudinary", uploadError);
                return res.status(500).send("Error uploading image");
            }
        }

        try {
            const newUser = new User({
                email,
                password,
                neighborhood,
                gender,
                imageUrl,
                age,
                fullName,
            });

            await newUser.save();

            // Modifica aquí para enviar los datos del usuario en la respuesta
            const userData = {
                userEmail: newUser.email,
                fullName: newUser.fullName,
                imageUrl: newUser.imageUrl
            };
            console.log("userData->", userData)
            res.status(201).json({
                message: 'Usuario registrado con éxito',
                data: userData,
            });
        } catch (error) {
            console.log(error);
            res.status(500).send('Error al registrar el usuario');
        }
    });
});


// Cloudinary
async function uploadToCloudinary(filePath, resourceType = 'auto') {
    try {
        const result = await cloudinary.uploader.upload(filePath, {
            resource_type: resourceType,
            folder: 'cori',
        });
        return result.secure_url;
    } catch (error) {
        console.error("Error uploading file to Cloudinary", error);
        throw new Error("Error uploading file");
    }
}

app.post('/api/create-report', async (req, res) => {
    const form = new formidable.IncomingForm();

    form.parse(req, async (err, fields, files) => {
        if (err) {
            console.error("Error parsing the files", err);
            return res.status(500).send("Error processing the form");
        }

        let senderEmail = fields.senderEmail;
        let title = fields.title;
        let neighborhood = fields.neighborhood;
        const images = files.images;
        let description = fields.description;

        if (Array.isArray(senderEmail)) {
            senderEmail = senderEmail[0];
        }
        if (Array.isArray(title)) {
            title = title[0];
        }
        if (Array.isArray(neighborhood)) {
            neighborhood = neighborhood[0];
        }
        if (Array.isArray(description)) {
            description = description[0];
        }

        let imageUrls = [];
        if (Array.isArray(images)) {
            for (let image of images) {
                const fileUrl = await uploadToCloudinary(image.filepath);
                imageUrls.push(fileUrl);
            }
        } else if (images) {
            const fileUrl = await uploadToCloudinary(images.filepath);
            imageUrls.push(fileUrl);
        }

        const user = await User.findOne({ email: senderEmail });
        const senderProfileImage = user ? user.imageUrl : 'URL predeterminada si no se encuentra el usuario';

        const newReport = new Report({
            title,
            description,
            neighborhood,
            timestamp: new Date(),
            images: imageUrls,
            senderEmail,
            senderProfileImage,
        });

        try {
            await newReport.save();

            const users = await User.find({ email: { $ne: senderEmail } });
            for (let user of users) {
                const newNotification = new Notification({
                    message: newReport.title,
                    recipientEmail: user.email,
                    title,
                    description,
                    neighborhood,
                    timestamp: new Date(),
                    images: imageUrls,
                    senderEmail,
                    senderProfileImage,
                });
                await newNotification.save();
            }

            res.json({ message: 'Report created successfully', reportId: newReport._id, senderProfileImage });
            console.log("Report created successfully: ", newReport);
        } catch (error) {
            console.error("Error saving the report:", error);
            res.status(500).send("Error saving the report");
        }
    });
});

app.post('/api/validate-login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email, password });
        if (user) {
            res.status(200).json({
                message: 'Login successful',
                userEmail: user.email,
                fullName: user.fullName,
                imageUrl: user.imageUrl
            });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    } catch (error) {
        res.status(500).send('Error during authentication');
    }
});


// Check if an email exist in the Database
app.get('/api/check-email', async (req, res) => {
    const { email } = req.query;
    if (!email) {
        return res.status(400).send({ message: 'Email is required' });
    }
    try {
        const user = await User.findOne({ email });
        if (user) {
            res.status(200).json({ exists: true });
        } else {
            res.status(200).json({ exists: false });
        }
    } catch (error) {
        res.status(500).send('Error checking email');
    }
});


// Get Reports
app.get('/api/get-reports', async (req, res) => {
    try {
        const reports = await Report.find({}).sort({ timestamp: -1 });
        res.status(200).json(reports);
    } catch (error) {
        console.error("Error fetching reports:", error);
        res.status(500).send("Error fetching reports");
    }
});

// Get notifiactions by user
app.get('/api/get-notifications', async (req, res) => {
    const { email } = req.query;

    if (!email) {
        return res.status(400).send({ message: 'Email query parameter is required.' });
    }

    try {
        const notifications = await Notification.find({ recipientEmail: email }).sort({ date: -1 });
        res.json(notifications);
    } catch (error) {
        console.error("Error fetching notifications:", error);
        res.status(500).send("Error fetching notifications");
    }
});

app.get('/api/get-unread-notifications', async (req, res) => {
    const { email } = req.query;

    if (!email) {
        return res.status(400).send({ message: 'Email query parameter is required.' });
    }

    try {
        const notifications = await Notification.find({
            recipientEmail: email,
            readByUsers: { $ne: email }
        }).sort({ date: -1 });

        res.json(notifications);
    } catch (error) {
        console.error("Error fetching unread notifications:", error);
        res.status(500).send("Error fetching unread notifications");
    }
});


// Read notification by user
app.post('/api/mark-notification-read', async (req, res) => {
    const { notificationId, userEmail } = req.body;
    console.log("notificationId", notificationId)
    console.log("userEmail", userEmail)

    try {
        const notification = await Notification.findById(notificationId);
        if (!notification.readByUsers.includes(userEmail)) {
            notification.readByUsers.push(userEmail);
            await notification.save();
            res.status(200).json({ message: 'Notificación marcada como leída.' });
        } else {
            res.status(200).json({ message: 'Notificación ya fue marcada como leída.' });
        }
    } catch (error) {
        console.error("Error marcando la notificación como leída:", error);
        res.status(500).json({ message: "Error actualizando la notificación" });
    }
});

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running in port ${PORT}`));