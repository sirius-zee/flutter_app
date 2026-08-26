import 'package:flutter/material.dart';
import 'package:my_app/widgets/atoms/inputs/app_date_picker_field.dart';
import 'package:my_app/widgets/atoms/inputs/app_dropdown_field.dart';
import 'package:my_app/widgets/atoms/inputs/app_option_switcher.dart';
import 'package:my_app/widgets/atoms/inputs/app_text_area_field.dart';
import 'package:my_app/widgets/atoms/inputs/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Additional Form States
  String _selectedGender = 'Laki-laki';
  String? _selectedRole = 'Pengguna';
  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  final List<String> _roles = ['Pengguna', 'Administrator', 'Pengelola'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulasi proses pendaftaran
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Baru'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Silakan isi formulir di bawah ini untuk mendaftar.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Nama Lengkap
                AppTextField(
                  controller: _fullNameController,
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  isRequired: true,
                  prefixIcon: const Icon(Icons.person_outline),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // 2. Email
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'contoh@email.com',
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value != null &&
                        !RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Nomor Telepon
                AppTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hintText: '08123456789',
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // 4. Jenis Kelamin (Option Switcher)
                AppOptionSwitcher<String>(
                  label: 'Jenis Kelamin',
                  isRequired: true,
                  selectedValue: _selectedGender,
                  options: const [
                    OptionItem(
                      value: 'L',
                      label: 'Laki-laki',
                      icon: Icon(Icons.male),
                    ),
                    OptionItem(
                      value: 'P',
                      label: 'Perempuan',
                      icon: Icon(Icons.female),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedGender = val);
                  },
                ),
                const SizedBox(height: 16),

                // 5. Tanggal Lahir (Date Picker)
                AppDatePickerField(
                  label: 'Tanggal Lahir',
                  isRequired: true,
                  enabled: !_isLoading,
                  selectedDate: _selectedBirthDate,
                  onDateSelected: (date) {
                    setState(() => _selectedBirthDate = date);
                  },
                ),
                const SizedBox(height: 16),

                // 6. Peran / Role (Dropdown)
                AppDropdownField<String>(
                  label: 'Peran',
                  isRequired: true,
                  enabled: !_isLoading,
                  value: _selectedRole,
                  prefixIcon: const Icon(Icons.badge_outlined),
                  items: _roles.map((role) {
                    return AppDropdownOption<String>(
                      value: role,
                      label: role,
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedRole = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                AppTextAreaField(
                  label: 'Catatan Tamu',
                  hintText: 'Tuliskan catatan tambahan di sini...',
                  controller: _notesController,
                  isRequired: false,
                  minLines: 3,
                  maxLines: 5,
                  onChanged: (value) {},
                ),

                const SizedBox(height: 16),

                // 7. Password
                AppTextField(
                  controller: _passwordController,
                  label: 'Kata Sandi',
                  hintText: 'Masukkan kata sandi',
                  isPassword: true,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value != null && value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 8. Konfirmasi Password
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Kata Sandi',
                  hintText: 'Ulangi kata sandi',
                  isPassword: true,
                  isRequired: true,
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
