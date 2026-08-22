import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feature_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _rose = Color(0xFFC46F7D);
  static const _ink = Color(0xFF2F292B);
  static const _muted = Color(0xFF7E777A);
  static const _background = Color(0xFFF7EFF1);
  bool _isSigningOut = false;

  User? get _user => Supabase.instance.client.auth.currentUser;

  String get _email => _user?.email ?? 'No email connected';

  String get _displayName {
    final metadata = _user?.userMetadata;
    final name = metadata?['full_name'] ?? metadata?['name'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    final emailName = _user?.email?.split('@').first;
    if (emailName == null || emailName.isEmpty) return 'Meada member';
    return emailName[0].toUpperCase() + emailName.substring(1);
  }

  String get _initials {
    final words = _displayName.split(RegExp(r'\s+'));
    if (words.length > 1) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return _displayName.substring(0, 1).toUpperCase();
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out of Meada?'),
        content: const Text('You can sign back in whenever you are ready.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _rose),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) await _logout();
  }

  Future<void> _logout() async {
    setState(() => _isSigningOut = true);
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) context.go('/login');
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSigningOut = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Could not log out: $error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF5A3038),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700, color: _ink),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 22),
              const Text(
                'YOUR WELLBEING',
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              _buildWellbeingCard(),
              const SizedBox(height: 24),
              const Text(
                'ACCOUNT',
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingsSection(),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSigningOut ? null : _confirmLogout,
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded),
                  label: Text(_isSigningOut ? 'Logging out...' : 'Log out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _rose,
                    side: const BorderSide(color: _rose),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 4),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8DADC)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: const Color(0xFFEED9DE),
            child: Text(
              _initials,
              style: const TextStyle(
                color: _rose,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_outlined, color: _rose, size: 20),
        ],
      ),
    );
  }

  Widget _buildWellbeingCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEED9DE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.spa_outlined, color: _rose, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Small steps count. Keep checking in with yourself today.',
              style: TextStyle(color: _ink, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8DADC)),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.person_outline,
            title: 'Personal details',
            subtitle: 'Manage your account information',
            onTap: () => _showMessage('Personal details are coming soon.'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Choose what you want to hear about',
            onTap: () => _showMessage('Notification settings are coming soon.'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _buildSettingTile(
            icon: Icons.help_outline_rounded,
            title: 'Help and support',
            subtitle: 'Get answers about using Meada',
            onTap: () => _showMessage('Help and support are coming soon.'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: Icon(icon, color: _rose),
      title: Text(
        title,
        style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: _muted, fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right, color: _muted),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}
