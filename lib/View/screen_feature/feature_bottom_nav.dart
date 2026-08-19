import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeatureBottomNav extends StatelessWidget {
  const FeatureBottomNav({super.key, required this.activeIndex});

  final int activeIndex;

  static const _rose = Color(0xFFC46F7D);
  static const _muted = Color(0xFF7E777A);

  @override
  Widget build(BuildContext context) {
    const destinations = [
      ('Home', Icons.home_outlined, '/home'),
      ('Health Tracking', Icons.show_chart, '/health_tracking'),
      ('AI Chat', Icons.smart_toy_outlined, '/ai_assistant'),
      ('Emergency', Icons.emergency_outlined, '/emergency_support'),
      ('Profile', Icons.person_outline, '/profile'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDFD),
        border: Border(top: BorderSide(color: Color(0xFFE1DADC))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: destinations.asMap().entries.map((entry) {
          final index = entry.key;
          final destination = entry.value;
          final active = index == activeIndex;
          return Expanded(
            child: InkWell(
              onTap: () => context.go(destination.$3),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    destination.$2,
                    size: 19,
                    color: active ? _rose : _muted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      color: active ? _rose : _muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
