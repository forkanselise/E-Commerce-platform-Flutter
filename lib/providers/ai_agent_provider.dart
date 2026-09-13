import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../models/tutorial.dart';
import '../services/ai_agent_service.dart';
import 'cart_provider.dart';

class AiAgentState {
  final List<ChatMessage> messages;
  final bool isThinking;
  final String activeAgent;
  final String? currentThought;

  AiAgentState({
    required this.messages,
    this.isThinking = false,
    this.activeAgent = 'RouterConcierge',
    this.currentThought,
  });

  AiAgentState copyWith({
    List<ChatMessage>? messages,
    bool? isThinking,
    String? activeAgent,
    String? currentThought,
  }) {
    return AiAgentState(
      messages: messages ?? this.messages,
      isThinking: isThinking ?? this.isThinking,
      activeAgent: activeAgent ?? this.activeAgent,
      currentThought: currentThought,
    );
  }
}

class AiAgentNotifier extends StateNotifier<AiAgentState> {
  AiAgentNotifier() : super(AiAgentState(
    messages: [
      ChatMessage(
        id: 'welcome',
        sender: 'RouterConcierge',
        role: 'assistant',
        text: 'Hello! 🧁 Welcome to Nexus Bakery & Tech. I am your AI Concierge. Ask me about Callebaut chocolates, Anchor dairy, video masterclasses, or adding items directly to your shopping cart.',
        timestamp: '10:00 AM',
      )
    ],
  ));

  Future<void> sendMessage(String text, List<Product> catalog, List<Tutorial> courses, WidgetRef ref) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      sender: 'User',
      role: 'user',
      text: text,
      timestamp: _formattedTime(),
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMsg);
    state = state.copyWith(
      messages: updatedMessages,
      isThinking: true,
      currentThought: 'Analyzing query intent and checking Nexus Bakery catalog...',
    );

    final replyMsg = await AiAgentService.sendMessage(text, catalog, courses);

    final finalMessages = List<ChatMessage>.from(state.messages)..add(replyMsg);
    state = state.copyWith(
      messages: finalMessages,
      isThinking: false,
      currentThought: null,
      activeAgent: replyMsg.sender,
    );

    if (replyMsg.text.contains('Added to Cart!')) {
      final p = catalog.firstWhere((item) => text.toLowerCase().contains(item.title.toLowerCase().split(' ')[0]), orElse: () => catalog.first);
      ref.read(cartProvider.notifier).addItem(p);
    }
  }

  static String _formattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }
}

final aiAgentProvider = StateNotifierProvider<AiAgentNotifier, AiAgentState>((ref) => AiAgentNotifier());
