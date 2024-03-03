require('dotenv').config();
const fs = require('fs');
const { google } = require('googleapis');
const formidable = require('formidable');
const express = require('express');
const User = require('./models/User');
const Token = require('./models/Token');
const Report = require('./models/Report');
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

app.post('/api/register-user', async (req, res) => {
    const { email, password, neighborhood, gender, age, contactPhone } = req.body;

    try {
        const newUser = new User({
            email,
            password,
            neighborhood,
            gender,
            age,
            contactPhone,
        });

        await newUser.save();

        res.status(201).send('Usuario registrado con éxito');
    } catch (error) {
        console.log(error);
        res.status(500).send('Error al registrar el usuario');
    }
});

// Google Drive
async function uploadToCloudinary(filePath, resourceType = 'auto') {
    try {
        const result = await cloudinary.uploader.upload(filePath, {
            resource_type: resourceType,
            folder: 'cori',
        });
        console.log("result.secure_url", result.secure_url)
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

        const { title, neighborhood } = fields;
        let { description } = fields;
        const images = files.images;

        if (Array.isArray(description)) {
            description = description.join(" ");
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

        const newReport = new Report({
            title,
            description,
            neighborhood,
            timestamp: new Date(),
            images: imageUrls,
        });

        await newReport.save();


        res.json({ message: 'Report created successfully', reportId: newReport._id });
        console.log("Report created successfully");
    });
});

app.post('/api/validate-login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email, password });
        if (user) {
            res.status(200).json({ message: 'Login successful', userId: user._id });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    } catch (error) {
        res.status(500).send('Error during authentication');
    }
});


const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running in port ${PORT}`));