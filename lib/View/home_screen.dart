import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screen_feature/feature_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _rose = Color(0xFFC46F7D);
  static const _ink = Color(0xFF1F1B1C);
  static const _muted = Color(0xFF7E777A);
  static const _background = Color(0xFFF7EFF1);

  int _waterCount = 0;
  int _mood = 2;
  int _symptomCount = 0;
  bool _isLoading = true;
  String? _error;

  User? get _user => Supabase.instance.client.auth.currentUser;

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String get _moodLabel =>
      const ['Low', 'Tired', 'Okay', 'Good', 'Great'][_mood.clamp(0, 4)];

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String get _name {
    final metadata = _user?.userMetadata;
    final name = metadata?['full_name'] ?? metadata?['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim().split(' ').first;
    }
    return 'there';
  }

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final user = _user;
    if (user == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Log in to see your personal summary.';
        });
      }
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final today = _dateKey(DateTime.now());
      final dailyRows = await Supabase.instance.client
          .from('daily_health_logs')
          .select('water_count, mood')
          .eq('user_id', user.id)
          .eq('log_date', today)
          .limit(1);
      final symptomRows = await Supabase.instance.client
          .from('symptom_logs')
          .select('id')
          .eq('user_id', user.id)
          .eq('log_date', today);
      if (!mounted) return;
      final rows = dailyRows as List<dynamic>;
      final daily = rows.isEmpty ? null : rows.first as Map<String, dynamic>;
      setState(() {
        _waterCount = (daily?['water_count'] as int?) ?? 0;
        _mood = (daily?['mood'] as int?) ?? 2;
        _symptomCount = (symptomRows as List<dynamic>).length;
        _isLoading = false;
      });
    } on PostgrestException catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = error.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_greeting, $_name',
                        style: const TextStyle(fontSize: 16, color: _muted),
                      ),
                      IconButton(
                        onPressed: _isLoading ? null : _loadSummary,
                        tooltip: 'Refresh summary',
                        icon: const Icon(Icons.refresh_rounded, color: _rose),
                      ),
                    ],
                  ),
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[
                    _ErrorBanner(message: _error!, onRetry: _loadSummary),
                    const SizedBox(height: 14),
                  ],
                  _buildSummaryCard(),
                  const SizedBox(height: 18),
                  _DailyCheckIn(onTap: () => context.go('/health_tracking')),
                  const SizedBox(height: 24),
                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _HomeAction(
                    icon: Icons.show_chart,
                    title: 'Track your health',
                    subtitle: 'Log water, mood, and symptoms',
                    route: '/health_tracking',
                  ),
                  const SizedBox(height: 10),
                  _HomeAction(
                    icon: Icons.smart_toy_outlined,
                    title: 'Talk to AI assistant',
                    subtitle: 'Get support for your wellbeing journey',
                    route: '/ai_assistant',
                  ),
                  const SizedBox(height: 10),
                  _HomeAction(
                    icon: Icons.emergency_outlined,
                    title: 'Emergency support',
                    subtitle: 'Get urgent help when you need it',
                    route: '/emergency_support',
                  ),
                  const SizedBox(height: 10),
                  _HomeAction(
                    icon: Icons.person_outline,
                    title: 'Open your profile',
                    subtitle: 'Manage your account and preferences',
                    route: '/profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 0),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFD),
        border: Border.all(color: const Color(0xFFE1DADC)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today at a glance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HomeMetric(
                icon: Icons.water_drop_outlined,
                value: _isLoading ? '--' : '$_waterCount/8',
                label: 'Water cups',
              ),
              _HomeMetric(
                icon: Icons.sentiment_satisfied_outlined,
                value: _isLoading ? '--' : _moodLabel,
                label: 'Mood',
              ),
              _HomeMetric(
                icon: Icons.healing_outlined,
                value: _isLoading ? '--' : '$_symptomCount',
                label: 'Symptoms',
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: _isLoading ? null : (_waterCount / 8).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: const Color(0xFFF2DDE1),
              color: _rose,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isLoading
                ? 'Loading your summary...'
                : _waterCount >= 8
                ? 'Daily water goal reached.'
                : '${8 - _waterCount} cups left to reach your water goal.',
            style: const TextStyle(fontSize: 11, color: _muted),
          ),
        ],
      ),
    );
  }
}

class _HomeMetric extends StatelessWidget {
  const _HomeMetric({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: const Color(0xFFC46F7D), size: 24),
      const SizedBox(height: 7),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF7E777A)),
      ),
    ],
  );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE9EC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: Color(0xFF9A4D5A), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6C3942)),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

class _DailyCheckIn extends StatelessWidget {
  const _DailyCheckIn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEED9DE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: Color(0xFFC46F7D), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a daily check-in',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1B1C),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Log your water, mood, or symptoms',
                  style: TextStyle(fontSize: 11, color: Color(0xFF7E777A)),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: Color(0xFFC46F7D)),
        ],
      ),
    ),
  );
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => GoRouter.of(context).go(route),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFD),
        border: Border.all(color: const Color(0xFFE1DADC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF2DDE1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFC46F7D), size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7E777A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF7E777A)),
        ],
      ),
    ),
  );
}
