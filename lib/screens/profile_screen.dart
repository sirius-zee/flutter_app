import 'package:flutter/material.dart';
import 'package:my_app/core/services/notification_service.dart';
import 'package:my_app/widgets/atoms/dialogs/logout_confirm_dialog.dart';
import 'package:my_app/widgets/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // 1. Tampilkan dialog konfirmasi
    final bool? confirmed = await LogoutConfirmDialog.show(context);

    // 2. Jika pengguna menekan "Keluar"
    if (confirmed == true && context.mounted) {
      // TODO: Masukkan logika membersihkan session/token di sini jika ada

      // 3. Tampilkan toast notification menggunakan NotificationService kamu
      NotificationService.info(
        'Kamu telah berhasil keluar dari akun',
        title: 'Sampai Jumpa!',
      );

      // 4. Navigasi kembali ke halaman Login & hapus seluruh tumpukan halaman
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- 1. Header Profil & Avatar ---
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: colors.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'John Doe',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // --- 2. Pengaturan Akun ---
            _buildSectionTitle(context, 'Pengaturan Akun'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colors.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profil',
                    subtitle: 'Ubah nama, nomor HP, dan email',
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Keamanan & Sandi',
                    subtitle: 'Atur ulang kata sandi & PIN',
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi',
                    subtitle: 'Atur preferensi pemberitahuan',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 3. Lainnya ---
            _buildSectionTitle(context, 'Lainnya'),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colors.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Syarat & Ketentuan',
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang Aplikasi',
                    trailing: Text(
                      'v1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 4. Tombol Logout ---
            Card(
              elevation: 0,
              color: colors.errorContainer.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.error.withValues(alpha: 0.2)),
              ),
              child: ProfileMenuItem(
                icon: Icons.logout_rounded,
                title: 'Keluar dari Akun',
                textColor: colors.error,
                iconColor: colors.error,
                trailing: const SizedBox.shrink(),
                onTap: () => _handleLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
