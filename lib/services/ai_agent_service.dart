import '../models/chat_message.dart';
import '../models/product.dart';
import '../models/tutorial.dart';
import 'api_service.dart';

class AiAgentService {
  static Future<ChatMessage> sendMessage(String text, List<Product> catalog, List<Tutorial> courses) async {
    final res = await ApiService.post('/Agent/chat', {'message': text, 'prompt': text});
    if (res != null && res['message'] != null) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        sender: res['respondingAgent'] ?? 'RouterConcierge',
        role: 'assistant',
        text: res['message'],
        timestamp: _formattedTime(),
        toolsExecuted: res['toolsExecuted'] != null ? List<String>.from(res['toolsExecuted']) : [],
      );
    }

    final lower = text.toLowerCase().trim();
    String agent = 'RouterConcierge';
    List<String> tools = [];
    String reply = '';

    final outOfDomain = ['python', 'javascript', 'weather', 'football', 'cricket', 'president', 'capital of'];
    if (outOfDomain.any((k) => lower.contains(k))) {
      reply = "I can only answer questions related to Smart Bakery products, ingredients, baking masterclasses, and tech gear. How can I assist your baking journey?";
    } else if (lower.contains('add') && (lower.contains('cart') || lower.contains('buy'))) {
      agent = 'StorefrontInventory';
      tools = ['SearchProducts', 'AddToCart'];
      final matched = catalog.firstWhere((item) => lower.contains(item.title.toLowerCase().split(' ')[0]), orElse: () => catalog.first);
      reply = "🛒 **Added to Cart!**\n\nI have added **${matched.title}** (৳${matched.price.toStringAsFixed(0)} BDT) to your shopping cart. You can proceed to checkout anytime!";
    } else if (lower.contains('class') || lower.contains('tutorial') || lower.contains('macaron') || lower.contains('masterclass')) {
      agent = 'BakingMasterclass';
      tools = ['SearchTutorials'];
      reply = "🎓 **Smart Bakery Masterclasses Found:**\n\n" +
          courses.map((c) => "• **${c.title}** (${c.skillLevel})\n  👨‍🍳 Instructor: ${c.instructorName} | ⏱️ ${c.durationMinutes} mins | ৳${c.price.toStringAsFixed(0)} BDT").join('\n\n');
    } else {
      agent = 'StorefrontInventory';
      tools = ['SearchProducts', 'CheckStock'];
      final matches = catalog.where((p) => lower.contains(p.title.toLowerCase()) || lower.contains(p.category.toLowerCase())).toList();
      final list = matches.isNotEmpty ? matches.take(3).toList() : catalog.take(3).toList();
      reply = "📦 **Smart Bakery Inventory Matches:**\n\n" +
          list.map((p) => "• **${p.title}**\n  🏷️ Price: ৳${p.price.toStringAsFixed(0)} BDT | 📦 In Stock: ${p.warehouseStock} units | SKU: ${p.sku}").join('\n\n') +
          "\n\n💡 *Tip: Ask me to add any of these to your cart!*";
    }

    return ChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      sender: agent,
      role: 'assistant',
      text: reply,
      timestamp: _formattedTime(),
      toolsExecuted: tools,
    );
  }

  static String _formattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }
}
