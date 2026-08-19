import 'package:flutter/material.dart';

import 'feature_bottom_nav.dart';

class HealthTracking extends StatefulWidget {
  const HealthTracking({super.key});

  @override
  State<HealthTracking> createState() => _HealthTrackingState();
}

class _HealthTrackingState extends State<HealthTracking> {
  bool _showSymptoms = false;
  int _waterCount = 6;
  int _selectedMood = 2;

  static const _rose = Color(0xFFC46F7D);
  static const _ink = Color(0xFF1F1B1C);
  static const _surface = Color(0xFFFFFDFD);
  static const _background = Color(0xFFF7EFF1);
  static const _muted = Color(0xFF7E777A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: _Title()),
                  const SizedBox(height: 16),
                  _SegmentedTabs(
                    showSymptoms: _showSymptoms,
                    onChanged: (value) => setState(() => _showSymptoms = value),
                    rose: _rose,
                  ),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _showSymptoms
                        ? _SymptomsView(
                            key: const ValueKey('symptoms'),
                            rose: _rose,
                          )
                        : _TodayView(
                            key: const ValueKey('today'),
                            rose: _rose,
                            waterCount: _waterCount,
                            selectedMood: _selectedMood,
                            onWaterTap: (index) =>
                                setState(() => _waterCount = index + 1),
                            onMoodChanged: (index) =>
                                setState(() => _selectedMood = index),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 1),
    );
  }
}

class _LoggedSymptom {
  const _LoggedSymptom({
    required this.name,
    required this.severity,
    required this.category,
    required this.date,
  });
  final String name;
  final String severity;
  final String category;
  final String date;
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) => const Text(
    'Health Tracking',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: _HealthTrackingState._ink,
    ),
  );
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.showSymptoms,
    required this.onChanged,
    required this.rose,
  });
  final bool showSymptoms;
  final ValueChanged<bool> onChanged;
  final Color rose;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _Tab(
          text: 'Today',
          selected: !showSymptoms,
          onTap: () => onChanged(false),
          rose: rose,
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: _Tab(
          text: 'Symptoms',
          selected: showSymptoms,
          onTap: () => onChanged(true),
          rose: rose,
        ),
      ),
    ],
  );
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.text,
    required this.selected,
    required this.onTap,
    required this.rose,
  });
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Color rose;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 32,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? rose : Colors.transparent,
        foregroundColor: selected ? Colors.white : _HealthTrackingState._muted,
        side: BorderSide(color: selected ? rose : const Color(0xFFD9D3D5)),
        shape: const StadiumBorder(),
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(text),
    ),
  );
}

class _TodayView extends StatelessWidget {
  const _TodayView({
    super.key,
    required this.rose,
    required this.waterCount,
    required this.selectedMood,
    required this.onWaterTap,
    required this.onMoodChanged,
  });
  final Color rose;
  final int waterCount;
  final int selectedMood;
  final ValueChanged<int> onWaterTap;
  final ValueChanged<int> onMoodChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Panel(
        padding: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeading(
              title: 'Water Intake',
              trailing: '$waterCount/8 cups',
              rose: rose,
            ),
            const SizedBox(height: 11),
            Row(
              children: List.generate(
                8,
                (index) => Expanded(
                  child: _WaterDrop(
                    filled: index < waterCount,
                    onTap: () => onWaterTap(index),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tap cups to log',
                  style: TextStyle(
                    fontSize: 12,
                    color: _HealthTrackingState._muted,
                  ),
                ),
                Text(
                  '${8 - waterCount} more needed',
                  style: TextStyle(fontSize: 12, color: rose),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _Panel(
        padding: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _HealthTrackingState._ink,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => _Mood(
                  index: index,
                  selected: selectedMood == index,
                  onTap: () => onMoodChanged(index),
                  rose: rose,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _Panel(child: _MoodHistory(rose: rose)),
    ],
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = 14});
  final Widget child;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: _HealthTrackingState._surface,
      border: Border.all(color: const Color(0xFFE1DADC)),
      borderRadius: BorderRadius.circular(11),
    ),
    child: child,
  );
}

class _PanelHeading extends StatelessWidget {
  const _PanelHeading({
    required this.title,
    required this.trailing,
    required this.rose,
  });
  final String title, trailing;
  final Color rose;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(Icons.water_drop_outlined, size: 20, color: rose),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      Text(trailing, style: TextStyle(fontSize: 12, color: rose)),
    ],
  );
}

