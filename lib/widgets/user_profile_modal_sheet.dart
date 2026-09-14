import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/nexus_theme.dart';

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
          backgroundColor: NexusTheme.bgCocoaDark,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: NexusTheme.rosePrimary, size: 20),
              SizedBox(width: 10),
              Text('Profile changes saved successfully!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x333D2314),
              blurRadius: 35,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Handlebar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2314).withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Account Profile',
                    style: TextStyle(
                      color: NexusTheme.textDarkPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: NexusTheme.bgBase,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: NexusTheme.textDarkPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar Card Banner (Matching React web UserProfileModal)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NexusTheme.bgBase,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NexusTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(
                        _avatarUrlController.text.isNotEmpty
                            ? _avatarUrlController.text
                            : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
                      ),
                      backgroundColor: NexusTheme.rosePrimary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  u.fullName,
                                  style: const TextStyle(
                                    color: NexusTheme.textDarkPrimary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: u.role == 'Admin' ? NexusTheme.alertRedBg : const Color(0xFFFDF2F8),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: u.role == 'Admin' ? NexusTheme.alertRedBorder : NexusTheme.roseLight,
                                  ),
                                ),
                                child: Text(
                                  u.role,
                                  style: TextStyle(
                                    color: u.role == 'Admin' ? NexusTheme.alertRedText : NexusTheme.rosePrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            u.email,
                            style: const TextStyle(color: NexusTheme.textDarkSecondary, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.stars, color: NexusTheme.primaryGoldHover, size: 15),
                              const SizedBox(width: 4),
                              Text(
                                '${u.loyaltyPoints} PTS • ${u.subscriptionTier}',
                                style: const TextStyle(
                                  color: NexusTheme.amberDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Avatar Presets Selection
              const Text(
                'Quick Preset Avatars',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
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
                          color: isSel ? const Color(0xFFFDF2F8) : NexusTheme.bgBase,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel ? NexusTheme.rosePrimary : NexusTheme.cardBorder,
                            width: isSel ? 1.5 : 1,
                          ),
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
                                color: isSel ? NexusTheme.rosePrimary : NexusTheme.textDarkSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
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
              const Text(
                'Full Name',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _fullNameController,
                style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 14),
                decoration: NexusTheme.authInputDecoration(
                  hintText: 'Your full name',
                  prefixIcon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 14),

              // Phone Number Field
              const Text(
                'Phone Number',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 14),
                decoration: NexusTheme.authInputDecoration(
                  hintText: '+880 1700-000000',
                  prefixIcon: Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 14),

              // Custom Avatar URL Field
              const Text(
                'Avatar Image URL (Cloudinary / Web)',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _avatarUrlController,
                style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 13),
                decoration: NexusTheme.authInputDecoration(
                  hintText: 'https://res.cloudinary.com/dnt43ugtr/...',
                  prefixIcon: Icons.image_outlined,
                ),
              ),
              const SizedBox(height: 14),

              // Read-Only Info Box (Email & Tier)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: NexusTheme.bgBase,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NexusTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email Address', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(u.email, style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Subscription', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(u.subscriptionTier, style: const TextStyle(color: NexusTheme.rosePrimary, fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons: Sign Out & Save Changes
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NexusTheme.alertRedText,
                      backgroundColor: NexusTheme.alertRedBg,
                      side: const BorderSide(color: NexusTheme.alertRedBorder),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, size: 17),
                    label: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: NexusTheme.bgCocoaDark,
                            content: Text('You have signed out from Buttercup.'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NexusTheme.rosePrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _isSaving
                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_outlined, size: 17),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Changes',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      onPressed: _isSaving ? null : _handleSave,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

