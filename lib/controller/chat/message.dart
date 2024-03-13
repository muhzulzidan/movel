// message.dart

class Message {
  final String sender;
  final String content;
  final String profilePicture;
  final String? created_at;
  final bool isDriver;

  Message({
    required this.sender,
    required this.content,
    required this.profilePicture,
    required this.isDriver,
    this.created_at,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['user']['name'],
      content: json['content'],
      profilePicture: json['profilePicture'],
      isDriver: json['isDriver'],
      created_at: json['created_at'],
    );
  }

  @override
  String toString() {
    return 'Message(sender: $sender, content: $content, profilePicture: $profilePicture, created_at: $created_at, isDriver: $isDriver)';
  }
}
