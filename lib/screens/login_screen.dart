import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/widgets/atoms/app_button.dart';
import 'package:my_app/widgets/atoms/theme_mode_selector.dart';
import 'package:my_app/widgets/atoms/inputs/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  final String heroTag;

  const LoginScreen({super.key, this.heroTag = 'app_logo_hero'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _formAnimationController;
  late Animation<double> _formFadeAnimation;
  late Animation<Offset> _formSlideAnimation;

  // Controller & Form Key
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // State Loading Simulasi Login
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _formFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formAnimationController, curve: Curves.easeIn),
    );

    _formSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _formAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _formAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Handling Login Async dengan Loading Delay ---
  Future<void> _handleLogin() async {
    // if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // final username = _usernameController.text.trim();
    // final password = _passwordController.text.trim();

    // Simulasi jeda request API jaringan
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // if (username == 'admin' && password == 'admin') {
    //   NotificationService.success(
    //     'Selamat datang kembali, Admin!',
    //     title: 'Login Berhasil',
    //   );

    Navigator.pushReplacementNamed(context, '/home');
    // } else {
    //   NotificationService.error(
    //     'Username atau Password salah. Gunakan "admin"',
    //     title: 'Login Gagal',
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // --- Theme Switcher ---
                      FadeTransition(
                        opacity: _formFadeAnimation,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ThemeModeSelector(
                              type: ThemeSelectorType.loopButton,
                              showLabels: true,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // --- Hero Logo ---
                      Hero(
                        tag: widget.heroTag,
                        child: SvgPicture.asset(
                          'assets/logo1.svg',
                          width: 120,
                          height: 120,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- Form Login ---
                      FadeTransition(
                        opacity: _formFadeAnimation,
                        child: SlideTransition(
                          position: _formSlideAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Welcome Back!',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Field Username dengan Validasi
                              AppTextField(
                                label: 'Username',
                                hintText: 'Masukkan username Anda',
                                prefixIcon: const Icon(Icons.person_outline),
                                controller: _usernameController,
                                enabled: !_isLoading,
                                isRequired: true,
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val != null && val.trim().length < 3) {
                                    return 'Username minimal 3 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Field Password dengan Validasi
                              AppTextField(
                                label: 'Password',
                                hintText: 'Masukkan password Anda',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                isPassword: true,
                                controller: _passwordController,
                                enabled: !_isLoading,
                                isRequired: true,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleLogin(),
                                validator: (val) {
                                  if (val != null && val.trim().length < 4) {
                                    return 'Password minimal 4 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Reusable Button dengan State Loading
                              AppButton(
                                text: 'LOGIN',
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _handleLogin,
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  GestureDetector(
                                    onTap: _isLoading
                                        ? null
                                        : () {
                                            Navigator.pushNamed(
                                              context,
                                              '/register',
                                            );
                                          },
                                    child: Text(
                                      'Register',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: colors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // --- Footer ---
                      if (!isKeyboardOpen)
                        FadeTransition(
                          opacity: _formFadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 24.0,
                              bottom: 16.0,
                            ),
                            child: Text(
                              '© ${DateTime.now().year} My Awesome App. All rights reserved.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
