import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/board.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/board/board_task_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';

class BoardDetailScreen extends StatefulWidget {
  const BoardDetailScreen({super.key});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final board = ModalRoute.of(context)!.settings.arguments as Board;
      context.read<TaskProvider>().fetchTasks(boardId: board.id);
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = ModalRoute.of(context)!.settings.arguments as Board;
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    final todoTasks = tasks.where((t) => t.status == 'todo').toList();
    final inProgressTasks = tasks
        .where((t) => t.status == 'in_progress')
        .toList();
    final doneTasks = tasks
        .where((t) => t.status == 'done' || t.completed)
        .toList();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
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
                        child: _buildHeader(context),
                      ),
                    ),
                    toolbarHeight: 64,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: _buildProjectTitle(context, board.name),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Theme.of(context).hintColor,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        tabs: [
                          _buildTab(
                            context,
                            'To Do',
                            todoTasks.length.toString(),
                          ),
                          _buildTab(
                            context,
                            'In Progress',
                            inProgressTasks.length.toString(),
                          ),
                          _buildTab(
                            context,
                            'Done',
                            doneTasks.length.toString(),
                          ),
                        ],
                      ),
                      Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ];
              },
              body: taskProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTaskList(context, todoTasks),
                        _buildTaskList(context, inProgressTasks),
                        _buildTaskList(context, doneTasks),
                      ],
                    ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const CustomBottomNavBar(currentIndex: 1),
            ),

            Positioned(
              right: 24,
              bottom: 110,
              child: FloatingActionButton(
                onPressed: () => _showTaskDialog(context, boardId: board.id),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskDialog(
    BuildContext context, {
    required int boardId,
    Task? task,
  }) {
    final titleController = TextEditingController(text: task?.title);
    String priority = 'Medium';
    if (task?.priority != null && task!.priority!.isNotEmpty) {
      final p = task!.priority!;
      priority = p[0].toUpperCase() + p.substring(1).toLowerCase();
    }
    DateTime? selectedDate = task?.endDate;
    TimeOfDay? selectedTime = task?.endDate != null
        ? TimeOfDay.fromDateTime(task!.endDate!)
        : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(task == null ? 'Create Task' : 'Edit Task'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'What needs to be done?',
                    prefixIcon: const Icon(Icons.assignment_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: ['Low', 'Medium', 'High', 'Urgent'].map((p) {
                    IconData icon;
                    Color color;
                    switch (p.toLowerCase()) {
                      case 'urgent':
                        icon = Icons.bolt_rounded;
                        color = Colors.orange.shade800;
                        break;
                      case 'high':
                        icon = Icons.priority_high_rounded;
                        color = Colors.red;
                        break;
                      case 'low':
                        icon = Icons.low_priority_rounded;
                        color = Colors.green;
                        break;
                      default:
                        icon = Icons.remove_rounded;
                        color = Colors.blue;
                    }
                    return DropdownMenuItem(
                      value: p,
                      child: Row(
                        children: [
                          Icon(icon, color: color, size: 18),
                          const SizedBox(width: 8),
                          Text(p),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => priority = val!),
                  decoration: InputDecoration(
                    labelText: 'Priority Level',
                    prefixIcon: const Icon(Icons.flag_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          selectedDate = date;
                          selectedTime = time;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).hintColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedDate == null || selectedTime == null
                                ? 'Set Deadline (Date & Time)'
                                : 'Due: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute))}',
                            style: TextStyle(
                              color: selectedDate == null
                                  ? Theme.of(context).hintColor
                                  : null,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '* Start date will be set to current time',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final now = DateTime.now();
                  DateTime? finalDeadline;
                  if (selectedDate != null && selectedTime != null) {
                    finalDeadline = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                  }

                  final taskData = {
                    'title': titleController.text,
                    'priority': priority.toLowerCase(),
                    'status': task?.status ?? 'todo',
                    'board_id': boardId,
                    'start_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                    'end_date': finalDeadline != null
                        ? DateFormat(
                            'yyyy-MM-dd HH:mm:ss',
                          ).format(finalDeadline)
                        : null,
                  };

                  final provider = context.read<TaskProvider>();
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  if (task == null) {
                    provider
                        .createTask(taskData)
                        .then((_) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Task created successfully'),
                            ),
                          );
                          navigator.pop();
                        })
                        .catchError((e) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to create task: ${e.toString()}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                  } else {
                    provider
                        .updateTask(task.id, taskData)
                        .then((_) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Task updated successfully'),
                            ),
                          );
                          navigator.pop();
                        })
                        .catchError((e) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to update task: ${e.toString()}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(task == null ? 'Create Task' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              color: Theme.of(context).primaryColor,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Task Board',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CURRENT PROJECT',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          child: Icon(Icons.tune, color: Theme.of(context).hintColor, size: 20),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String title, String count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No tasks in this category',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BoardTaskCard(
            title: task.title,
            dueDate: task.endDate != null
                ? task.endDate.toString().substring(5, 10)
                : 'No due',
            priority: task.priority ?? 'Medium',
            isCompleted: task.completed,
            priorityTextColor: _getPriorityColor(task.priority),
            priorityBgColor: _getPriorityColor(task.priority).withOpacity(0.1),
            onEdit: () =>
                _showTaskDialog(context, boardId: task.boardId, task: task),
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                context.read<TaskProvider>().deleteTask(task.id);
              }
            },
          ),
        );
      },
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _SliverTabDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return false;
  }
}
