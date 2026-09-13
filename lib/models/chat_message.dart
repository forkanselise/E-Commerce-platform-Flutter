class ChatMessage {
  final String id;
  final String sender;
  final String role;
  final String text;
  final String timestamp;
  final List<String> toolsExecuted;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.role,
    required this.text,
    required this.timestamp,
    this.toolsExecuted = const [],
  });
}