class _WaterDrop extends StatelessWidget {
  const _WaterDrop({required this.filled, required this.onTap});
  final bool filled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 42,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFF0C7CE) : const Color(0xFFF2DDE1),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD68A98)),
      ),
      child: Icon(
        Icons.water_drop_outlined,
        size: 20,
        color: filled ? _HealthTrackingState._rose : Colors.white,
      ),
    ),
  );
}

class _Mood extends StatelessWidget {
  const _Mood({
    required this.index,
    required this.selected,
    required this.onTap,
    required this.rose,
  });
  final int index;
  final bool selected;
  final VoidCallback onTap;
  final Color rose;
  static const labels = ['Low', 'Tired', 'Okay', 'Good', 'Great'];
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: selected ? rose : const Color(0xFFE9C2C9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            index == 2 ? Icons.sentiment_satisfied : Icons.sentiment_neutral,
            size: 24,
            color: selected ? Colors.white : const Color(0xFF857276),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          labels[index],
          style: TextStyle(
            fontSize: 11,
            color: selected ? rose : _HealthTrackingState._muted,
          ),
        ),
      ],
    ),
  );
}

class _MoodHistory extends StatelessWidget {
  const _MoodHistory({required this.rose});
  final Color rose;
  @override
  Widget build(BuildContext context) {
    const values = [45.0, 68.0, 38.0, 91.0, 49.0, 69.0, 27.0];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mood History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 122,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  for (final fraction in [0.25, 0.5, 0.75, 1.0])
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 22 + (constraints.maxHeight - 30) * fraction,
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0DDE1),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: constraints.maxHeight - 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: values.asMap().entries.map((entry) {
                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 20,
                                  height: entry.value,
                                  decoration: BoxDecoration(
                                    color: entry.key == 3
                                        ? const Color(0xFF9CC3A7)
                                        : const Color(0xFFEBC7CD),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  days[entry.key],
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SymptomsView extends StatefulWidget {
  const _SymptomsView({super.key, required this.rose});
  final Color rose;

  @override
  State<_SymptomsView> createState() => _SymptomsViewState();
}

class _SymptomsViewState extends State<_SymptomsView> {
  final _symptomController = TextEditingController();
  final _dateController = TextEditingController();
  String _severity = 'Mild';
  String _category = 'Nausea';
  final List<_LoggedSymptom> _logs = [
    const _LoggedSymptom(
      name: 'Mild nausea',
      severity: 'Mild',
      category: 'Nausea',
      date: '16/08/2026',
    ),
    const _LoggedSymptom(
      name: 'Lower back pain',
      severity: 'Moderate',
      category: 'Pain',
      date: '16/08/2026',
    ),
    const _LoggedSymptom(
      name: 'Heartburn after dinner',
      severity: 'Mild',
      category: 'Digestion',
      date: '14/08/2026',
    ),
    const _LoggedSymptom(
      name: 'Leg cramps during sleep',
      severity: 'Moderate',
      category: 'Cramps',
      date: '13/08/2026',
    ),
    const _LoggedSymptom(
      name: 'Shortness of breath',
      severity: 'Mild',
      category: 'Breathing',
      date: '10/08/2026',
    ),
  ];

  @override
  void dispose() {
    _symptomController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveLog() {
    final name = _symptomController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe a symptom before saving.')),
      );
      return;
    }
    setState(() {
      _logs.insert(
        0,
        _LoggedSymptom(
          name: name,
          severity: _severity,
          category: _category,
          date: _dateController.text.trim().isEmpty
              ? '19/08/2026'
              : _dateController.text.trim(),
        ),
      );
      _symptomController.clear();
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Symptom saved.')));
  }

  void _cancelForm() {
    setState(() {
      _symptomController.clear();
      _dateController.clear();
      _severity = 'Mild';
      _category = 'Nausea';
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Panel(
        padding: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Log Symptom',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _RoundedField(
              controller: _symptomController,
              hintText: 'Describe your symptom...',
            ),
            const SizedBox(height: 12),
            const Text(
              'Severity',
              style: TextStyle(
                fontSize: 12,
                color: _HealthTrackingState._muted,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: ['Mild', 'Moderate', 'Severe']
                  .map(
                    (value) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: _Choice(
                          text: value,
                          selected: _severity == value,
                          onTap: () => setState(() => _severity = value),
                          rose: widget.rose,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 12,
                color: _HealthTrackingState._muted,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  [
                        'Nausea',
                        'Pain',
                        'Digestion',
                        'Cramps',
                        'Breathing',
                        'Swelling',
                      ]
                      .map(
                        (item) => _Tag(
                          text: item,
                          rose: widget.rose,
                          selected: _category == item,
                          onTap: () => setState(() => _category = item),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            _RoundedField(
              controller: _symptomController,
              hintText: 'Type a symptom...',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelForm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _HealthTrackingState._muted,
                      side: BorderSide(color: widget.rose),
                      shape: const StadiumBorder(),
                      minimumSize: const Size(0, 30),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 9)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.rose,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      minimumSize: const Size(0, 30),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Save Log',
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'FILTER BY CATEGORY',
          style: TextStyle(fontSize: 9, color: _HealthTrackingState._muted),
        ),
      ),
      const SizedBox(height: 8),
      _RoundedField(
        controller: _dateController,
        hintText: 'mm/dd/yyyy',
        icon: Icons.calendar_today_outlined,
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            initialDate: DateTime.now(),
          );
          if (picked != null)
            setState(
              () => _dateController.text =
                  '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}',
            );
        },
      ),
      const SizedBox(height: 8),
      ..._logs
          .where(
            (log) =>
                _dateController.text.isEmpty ||
                log.date == _dateController.text,
          )
          .map((log) => _SymptomEntry(log: log, rose: widget.rose)),
    ],
  );
}

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.controller,
    required this.hintText,
    this.icon,
    this.readOnly = false,
    this.onTap,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool readOnly;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    readOnly: readOnly,
    onTap: onTap,
    style: const TextStyle(fontSize: 14, color: _HealthTrackingState._ink),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: _HealthTrackingState._muted,
      ),
      prefixIcon: icon == null
          ? null
          : Icon(icon, size: 13, color: _HealthTrackingState._rose),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE6B9C2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE6B9C2)),
      ),
    ),
  );
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.text,
    required this.selected,
    required this.onTap,
    required this.rose,
  });
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Color rose;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? rose : const Color(0xFFD0D4D6),
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: const StadiumBorder(),
        side: BorderSide(color: selected ? rose : Colors.transparent),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.rose,
    this.selected = false,
    this.onTap,
  });
  final String text;
  final Color rose;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? rose : const Color(0xFFEAC2C9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: selected ? Colors.white : rose),
      ),
    ),
  );
}

class _SymptomEntry extends StatelessWidget {
  const _SymptomEntry({required this.log, required this.rose});
  final _LoggedSymptom log;
  final Color rose;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _HealthTrackingState._surface,
      border: Border.all(color: const Color(0xFFE1DADC)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  _Tag(text: log.severity, rose: rose),
                  const SizedBox(width: 7),
                  _Tag(text: log.category, rose: rose),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              log.date,
              style: const TextStyle(
                fontSize: 10,
                color: _HealthTrackingState._muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Logged',
              style: const TextStyle(
                fontSize: 10,
                color: _HealthTrackingState._muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
