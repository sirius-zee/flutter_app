import 'package:flutter/material.dart';

class ActivityListItem extends StatelessWidget {
  final String title;
  final String time;
  final String amount;
  final bool isExpense;
  final VoidCallback? onTap;

  const ActivityListItem({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    this.isExpense = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isExpense
                  ? colors.errorContainer
                  : colors.primaryContainer,
              child: Icon(
                isExpense
                    ? Icons.shopping_bag_outlined
                    : Icons.account_balance_wallet_outlined,
                color: isExpense
                    ? colors.onErrorContainer
                    : colors.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isExpense ? colors.error : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
