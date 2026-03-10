import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';

class PredictionHistoryScreen extends StatefulWidget {
  const PredictionHistoryScreen({super.key});

  @override
  State<PredictionHistoryScreen> createState() =>
      _PredictionHistoryScreenState();
}

class _PredictionHistoryScreenState extends State<PredictionHistoryScreen> {
  String _selectedFilter = 'All';

  final List<_HistoryItem> _items = const [
    _HistoryItem(
      id: '1',
      type: HistoryType.skin,
      title: 'Skin disease for Max',
      subtitle: 'Bacterial dermatosis · Mild itching',
      time: 'Today · 10:24 AM',
    ),
    _HistoryItem(
      id: '2',
      type: HistoryType.food,
      title: 'Food suitability for Bella',
      subtitle: 'Chicken · Suitable · No allergy detected',
      time: 'Yesterday · 08:10 PM',
    ),
    _HistoryItem(
      id: '3',
      type: HistoryType.medicine,
      title: 'Medicine suggestion',
      subtitle: 'Fluconazole + Coconut oil · Jaffna',
      time: '2 days ago · 05:42 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    final filtered = _selectedFilter == 'All'
        ? _items
        : _items
            .where((e) => e.type.label == _selectedFilter)
            .toList(growable: false);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.scaleWidth(20),
            vertical: ScreenUtils.scaleHeight(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Review past predictions for your pets.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterRow(),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _HistoryCard(item: filtered[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Skin', 'Food', 'Medicine'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          _selectedFilter == f ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selectedColor: primaryGreenColor.withOpacity(0.16),
                  selected: _selectedFilter == f,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = f;
                    });
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: paleColor3.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 40,
              color: Colors.blueGrey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No history yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Run a prediction to see it appear here.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

enum HistoryType { skin, food, medicine }

extension HistoryTypeX on HistoryType {
  String get label {
    switch (this) {
      case HistoryType.skin:
        return 'Skin';
      case HistoryType.food:
        return 'Food';
      case HistoryType.medicine:
        return 'Medicine';
    }
  }

  IconData get icon {
    switch (this) {
      case HistoryType.skin:
        return Icons.medical_information_outlined;
      case HistoryType.food:
        return Icons.restaurant_outlined;
      case HistoryType.medicine:
        return Icons.medication_outlined;
    }
  }

  Color get badgeColor {
    switch (this) {
      case HistoryType.skin:
        return paleColor3;
      case HistoryType.food:
        return paleColor1;
      case HistoryType.medicine:
        return paleColor4;
    }
  }
}

class _HistoryItem {
  final String id;
  final HistoryType type;
  final String title;
  final String subtitle;
  final String time;

  const _HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.type.badgeColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.type.icon,
              size: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

