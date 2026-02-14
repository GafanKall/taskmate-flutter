import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  context,
                  Icons.grid_view_outlined,
                  'Dashboard',
                  currentIndex == 0,
                  0,
                ),
                _buildNavItem(
                  context,
                  Icons.view_kanban_outlined,
                  'Board',
                  currentIndex == 1,
                  1,
                ),
                _buildNavItem(
                  context,
                  Icons.calendar_view_week,
                  'Schedule',
                  currentIndex == 3,
                  3,
                ),
                _buildNavItem(
                  context,
                  Icons.description_outlined,
                  'Notes',
                  currentIndex == 4,
                  4,
                ),
              ],
            ),
          ),
          // Bottom Indicator
          Container(
            height: 4,
            width: 120,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    int index,
  ) {
    final color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).hintColor;
    return InkWell(
      onTap: () {
        if (currentIndex == index) return;

        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamed(context, '/board');
            break;
          case 3:
            Navigator.pushNamed(context, '/schedule');
            break;
          case 4:
            Navigator.pushNamed(context, '/notes');
            break;
          // Add other cases as screens are implemented
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26, fill: isActive ? 1.0 : 0.0),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
