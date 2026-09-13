import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ai_agent_provider.dart';
import '../providers/catalog_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/glass_container.dart';

class AiConciergeScreen extends ConsumerStatefulWidget {
  const AiConciergeScreen({super.key});

  @override
  ConsumerState<AiConciergeScreen> createState() => _AiConciergeScreenState();
}

class _AiConciergeScreenState extends ConsumerState<AiConciergeScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiAgentProvider);
    final catalogState = ref.watch(catalogProvider);

    return Column(
      children: [
        GlassContainer(
          borderRadius: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: NexusTheme.accentCyan, shape: BoxShape.circle),
                child: const Icon(Icons.psychology, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACTIVE AGENT: ${aiState.activeAgent}', style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                  const Text('Smart Bakery Multi-Agent Concierge Engine (Riverpod)', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: aiState.messages.length,
            itemBuilder: (ctx, i) {
              final msg = aiState.messages[i];
              final isUser = msg.role == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? NexusTheme.primaryGold : NexusTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isUser ? NexusTheme.primaryGold : NexusTheme.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.smart_toy, color: NexusTheme.primaryGold, size: 14),
                            const SizedBox(width: 6),
                            Text(msg.sender, style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        msg.text,
                        style: TextStyle(color: isUser ? Colors.black : Colors.white, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg.timestamp,
                        style: TextStyle(color: isUser ? Colors.black54 : NexusTheme.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (aiState.isThinking)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: NexusTheme.primaryGold)),
                const SizedBox(width: 10),
                Text(aiState.currentThought ?? 'Thinking...', style: const TextStyle(color: NexusTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Ask about Callebaut, Anchor butter, or adding to cart...',
                    hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 12),
                    filled: true,
                    fillColor: NexusTheme.cardGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final text = _ctrl.text;
                  _ctrl.clear();
                  ref.read(aiAgentProvider.notifier).sendMessage(text, catalogState.allProducts, [], ref);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(gradient: NexusTheme.goldGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
