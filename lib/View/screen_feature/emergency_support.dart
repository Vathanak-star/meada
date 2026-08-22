import 'package:flutter/material.dart';

import 'feature_bottom_nav.dart';

class EmergencySupport extends StatelessWidget {
  const EmergencySupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFF1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Emergency Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('Emergency support')),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 3),
    );
  }
}
