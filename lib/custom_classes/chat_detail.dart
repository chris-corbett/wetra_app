class ChatDetailList {
  final List<ChatDetail> chatList;

  const ChatDetailList({required this.chatList});

  factory ChatDetailList.fromJson(List<dynamic> parsedJson) {
    List<ChatDetail> chatList = [];
    chatList = parsedJson.map((i) => ChatDetail.fromJson(i)).toList();

    return ChatDetailList(chatList: chatList);
  }
}

class ChatDetail {
  final int id;
  final String lineText;
  final int senderId;
  final int receiverId;
  final String createdAt;
  final String updatedAt;
  final String? imageUrl;
  final int isRead;

  const ChatDetail(
      {required this.id,
      required this.lineText,
      required this.senderId,
      required this.receiverId,
      required this.createdAt,
      required this.updatedAt,
      this.imageUrl,
      required this.isRead});

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      id: json['id'],
      lineText: json['line_text'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imageUrl: json['image_url'],
      isRead: json['is_read'],
    );
  }
}
