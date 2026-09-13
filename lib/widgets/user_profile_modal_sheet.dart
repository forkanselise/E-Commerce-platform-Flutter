import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

class UserProfileModalSheet extends ConsumerStatefulWidget {
  const UserProfileModalSheet({super.key});

  @override
  ConsumerState<UserProfileModalSheet> createState() => _UserProfileModalSheetState();
}

class _UserProfileModalSheetState extends ConsumerState<UserProfileModalSheet> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  bool _isSaving = false;

  final List<Map<String, String>> _presetAvatars = [
    {
      'label': 'Pastry Chef',
      'url': 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=300',
    },
    {
      'label': 'Artisan Baker',
      'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    },
    {
      'label': 'Cake Designer',
      'url': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300',
    },
    {
      'label': 'Master Barista',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
    },
  ];

  @override
  void initState() {
    super.initState();
    final u = ref.read(authProvider).user;
    if (u != null) {
      _fullNameController.text = u.fullName;
      _phoneController.text = u.phone;
      _avatarUrlController.text = u.avatarUrl;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final success = await ref.read(authProvider.notifier).updateProfile(
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      avatarUrl: _avatarUrlController.text,
    );
    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Profile updated successfully!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final u = authState.user;

    if (u == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: NexusTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: NexusTheme.primaryGold, width: 1.5)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar & Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Account Profile',
                    style: TextStyle(color: NexusTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: NexusTheme.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar Card Banner
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(_avatarUrlController.text.isNotEmpty
                          ? _avatarUrlController.text
                          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300'),
                      backgroundColor: NexusTheme.primaryGold,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  u.fullName,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: u.role == 'Admin' ? NexusTheme.accentRed : NexusTheme.accentCyan,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  u.role,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(u.email, style: const TextStyle(color: NexusTheme.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.stars, color: NexusTheme.primaryGold, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${u.loyaltyPoints} PTS • ${u.subscriptionTier}',
                                style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Avatar Presets Selection
              const Text('Preset Artisan Avatars', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetAvatars.length,
                  itemBuilder: (ctx, i) {
                    final preset = _presetAvatars[i];
                    final isSel = _avatarUrlController.text == preset['url'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _avatarUrlController.text = preset['url']!;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSel ? NexusTheme.primaryGold.withOpacity(0.25) : NexusTheme.cardGlass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSel ? NexusTheme.primaryGold : NexusTheme.cardBorder),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(preset['url']!),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              preset['label']!,
                              style: TextStyle(
                                color: isSel ? NexusTheme.primaryGold : Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Full Name Field
              const Text('Full Name', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _fullNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, color: NexusTheme.primaryGold, size: 20),
                  filled: true,
                  fillColor: NexusTheme.cardGlass,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                ),
              ),
              const SizedBox(height: 14),

              // Phone Number Field
              const Text('Phone Number', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined, color: NexusTheme.primaryGold, size: 20),
                  filled: true,
                  fillColor: NexusTheme.cardGlass,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                ),
              ),
              const SizedBox(height: 14),

              // Custom Avatar URL Field
              const Text('Custom Avatar / Cloudinary URL', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _avatarUrlController,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.image_outlined, color: NexusTheme.accentCyan, size: 20),
                  hintText: 'https://res.cloudinary.com/...',
                  hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: NexusTheme.cardGlass,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Save & Sign Out
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NexusTheme.accentRed,
                      side: const BorderSide(color: NexusTheme.accentRed),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You have been signed out.')),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NexusTheme.primaryGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _isSaving
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.save, size: 18),
                      label: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _isSaving ? null : _handleSave,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
