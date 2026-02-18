import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/board.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/board/board_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';
import '../providers/board_provider.dart';
import '../providers/task_provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardProvider>().fetchBoards();
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = context.watch<BoardProvider>();
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Top Custom App Bar (Same as before but with real user data if available)
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
                        Text(
                          'Your Boards',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),

                        const SizedBox(height: 32),

                        // Summary Row
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: Icons.assignment_outlined,
                                iconBgColor: const Color(0xFFEFF6FF),
                                iconColor: Colors.blue,
                                value: taskProvider.tasks.length.toString(),
                                title: 'Total Tasks',
                                date: '',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatCard(
                                icon: Icons.list_alt_outlined,
                                iconBgColor: const Color(0xFFF1F5F9),
                                iconColor: const Color(0xFF64748B),
                                value: taskProvider.tasks
                                    .where(
                                      (t) =>
                                          t.status == 'pending' ||
                                          t.status == 'in-progress',
                                    )
                                    .length
                                    .toString(),
                                title: 'To Do',
                                date: '',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Boards',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Show Create Board Dialog
                                _showCreateBoardDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Create Board',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Boards List
                        if (boardProvider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (boardProvider.boards.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                'No boards found. Create one!',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          )
                        else
                          ...boardProvider.boards
                              .map(
                                (board) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/board-detail',
                                      arguments: board,
                                    ),
                                    child: BoardCard(
                                      title: board.name,
                                      onEdit: () => _showCreateBoardDialog(
                                        context,
                                        board: board,
                                      ),
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Board'),
                                            content: const Text(
                                              'Are you sure you want to delete this board? All tasks within will be permanently removed.',
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
                                                  backgroundColor: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
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
                                          boardProvider.deleteBoard(board.id);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),

                        const SizedBox(height: 120),
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
              child: CustomBottomNavBar(currentIndex: 1),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBoardDialog(BuildContext context, {Board? board}) {
    final nameController = TextEditingController(text: board?.name);
    final descController = TextEditingController(text: board?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(board == null ? 'Create Board' : 'Edit Board'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Board Name'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
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
              if (nameController.text.isNotEmpty) {
                if (board == null) {
                  context.read<BoardProvider>().createBoard(
                    nameController.text,
                    descController.text,
                  );
                } else {
                  context.read<BoardProvider>().updateBoard(
                    board.id,
                    nameController.text,
                    descController.text,
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(board == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }
}
