import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardTitle =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'Task Board';

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
                      child: _buildProjectTitle(context, boardTitle),
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
                          _buildTab(context, 'To Do', _getCount(boardTitle, 0)),
                          _buildTab(
                            context,
                            'In Progress',
                            _getCount(boardTitle, 1),
                          ),
                          _buildTab(context, 'Done', _getCount(boardTitle, 2)),
                        ],
                      ),
                      Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTodoContent(context, boardTitle),
                  _buildInProgressContent(context, boardTitle),
                  _buildDoneContent(context, boardTitle),
                ],
              ),
            ),

            // Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const CustomBottomNavBar(currentIndex: 1),
            ),

            // FAB
            Positioned(
              right: 24,
              bottom: 110,
              child: FloatingActionButton(
                onPressed: () {},
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

  String _getCount(String boardTitle, int tabIndex) {
    if (boardTitle == 'Project UKK') {
      return tabIndex == 0
          ? '4'
          : tabIndex == 1
          ? '2'
          : '8';
    } else if (boardTitle == 'Project PKL') {
      return tabIndex == 0
          ? '2'
          : tabIndex == 1
          ? '1'
          : '3';
    } else {
      return tabIndex == 0
          ? '1'
          : tabIndex == 1
          ? '0'
          : '5';
    }
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
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).hintColor),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBwbK4Z-GXA5giXG_lilq6Epo5I728jllKF65_Z8Q6XbsVadnyGbd-BIOP-aaCdL9VsS5ucTI-D7jSQEcxQicDQvX3lt7PYjRk-GNOfQc8rSSxQN0fMyf1U2Ners4raOBW5DNZqQZsok4ICXje2SY6wnun_9jV32wmWNJHOYtc508n26V7WNu0lxw3ARpoyBNnwazmck2AKWCL9bSx_Jd7PluO0BokkCdu32C40jgMkYOk4qOqjNmUb6uBXd2unIt9kU1vdwria-p3Z',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
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
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.expand_more,
                  color: Theme.of(context).hintColor.withOpacity(0.5),
                ),
              ],
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

  Widget _buildTodoContent(BuildContext context, String boardTitle) {
    if (boardTitle == 'Project UKK') {
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
        children: [
          BoardTaskCard(
            title: 'Design User Authentication Wireframes',
            dueDate: 'Jun 07',
            priority: 'High Priority',
            priorityBgColor: Colors.red.withOpacity(0.1),
            priorityTextColor: Colors.red,
            memberAvatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCI7hGRD-0gxInmagteGfTpT1YTN-nG7Os2lEhPLsJL5-7SrJKe9qOoWjOLNGG-immI2uoS-IthfGH9GsTVEyqEQNu9vjMdppGHK_QA2L9m-kQPhdA5zLIPGFQg6PNyx7_-ATfZfa_OTN2dVynDY9xgFHL1D3ZkfjaISvPdVu5BIEsPD48L97BfogND33FNlVfJi9df_us2E80YaMuh186z9CiWbRzK2fOv59E0zPB3nff4zJOx06mUH9IB1uv_aTznUzW5l7uDAkYX',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBA5FGQvwHJdlz0E7GvP8154NKk27SNkftH8gZwQGO7InGhxyExvzGx8yfxJqfsB_Sn25ZH90MH7g1QRmwyRIQfeEQKppNvdRWTO5sf4XPWcjbv8lf5id--uxNUzRk5eGDxSHJXEplhuEvSrO6d3Jqz8IeLsOlSkHrjgXiSabApKH1rYXXqEBMBE0_71R7D3i4_vkSkVEIsNK1CWqMsOZqF86eESdxnYHfPqmP4QjxzgQ4QuIIPLhTMT2MeZ7vwpXxg5J4l6OdnqvO0',
            ],
          ),
          const SizedBox(height: 16),
          BoardTaskCard(
            title: 'Review Client Feedback for Logo',
            dueDate: 'Jun 09',
            priority: 'Medium',
            priorityBgColor: Colors.blue.withOpacity(0.1),
            priorityTextColor: Colors.blue,
            hasAttachment: true,
            memberAvatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBgJhr-FU3QDvhnvEN1YE_Og8a6FFcKLT0TRqtCE2KWHJnkIOU36oqN3QYGoxV3WqPssxuG7Cr8xdi27QZOxBMt1w7ak39RijZ9r-LMWKU1xFwmwpXBgRWL7owv-XwDtF8qcL2XVAtFJU4RXC6XihPqTFCYq3pWAoe9uWeM-j0CFHBeLr95Ag8AN0xWx1041V1XXJ2TT0PY1NabRx7jwbhGtTgenJCCCRHZf2Z2ekIQ72M7nwwmTiAzGp-12TVHho9lF6So5X_Hysvd',
            ],
          ),
          const SizedBox(height: 16),
          BoardTaskCard(
            title: 'Prepare Assets for Dev Handoff',
            dueDate: 'Jun 12',
            priority: 'Low',
            priorityBgColor: Colors.green.withOpacity(0.1),
            priorityTextColor: Colors.green,
            memberAvatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBgJhr-FU3QDvhnvEN1YE_Og8a6FFcKLT0TRqtCE2KWHJnkIOU36oqN3QYGoxV3WqPssxuG7Cr8xdi27QZOxBMt1w7ak39RijZ9r-LMWKU1xFwmwpXBgRWL7owv-XwDtF8qcL2XVAtFJU4RXC6XihPqTFCYq3pWAoe9uWeM-j0CFHBeLr95Ag8AN0xWx1041V1XXJ2TT0PY1NabRx7jwbhGtTgenJCCCRHZf2Z2ekIQ72M7nwwmTiAzGp-12TVHho9lF6So5X_Hysvd',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCI7hGRD-0gxInmagteGfTpT1YTN-nG7Os2lEhPLsJL5-7SrJKe9qOoWjOLNGG-immI2uoS-IthfGH9GsTVEyqEQNu9vjMdppGHK_QA2L9m-kQPhdA5zLIPGFQg6PNyx7_-ATfZfa_OTN2dVynDY9xgFHL1D3ZkfjaISvPdVu5BIEsPD48L97BfogND33FNlVfJi9df_us2E80YaMuh186z9CiWbRzK2fOv59E0zPB3nff4zJOx06mUH9IB1uv_aTznUzW5l7uDAkYX',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBA5FGQvwHJdlz0E7GvP8154NKk27SNkftH8gZwQGO7InGhxyExvzGx8yfxJqfsB_Sn25ZH90MH7g1QRmwyRIQfeEQKppNvdRWTO5sf4XPWcjbv8lf5id--uxNUzRk5eGDxSHJXEplhuEvSrO6d3Jqz8IeLsOlSkHrjgXiSabApKH1rYXXqEBMBE0_71R7D3i4_vkSkVEIsNK1CWqMsOZqF86eESdxnYHfPqmP4QjxzgQ4QuIIPLhTMT2MeZ7vwpXxg5J4l6OdnqvO0',
            ],
          ),
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
        children: [
          BoardTaskCard(
            title: 'Initial Research for $boardTitle',
            dueDate: 'Jun 15',
            priority: 'Medium',
            memberAvatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCI7hGRD-0gxInmagteGfTpT1YTN-nG7Os2lEhPLsJL5-7SrJKe9qOoWjOLNGG-immI2uoS-IthfGH9GsTVEyqEQNu9vjMdppGHK_QA2L9m-kQPhdA5zLIPGFQg6PNyx7_-ATfZfa_OTN2dVynDY9xgFHL1D3ZkfjaISvPdVu5BIEsPD48L97BfogND33FNlVfJi9df_us2E80YaMuh186z9CiWbRzK2fOv59E0zPB3nff4zJOx06mUH9IB1uv_aTznUzW5l7uDAkYX',
            ],
          ),
        ],
      );
    }
  }

  Widget _buildInProgressContent(BuildContext context, String boardTitle) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
      children: [
        BoardTaskCard(
          title: boardTitle == 'Project UKK'
              ? 'Interactive Prototyping in Figma'
              : 'Setting up Repository',
          dueDate: 'Due Today',
        ),
      ],
    );
  }

  Widget _buildDoneContent(BuildContext context, String boardTitle) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 180),
      children: [
        BoardTaskCard(
          title: boardTitle == 'Project UKK'
              ? 'User Persona Research'
              : 'Project Selection',
          dueDate: 'Jun 02',
          isCompleted: true,
        ),
      ],
    );
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
