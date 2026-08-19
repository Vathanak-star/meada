import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screen_feature/feature_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFF1),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 42, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good morning',
                    style: TextStyle(fontSize: 16, color: Color(0xFF7E777A)),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1B1C),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDFD),
                      border: Border.all(color: const Color(0xFFE1DADC)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today at a glance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _HomeMetric(
                              icon: Icons.water_drop_outlined,
                              value: '6/8',
                              label: 'Water cups',
                            ),
                            _HomeMetric(
                              icon: Icons.sentiment_satisfied_outlined,
                              value: 'Okay',
                              label: 'Mood',
                            ),
                            _HomeMetric(
                              icon: Icons.check_circle_outline,
                              value: '3',
                              label: 'Goals',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Quick actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
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
                    subtitle: 'Get support for your wellness journey',
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
            child: Icon(icon, color: Color(0xFFC46F7D), size: 22),
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
