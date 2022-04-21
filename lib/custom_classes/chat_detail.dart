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
  final String? imageUrl;
  final int isRead;

  const ChatDetail(
      {required this.id,
      required this.lineText,
      required this.senderId,
      required this.receiverId,
      this.imageUrl,
      required this.isRead});

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      id: json['id'],
      lineText: json['line_text'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      imageUrl: json['image_url'],
      isRead: json['is_read'],
    );
  }
}
