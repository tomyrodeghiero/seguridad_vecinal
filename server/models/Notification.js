const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
    date: { type: Date, default: Date.now },
    read: { type: Boolean, default: false },
    recipientEmail: String,
    title: String,
    description: String,
    neighborhood: String,
    timestamp: Date,
    images: [String],
    videos: [String],
    audios: [String],
    senderEmail: {
        type: String,
        required: true
    },
    senderProfileImage: String,
    readByUsers: [String],
});

module.exports = mongoose.model('Notification', notificationSchema);
