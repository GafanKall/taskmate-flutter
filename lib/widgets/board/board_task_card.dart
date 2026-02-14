import 'package:flutter/material.dart';

class BoardTaskCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final String? priority;
  final Color? priorityBgColor;
  final Color? priorityTextColor;
  final List<String> memberAvatars;
  final bool hasAttachment;
  final bool isCompleted;

  const BoardTaskCard({
    super.key,
    required this.title,
    required this.dueDate,
    this.priority,
    this.priorityBgColor,
    this.priorityTextColor,
    this.memberAvatars = const [],
    this.hasAttachment = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (priority != null || isCompleted)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).dividerColor.withOpacity(0.1), // Grayish for completed
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  )
                else if (priority != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: priorityBgColor ?? Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      priority!.toUpperCase(),
                      style: TextStyle(
                        color: priorityTextColor ?? Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).hintColor.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Theme.of(context).hintColor : null,
            ),
          ),
          if (isCompleted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Finished on $dueDate',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.05),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Theme.of(context).hintColor,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Due $dueDate',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasAttachment) ...[
                      Icon(
                        Icons.attach_file,
                        size: 14,
                        color: Theme.of(context).hintColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                    ],
                    _buildMemberAvatars(context),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberAvatars(BuildContext context) {
    if (memberAvatars.isEmpty) return const SizedBox();

    const maxVisibleAvatars = 2;
    final visibleAvatars = memberAvatars.take(maxVisibleAvatars).toList();
    final remainingCount = memberAvatars.length - maxVisibleAvatars;

    return Row(
      children: [
        SizedBox(
          height: 24,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: visibleAvatars.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: -8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 11,
                  backgroundImage: NetworkImage(visibleAvatars[index]),
                ),
              );
            },
          ),
        ),
        if (remainingCount > 0)
          Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '+$remainingCount',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
      ],
    );
  }
}
