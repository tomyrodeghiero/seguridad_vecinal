const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
    title: String,
    description: String,
    location: String,
    timestamp: Date,
    images: [String],
    videos: [String],
    audios: [String],
});

module.exports = mongoose.model('Report', reportSchema);
