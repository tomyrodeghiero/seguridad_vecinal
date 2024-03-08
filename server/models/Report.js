const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
    title: String,
    message: String,
    neighborhood: String,
    timestamp: Date,
    images: [String],
    videos: [String],
    audios: [String],
    senderEmail: {
        type: String,
    },
    senderProfileImage: String,
    senderFullName: String,
});

module.exports = mongoose.model('Report', reportSchema);
