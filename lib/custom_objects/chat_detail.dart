class ChatDetailList {
  final ChatDetail userChat;

  const ChatDetailList({required this.userChat});

  factory ChatDetailList.fromJson(Map<String, dynamic> parsedJson) {
    return ChatDetailList(
        userChat: ChatDetail.fromJson(parsedJson['chatLines']));
  }
}

class ChatDetail {
  final int id;
  final String line_text;
  final int sender_id;
  final int receiver_id;
  final String createdAt;
  final String updatedAt;
  final String? imageUrl;
  final int isRead;

  const ChatDetail(
      {required this.id,
      required this.line_text,
      required this.sender_id,
      required this.receiver_id,
      required this.createdAt,
      required this.updatedAt,
      this.imageUrl,
      required this.isRead});

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      id: json['id'],
      line_text: json['line_text'],
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imageUrl: json['image_url'],
      isRead: json['is_read'],
    );
  }
}
