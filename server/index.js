require('dotenv').config();
const express = require('express');

const connectDB = require('./db/index');

const app = express();
app.use(express.json());

const cors = require('cors');
app.use(cors());

connectDB();

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running in port ${PORT}`));