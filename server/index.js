require('dotenv').config();
const { google } = require('googleapis');
const express = require('express');
const User = require('./models/User');
const connectDB = require('./db/index');

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

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running in port ${PORT}`));