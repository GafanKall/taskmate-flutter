import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/dashboard/task_card.dart';
import '../widgets/dashboard/event_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/event_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/dashboard/notification_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
      context.read<EventProvider>().fetchEvents();
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final eventProvider = context.watch<EventProvider>();
    final user = authProvider.user;

    final totalTasks = taskProvider.tasks.length;
    final todoTasks = taskProvider.tasks
        .where((t) => t.status == 'todo')
        .length;
    final inProgressTasks = taskProvider.tasks
        .where((t) => t.status == 'in_progress')
        .length;
    final completedTasks = taskProvider.tasks
        .where((t) => t.status == 'done')
        .length;

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
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.only(
                        top: 48,
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.smart_toy_outlined,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: -0.5,
                                      ),
                                  children: [
                                    const TextSpan(text: 'TASK'),
                                    TextSpan(
                                      text: 'MATE',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Consumer<NotificationProvider>(
                                builder: (context, provider, _) => Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.notifications_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                const NotificationModal(),
                                          );
                                        },
                                      ),
                                    ),
                                    if (provider.unreadCount > 0)
                                      Positioned(
                                        right: 4,
                                        top: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            '${provider.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.logout_rounded,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirm Logout'),
                                        content: const Text(
                                          'Are you sure you want to log out?',
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('Logout'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await authProvider.logout();
                                      if (mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/',
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                  tooltip: 'Logout',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  toolbarHeight: 64,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Hi, ${user?.name ?? 'Guest'}!',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        Text(
                          DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 32),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              StatCard(
                                icon: Icons.assignment_outlined,
                                iconBgColor: const Color(0xFFEFF6FF),
                                iconColor: Colors.blue,
                                value: totalTasks.toString(),
                                title: 'Total Tasks',
                                date: DateFormat(
                                  'MMM y',
                                ).format(DateTime.now()),
                              ),
                              const SizedBox(width: 16),
                              StatCard(
                                icon: Icons.list_alt_outlined,
                                iconBgColor: const Color(0xFFF8FAFC),
                                iconColor: const Color(0xFF64748B),
                                value: todoTasks.toString(),
                                title: 'To Do',
                                date: DateFormat(
                                  'MMM y',
                                ).format(DateTime.now()),
                              ),
                              const SizedBox(width: 16),
                              StatCard(
                                icon: Icons.pending_outlined,
                                iconBgColor: const Color(0xFFFFFBEB),
                                iconColor: Colors.amber,
                                value: inProgressTasks.toString(),
                                title: 'In Progress',
                                date: DateFormat(
                                  'MMM y',
                                ).format(DateTime.now()),
                              ),
                              const SizedBox(width: 16),
                              StatCard(
                                icon: Icons.check_circle_outlined,
                                iconBgColor: const Color(0xFFECFDF5),
                                iconColor: const Color(0xFF10B981),
                                value: completedTasks.toString(),
                                title: 'Completed',
                                date: DateFormat(
                                  'MMM y',
                                ).format(DateTime.now()),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildSectionHeader(
                          context,
                          'Upcoming Tasks',
                          Icons.event_note,
                          'View All →',
                        ),
                        const SizedBox(height: 16),
                        if (taskProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (taskProvider.tasks.isEmpty)
                          const Text('No upcoming tasks')
                        else
                          ...taskProvider.tasks
                              .take(3)
                              .map(
                                (task) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TaskCard(
                                    title: task.title,
                                    dueDate:
                                        task.endDate?.toString().substring(
                                          5,
                                          10,
                                        ) ??
                                        'No date',
                                    status: (task.status ?? 'todo')
                                        .toUpperCase(),
                                    accentColor: _getStatusColor(
                                      task.status ?? 'todo',
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 40),
                        _buildSectionHeader(
                          context,
                          'Today\'s Events',
                          Icons.calendar_month,
                          'Event →',
                        ),
                        const SizedBox(height: 16),
                        if (eventProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (eventProvider.events.isEmpty)
                          const Text('No events today')
                        else
                          ...eventProvider.events
                              .take(2)
                              .map(
                                (event) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: EventCard(
                                    isToday: true,
                                    title: event.title,
                                    accentColor: Theme.of(context).primaryColor,
                                    time: event.allDay
                                        ? 'All Day'
                                        : 'Scheduled',
                                    category: event.category ?? 'General',
                                    categoryIcon: Icons.event,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(currentIndex: 0),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'todo':
        return Colors.blue;
      case 'in_progress':
        return Colors.amber;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    String? actionText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (actionText != null)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
