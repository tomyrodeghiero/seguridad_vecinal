require('dotenv').config();
const fs = require('fs');
const { google } = require('googleapis');
const User = require('./models/User');
const Token = require('./models/Token');
const Report = require('./models/Report');
const Notification = require('./models/Notification');
const connectDB = require('./db/index');
const cloudinary = require('cloudinary').v2;
const formidable = require('formidable');
const express = require('express');

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

// Register User
app.post('/api/register-user', async (req, res) => {
    const form = new formidable.IncomingForm();

    form.parse(req, async (err, fields, files) => {
        console.log(fields); // Ahora puedes acceder a los campos aquí
        console.log(files); // Y los archivos aquí
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

        console.log(email, password, neighborhood, gender, age, fullName);

        let imageUrl = '';
        if (files.image) {
            const imageFile = Array.isArray(files.image) ? files.image[0] : files.image;
            console.log("imageFile", imageFile);
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

            const userData = {
                userEmail: newUser.email,
                fullName: newUser.fullName,
                imageUrl: newUser.imageUrl,
            };
            console.log("userData->", userData)

            try {
                // Obtén todos los reportes existentes
                const reports = await Report.find({});

                // Para cada reporte, crea una nueva notificación para el nuevo usuario
                await Promise.all(reports.map(async (report) => {
                    const newNotification = new Notification({
                        message: `${report.title}`,
                        recipientEmail: newUser.email,
                        title: report.title,
                        message: report.message,
                        neighborhood: report.neighborhood,
                        timestamp: new Date(),
                        images: report.images,
                        senderEmail: report.senderEmail,
                        senderProfileImage: report.senderProfileImage,
                    });

                    // Guarda la notificación
                    await newNotification.save();
                }));

                console.log("Notificaciones de reportes existentes creadas para el nuevo usuario.");
            } catch (error) {
                console.error("Error creando notificaciones para el nuevo usuario", error);
                // Considera cómo manejar este error. ¿Quieres que falle todo el proceso de registro?
                // ¿O simplemente loguear el error y continuar?
            }

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
async function uploadToCloudinary(filePath) {
    try {
        let result = await cloudinary.uploader.upload(filePath, { folder: 'cori', });
        console.log("result.url", result.url);
        return result.url;
    } catch (error) {
        console.error("Error uploading image to Cloudinary", error);
        throw error;
    }
}

app.post('/api/create-report', async (req, res) => {
    const form = new formidable.IncomingForm();

    try {
        const { fields, files } = await new Promise((resolve, reject) => {
            form.parse(req, (err, fields, files) => {
                if (err) {
                    reject(err);
                    return;
                }
                resolve({ fields, files });
            });
        });

        let { senderEmail, title, neighborhood, message } = fields;
        console.log("fields", fields);

        let imageUrls = [];
        if (Array.isArray(files.images)) {
            for (let image of files.images) {
                const fileUrl = await uploadToCloudinary(image.filepath);
                imageUrls.push(fileUrl);
            }
        } else if (files.images) {
            const fileUrl = await uploadToCloudinary(files.images.filepath);
            imageUrls.push(fileUrl);
        }

        message = Array.isArray(message) ? message[0] : message;
        senderEmail = Array.isArray(senderEmail) ? senderEmail[0] : senderEmail;
        title = Array.isArray(title) ? title[0] : title;
        neighborhood = Array.isArray(neighborhood) ? neighborhood[0] : neighborhood;

        const user = await User.findOne({ email: senderEmail });
        const senderProfileImage = user ? user.imageUrl : 'URL predeterminada si no se encuentra el usuario';

        const newReport = new Report({
            title,
            message,
            neighborhood,
            timestamp: new Date(),
            images: imageUrls,
            senderEmail,
            senderProfileImage,
        });

        await newReport.save();

        const users = await User.find({ email: { $ne: senderEmail } });
        for (let user of users) {
            const newNotification = new Notification({
                message: newReport.title,
                recipientEmail: user.email,
                title,
                message,
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
        console.error("Error processing the form:", error);
        res.status(500).send("Error saving the report");
    }
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
app.post('/api/check-email', async (req, res) => {
    const { email } = req.body;
    if (!email) {
        return res.status(400).send({ message: 'Email is required' });
    }
    try {
        const user = await User.findOne({ email });
        if (user) {
            res.status(200).json({
                message: 'Login successful',
                userEmail: user.email,
                fullName: user.fullName,
                imageUrl: user.imageUrl,
                exists: true
            });
        } else {
            res.status(200).json({ exists: false, message: 'Invalid credentials' });
        }
    } catch (error) {
        res.status(500).send('Error checking email');
    }
});

// Get Reports
app.get('/api/get-reports', async (req, res) => {
    try {
        let reports = await Report.find({}).sort({ timestamp: -1 });

        reports = await Promise.all(reports.map(async (report) => {
            const user = await User.findOne({ email: report.senderEmail });
            if (user) {
                return { ...report.toObject(), senderFullName: user.fullName };
            }
            return report.toObject();
        }));

        res.status(200).json(reports);
    } catch (error) {
        console.error("Error fetching reports:", error);
        res.status(500).send("Error fetching reports");
    }
});

// Get notifications by user
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

// Neighboorh
app.get('/api/get-communities-from-users', async (req, res) => {
    try {
        const predefinedNeighborhoods = ["Micro centro", "Alberdi", "Banda Norte", "Bimaco", "Barrio Jardín", "Otro"];

        // Inicializa los conteos de comunidad y reportes para cada vecindario predefinido
        const neighborhoodData = predefinedNeighborhoods.reduce((acc, neighborhood) => {
            acc[neighborhood] = { membersCount: 0, reportsCount: 0 };
            return acc;
        }, {});

        // Obtiene la cuenta de miembros por vecindario considerando 'neighborhood' y 'joinedNeighborhoods'
        const users = await User.find({
            $or: [
                { neighborhood: { $in: predefinedNeighborhoods } },
                { joinedNeighborhoods: { $in: predefinedNeighborhoods } }
            ]
        });

        // Contabiliza cada usuario para su vecindario y los vecindarios a los que se ha unido
        users.forEach(user => {
            if (predefinedNeighborhoods.includes(user.neighborhood)) {
                neighborhoodData[user.neighborhood].membersCount += 1;
            }
            user.joinedNeighborhoods.forEach(joinedNeighborhood => {
                if (predefinedNeighborhoods.includes(joinedNeighborhood)) {
                    neighborhoodData[joinedNeighborhood].membersCount += 1;
                }
            });
        });

        // Obtiene la cuenta de reportes por vecindario
        const reportCounts = await Report.aggregate([
            {
                $group: {
                    _id: "$neighborhood",
                    reportsCount: { $sum: 1 }
                }
            }
        ]);

        // Actualiza los conteos de reportes en el objeto neighborhoodData
        reportCounts.forEach(report => {
            if (neighborhoodData[report._id]) {
                neighborhoodData[report._id].reportsCount = report.reportsCount;
            }
        });

        // Prepara la respuesta final utilizando la estructura neighborhoodData
        const result = Object.keys(neighborhoodData).map(neighborhood => ({
            neighborhood: neighborhood,
            membersCount: neighborhoodData[neighborhood].membersCount,
            reportsCount: neighborhoodData[neighborhood].reportsCount,
        }));

        res.status(200).json(result);
    } catch (error) {
        console.error("Error fetching communities from users:", error);
        res.status(500).send("Error fetching communities from users");
    }
});


app.get('/api/get-reports-by-neighborhood', async (req, res) => {
    const { neighborhood } = req.query;

    if (!neighborhood) {
        return res.status(400).send({ message: 'El nombre del barrio es requerido.' });
    }

    try {
        let reports = await Report.find({ neighborhood: neighborhood }).sort({ timestamp: -1 });

        const enrichedReports = await Promise.all(reports.map(async (report) => {
            const user = await User.findOne({ email: report.senderEmail });
            if (user) {
                return { ...report.toObject(), senderFullName: user.fullName };
            } else {
                return report.toObject();
            }
        }));

        const response = {
            neighborhood: neighborhood,
            reportsCount: enrichedReports.length,
            reports: enrichedReports
        };

        res.status(200).json(response);
    } catch (error) {
        console.error("Error fetching reports by neighborhood:", error);
        res.status(500).send("Error al obtener los reportes por barrio.");
    }
});

app.get('/api/get-reports-summary', async (req, res) => {
    const predefinedNeighborhoods = ["Micro centro", "Alberdi", "Banda Norte", "Bimaco", "Barrio Jardín", "Otro"];

    try {
        const reportsSummary = await Report.aggregate([
            {
                $group: {
                    _id: "$neighborhood",
                    reportsCount: { $sum: 1 }
                }
            },
            {
                $project: {
                    _id: 0,
                    neighborhood: "$_id",
                    reportsCount: 1
                }
            }
        ]);

        const reportsMap = {};
        reportsSummary.forEach(report => {
            reportsMap[report.neighborhood] = report.reportsCount;
        });

        const fullSummary = predefinedNeighborhoods.map(neighborhood => {
            return {
                neighborhood: neighborhood,
                reportsCount: reportsMap[neighborhood] || 0
            };
        });

        res.status(200).json(fullSummary);
    } catch (error) {
        console.error("Error fetching reports summary:", error);
        res.status(500).send("Error al obtener el resumen de los reportes por barrio.");
    }
});

app.post('/api/join-neighborhood', async (req, res) => {
    const { userEmail, neighborhood } = req.body;
    console.log("userEmail", userEmail);
    console.log("neighborhood", neighborhood);

    if (!userEmail || !neighborhood) {
        return res.status(400).send({ message: 'Email y vecindario son requeridos.' });
    }

    try {
        const user = await User.findOne({ email: userEmail });
        if (!user) {
            return res.status(404).send({ message: 'Usuario no encontrado.' });
        }

        // Añade el vecindario al arreglo si aún no está presente
        if (!user.joinedNeighborhoods.includes(neighborhood)) {
            user.joinedNeighborhoods.push(neighborhood);
            await user.save();
        }

        res.status(200).json({ message: 'Vecindario añadido exitosamente.', joinedNeighborhoods: user.joinedNeighborhoods });
    } catch (error) {
        console.error("Error al unirse al vecindario:", error);
        res.status(500).send("Error al unirse al vecindario.");
    }
});

app.get('/api/check-membership', async (req, res) => {
    const { userEmail, neighborhood } = req.query;

    if (!userEmail || !neighborhood) {
        return res.status(400).send({ message: 'Email y vecindario son requeridos.' });
    }

    try {
        const user = await User.findOne({ email: userEmail, $or: [{ neighborhood: neighborhood }, { joinedNeighborhoods: neighborhood }] });

        if (user) {
            return res.status(200).json({ isJoined: true });
        } else {
            return res.status(200).json({ isJoined: false });
        }
    } catch (error) {
        console.error("Error verificando la membresía del usuario:", error);
        res.status(500).send("Error al verificar la membresía.");
    }
});

// async function deleteAllUsers() {
//     try {
//         await User.deleteMany({});
//         console.log('Todos los usuarios han sido borrados.');
//     } catch (error) {
//         console.error('Error borrando los usuarios:', error);
//     }
// }

// async function deleteAllReports() {
//     try {
//         await Report.deleteMany({});
//         console.log('Todos los reportes han sido borrados.');
//     } catch (error) {
//         console.error('Error borrando los reportes:', error);
//     }
// }

// deleteAllReports()
// deleteAllUsers()


const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running in port ${PORT}`));