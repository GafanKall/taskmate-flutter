import 'package:flutter/material.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/board/board_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

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
                  automaticallyImplyLeading: false, // No back button
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
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withOpacity(0.1),
                                  ),
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
                                    size: 20,
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
                        // Title
                        Text(
                          'Your Boards',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Wednesday, 04 June 2025',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),

                        const SizedBox(height: 32),

                        // Summary Row
                        Row(
                          children: const [
                            Expanded(
                              child: StatCard(
                                icon: Icons.assignment_outlined,
                                iconBgColor: Color(0xFFEFF6FF),
                                iconColor: Colors.blue,
                                value: '1',
                                title: 'Total Tasks',
                                date: '', // No date in HTML board design
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: StatCard(
                                icon: Icons.list_alt_outlined,
                                iconBgColor: Color(0xFFF1F5F9),
                                iconColor: Color(
                                  0xFF64748B,
                                ), // Slate-500 equivalent
                                value: '1',
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
                              onPressed: () {},
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
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/board-detail',
                            arguments: 'Project UKK',
                          ),
                          child: BoardCard(
                            title: 'Project UKK',
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/board-detail',
                            arguments: 'Project PKL',
                          ),
                          child: BoardCard(
                            title: 'Project PKL',
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/board-detail',
                            arguments: 'Cashier App',
                          ),
                          child: BoardCard(
                            title: 'Cashier App',
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        ),

                        const SizedBox(height: 120), // Space for bottom nav
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
              child: CustomBottomNavBar(currentIndex: 1),
            ),
          ],
        ),
      ),
    );
  }
}
