import 'package:flutter/material.dart';
import '../models/tutorial.dart';
import '../theme/nexus_theme.dart';
import '../widgets/glass_container.dart';

class MasterclassScreen extends StatelessWidget {
  const MasterclassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            color: NexusTheme.surfaceDark,
            child: Row(
              children: [
                const Icon(Icons.school, color: NexusTheme.primaryGold, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('BAKING ACADEMY MASTERCLASSES', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Video courses taught by Parisian pastry chefs with interactive timestamps.', style: TextStyle(color: NexusTheme.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: INITIAL_TUTORIALS.length,
            itemBuilder: (ctx, i) {
              final tut = INITIAL_TUTORIALS[i];
              return GlassContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(tut.thumbnail, width: double.infinity, height: 160, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: NexusTheme.primaryGold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(tut.skillLevel, style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Text('⏱️ ${tut.durationMinutes} mins', style: const TextStyle(color: NexusTheme.textMuted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(tut.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(tut.description, style: const TextStyle(color: NexusTheme.textSecondary, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('৳${tut.price.toStringAsFixed(0)} BDT', style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 15, fontWeight: FontWeight.bold)),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_fill, size: 18),
                          label: const Text('START CLASS'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enrolled in ${tut.title}!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
