import 'package:flutter/material.dart';
import 'package:my_app/widgets/features/home/presentation/widgets/activity_list_item.dart';
import 'package:my_app/widgets/features/home/presentation/widgets/home_header.dart';
import 'package:my_app/widgets/features/home/presentation/widgets/home_summary_card.dart';
import 'package:my_app/widgets/features/home/presentation/widgets/quick_action_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Profil
              HomeHeader(userName: 'John Doe', onNotificationTap: () {}),
              const SizedBox(height: 24),

              // 2. Summary Card
              const HomeSummaryCard(
                totalBalance: 'Rp 12.450.000',
                income: '+Rp 3.200.000',
                expense: '-Rp 1.150.000',
              ),
              const SizedBox(height: 28),

              // 3. Akses Cepat Grid
              Text(
                'Akses Cepat',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              QuickActionGrid(
                items: [
                  QuickActionItem(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Transfer',
                    onTap: () {},
                  ),
                  QuickActionItem(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Pindai QR',
                    onTap: () {},
                  ),
                  QuickActionItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Top Up',
                    onTap: () {},
                  ),
                  QuickActionItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Lainnya',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 4. Activity Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas Terbaru',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 5. Activity List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final isExpense = index % 2 == 0;
                  return ActivityListItem(
                    title: isExpense
                        ? 'Pembelian Belanja'
                        : 'Penerimaan Transfer',
                    time: 'Hari ini, 14:30',
                    amount: isExpense ? '-Rp 150.000' : '+Rp 500.000',
                    isExpense: isExpense,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
