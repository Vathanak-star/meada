import 'package:flutter/material.dart';

import 'feature_bottom_nav.dart';

class AiAssistant extends StatelessWidget {
  const AiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFF1),
      appBar: AppBar(
        title: const Text('AI Assistant'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(child: Text('How can I support you today?')),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 2),
    );
  }
}
