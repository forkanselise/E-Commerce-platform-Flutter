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

  static const List<String> _quickPrompts = [
    '🍫 Best chocolate for ganache?',
    '🧈 Anchor butter vs local butter',
    '📱 Flagship phone for photo editing?',
    '🥐 How to bake sourdough?',
    '🎓 Academy masterclass pricing',
  ];

  void _sendPrompt(String promptText) {
    if (promptText.trim().isEmpty) return;
    _ctrl.clear();
    final catalogState = ref.read(catalogProvider);
    ref.read(aiAgentProvider.notifier).sendMessage(promptText, catalogState.allProducts, [], ref);
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiAgentProvider);

    return Column(
      children: [
        GlassContainer(
          borderRadius: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(gradient: NexusTheme.roseGradient, shape: BoxShape.circle),
                child: const Icon(Icons.psychology, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('MR. BUTTER AI', style: TextStyle(color: NexusTheme.primaryGold, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: NexusTheme.accentCyan.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(aiState.activeAgent, style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Text('Buttercup Multi-Agent Bakery & Tech Concierge', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11)),
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
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
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

        // Quick Suggestion Chips
        SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _quickPrompts.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () => _sendPrompt(_quickPrompts[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: NexusTheme.cardGlass,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NexusTheme.cardBorder),
                  ),
                  child: Text(
                    _quickPrompts[i],
                    style: const TextStyle(color: NexusTheme.textLightSecondary, fontSize: 11),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Chat Input Row
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  onSubmitted: (val) => _sendPrompt(val),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Ask Mr. Butter about baking, tech gear, or recommendations...',
                    hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 12),
                    filled: true,
                    fillColor: NexusTheme.cardGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _sendPrompt(_ctrl.text),
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

