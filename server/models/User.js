const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    fullName: String,
    email: { type: String, required: true },
    password: { type: String, required: true },
    neighborhood: String,
    gender: String,
    age: Number,
    contactPhone: { type: [String], },
    imageUrl: String,
    joinedNeighborhoods: [{ type: String }],
});

module.exports = mongoose.model('User', userSchema);