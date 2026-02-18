import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';
import '../providers/event_provider.dart';
import '../providers/weekly_schedule_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
      context.read<WeeklyScheduleProvider>().fetchSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final scheduleProvider = context.watch<WeeklyScheduleProvider>();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.8),
                  surfaceTintColor: Colors.transparent,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                        left: 24,
                        right: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Schedule',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (eventProvider.isLoading || scheduleProvider.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Group by day of week for weekly schedule
                        ...[
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ].map((day) {
                          final daySchedules = scheduleProvider.schedules
                              .where(
                                (s) =>
                                    s.dayOfWeek.toLowerCase() ==
                                    day.toLowerCase(),
                              )
                              .toList();
                          final isToday =
                              DateFormat('EEEE').format(DateTime.now()) == day;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildDaySection(
                              context,
                              day,
                              '', // Could add date if we wanted to match events
                              isToday: isToday,
                              isEmpty: daySchedules.isEmpty,
                              activities: daySchedules
                                  .map(
                                    (s) => _buildActivityCard(
                                      context,
                                      s.title,
                                      s.startTime,
                                      s.endTime,
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Delete Schedule',
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this activity?',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          scheduleProvider.deleteSchedule(s.id);
                                        }
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 120),
                      ]),
                    ),
                  ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(currentIndex: 3),
            ),
            Positioned(
              bottom: 100,
              right: 24,
              child: FloatingActionButton(
                onPressed: () => _showAddScheduleDialog(context),
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(
    BuildContext context,
    String day,
    String date, {
    List<Widget> activities = const [],
    bool isToday = false,
    bool isEmpty = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isToday
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : Theme.of(context).dividerColor.withOpacity(0.05),
          width: isToday ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isToday
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).dividerColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: isToday
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No activities',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )
                else
                  ...activities,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    String startTime,
    String endTime, {
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTimeBadge(context, startTime),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              _buildTimeBadge(context, endTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(BuildContext context, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final activityController = TextEditingController();
    final startTimeController = TextEditingController(text: '08:00');
    final endTimeController = TextEditingController(text: '09:00');
    String selectedDay = 'Monday';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityController,
              decoration: const InputDecoration(labelText: 'Activity'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDay,
              items:
                  [
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday',
                      ]
                      .map(
                        (day) => DropdownMenuItem(value: day, child: Text(day)),
                      )
                      .toList(),
              onChanged: (val) => selectedDay = val!,
              decoration: const InputDecoration(labelText: 'Day'),
            ),
            TextField(
              controller: startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time (HH:mm)',
              ),
            ),
            TextField(
              controller: endTimeController,
              decoration: const InputDecoration(labelText: 'End Time (HH:mm)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (activityController.text.isNotEmpty) {
                final provider = context.read<WeeklyScheduleProvider>();
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                provider
                    .createSchedule({
                      'title': activityController.text,
                      'day_of_week': selectedDay.toLowerCase(),
                      'start_time': startTimeController.text,
                      'end_time': endTimeController.text,
                    })
                    .then((_) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Schedule added successfully'),
                        ),
                      );
                      navigator.pop();
                    })
                    .catchError((e) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to add schedule: ${e.toString()}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
