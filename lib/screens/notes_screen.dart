import 'package:flutter/material.dart';
import '../widgets/notes/note_card.dart';
import '../widgets/navigation/custom_bottom_nav_bar.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  backgroundColor: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.8),
                  surfaceTintColor: Colors.transparent,
                  expandedHeight: 180,
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
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.description_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'My Notes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('New Note'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search your notes...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Theme.of(context).hintColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      NoteCard(
                        title: 'Project Alpha Brainstorm',
                        content:
                            'Need to outline the main goals for the Q4 sprint and assign tasks to the team. We should also consider the new API integration requirements...',
                        date: 'Oct 24',
                        tags: const ['Project', 'Strategy'],
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      NoteCard(
                        title: 'Grocery List',
                        content:
                            'Milk, Eggs, Bread, Avocados, Coffee beans (light roast), Sparkling water, Greek yogurt...',
                        date: '2h ago',
                        tags: const ['Personal'],
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      NoteCard(
                        title: 'Design Inspiration',
                        content:
                            'Check out the minimalist layouts from the latest Dribbble collection. Focus on white space and bold typography.',
                        date: 'Yesterday',
                        imageUrl:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDFwho2QLvHQS34GyTba2IlbVsuC1IcgIFtQAL9FaGiV9tXfo_6Xl8NJEPLjIUOEUE5-GKkzCSO_il5m3h5fe_a99xZX095MSLY9Ojen4iDM7Gtk1CbTiEjPIgZym6Vcu9Z0FgZ8cglnsu28NMDGwlkTd1l8cb-JX1d2dEOpTDQSCFbKkIWONOHDXWnJ9NbQJSITJehVr3YrfEoF3179gdbfc_SSRhOcPIurbwDd7YxCRJ3DcChuW2y_SUyo5nBDtT4ZhxYepiAMvVz',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      NoteCard(
                        title: 'Meeting Notes: Client Call',
                        content:
                            'Client wants to move the launch date to mid-November. Need to check with the dev team about the current progress on the auth module.',
                        date: 'Oct 20',
                        tags: const ['Work', 'Urgent'],
                        onTap: () {},
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(currentIndex: 4),
            ),
          ],
        ),
      ),
    );
  }
}
