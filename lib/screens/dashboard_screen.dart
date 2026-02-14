import 'package:flutter/material.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/dashboard/task_card.dart';
import '../widgets/dashboard/event_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Top Custom App Bar
                SliverAppBar(
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuASfSGXosBs8qUqD_WureXpfX7p-dnOoMPNkL3EmPz4fCBWZGdrBWlmAjgaFo-p4p36OfvuOoe_tcReM0d_C6IeymMYrlcBpvJXJaInSzmxLCwLIcXnrL59pZSmgFtZQQGC751nIabMzhRXcVyoTBXYU_edx3nVdVGYZOpDpq29cw6owyHXVm4nJqEILxbQsnMxq8Q8qedSAVwaREcmWMP1OSUrH1XZTvhAyvPeCdVu_cBN1zFa7xhBZemXXGlwdbN9bH0wUp-RCre7',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
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
                        // Greeting
                        Row(
                          children: [
                            Text(
                              'Good Evening, Kemal!',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        Text(
                          'Wednesday, 04 June 2025',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),

                        const SizedBox(height: 32),

                        // Stats Horizontal Scroll
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: const [
                              StatCard(
                                icon: Icons.assignment_outlined,
                                iconBgColor: Color(0xFFEFF6FF),
                                iconColor: Colors.blue,
                                value: '1',
                                title: 'Total Tasks',
                                date: 'Jun 2025',
                              ),
                              SizedBox(width: 16),
                              StatCard(
                                icon: Icons.list_alt_outlined,
                                iconBgColor: Color(0xFFF8FAFC),
                                iconColor: Color(
                                  0xFF64748B,
                                ), // Slate-500 equivalent
                                value: '1',
                                title: 'To Do',
                                date: 'Jun 2025',
                              ),
                              SizedBox(width: 16),
                              StatCard(
                                icon: Icons.pending_outlined,
                                iconBgColor: Color(0xFFFFFBEB),
                                iconColor: Colors.amber,
                                value: '0',
                                title: 'In Progress',
                                date: 'Jun 2025',
                              ),
                              SizedBox(width: 16),
                              StatCard(
                                icon: Icons.check_circle_outlined,
                                iconBgColor: Color(0xFFECFDF5),
                                iconColor: Color(0xFF10B981), // Emerald-500
                                value: '0',
                                title: 'Completed',
                                date: 'Jun 2025',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Upcoming Tasks Section
                        _buildSectionHeader(
                          context,
                          'Upcoming Tasks',
                          Icons.event_note,
                          'View All →',
                        ),
                        const SizedBox(height: 16),
                        const TaskCard(
                          title: 'Tugas DFD',
                          dueDate: 'Jun 07',
                          status: 'Todo',
                          accentColor: Color(0xFFF43F5E), // Rose-500
                        ),

                        const SizedBox(height: 40),

                        // Today's Events Section
                        _buildSectionHeader(
                          context,
                          'Today\'s Events',
                          Icons.calendar_month,
                          'Event →',
                        ),
                        const SizedBox(height: 16),
                        const EventCard(
                          isToday: true,
                          title: 'UI/UX Design Project',
                          accentColor: Color(0xFFF43F5E), // Rose-500
                          time: 'All Day',
                          category: 'Work',
                          categoryIcon: Icons.work_outline,
                        ),

                        const SizedBox(height: 40),

                        // Upcoming Events Section
                        _buildSectionHeader(
                          context,
                          'Upcoming Events',
                          Icons.notifications_active,
                          null,
                        ),
                        const SizedBox(height: 16),
                        const EventCard(
                          title: 'Summer Holiday',
                          accentColor: Colors.amber,
                          month: 'Jun',
                          day: '05',
                          description: 'Annual vacation break',
                        ),

                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation
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
