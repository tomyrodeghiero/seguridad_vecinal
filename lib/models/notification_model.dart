class NotificationModel {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? date;
  final String? detailImageUrl;
  final String? audioUrl;

  NotificationModel({
    this.id,
    this.title,
    this.subtitle,
    this.date,
    this.detailImageUrl,
    this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date,
      'detailImageUrl': detailImageUrl,
      'audioUrl': audioUrl,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      date: json['date'],
      detailImageUrl: json['detailImageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? date,
    String? detailImageUrl,
    String? audioUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      detailImageUrl: detailImageUrl ?? this.detailImageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
