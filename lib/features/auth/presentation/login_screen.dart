import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/shared_widgets/modern_input.dart';
import 'package:genet_church_portal/shared_widgets/responsive_layout.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/localization/app_localization.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';


class BibleVerse {
  final String reference;
  final String text;
  BibleVerse({required this.reference, required this.text});

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      reference: json['reference'] as String,
      text: (json['text'] as String).replaceAll('\n', ' ').trim(),
    );
  }
}

final bibleVerseProvider = FutureProvider.autoDispose<BibleVerse>((ref) async {
  final dio = Dio();
  final response = await dio.get('https://bible-api.com/random');
  return BibleVerse.fromJson(response.data);
});

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use flutter_animate for background loop
    final backgroundController = useAnimationController(
      duration: const Duration(seconds: 20),
    )..repeat();

    return Scaffold(
      body: ResponsiveLayout(
        mobileBreakpoint: 900,
        mobileBody: _LoginSmallScreenView(
          backgroundController: backgroundController,
        ),
        desktopBody: _LoginDesktopView(
          backgroundController: backgroundController,
        ),
      ),
    );
  }
}

class _LoginDesktopView extends ConsumerWidget {
  final AnimationController backgroundController;

  const _LoginDesktopView({required this.backgroundController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final verseAsync = ref.watch(bibleVerseProvider);

    return Row(
      children: [
        // Left Panel - Ultra Modern Design
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(gradient: appColors.primaryGradient),
            child: Stack(
              children: [
                // Animated Background
                AnimatedBuilder(
                  animation: backgroundController,
                  builder: (context, child) => CustomPaint(
                    painter: _UltraModernBackgroundPainter(
                      backgroundController.value,
                      theme.colorScheme.primary,
                    ),
                    size: Size.infinite,
                  ),
                ),

                // Glass Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModernLogo()
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.2),
                      const SizedBox(height: 60),

                      // Bible Verse Section
                      verseAsync
                          .when(
                            data: (verse) => _VerseDisplay(
                              reference: verse.reference,
                              text: verse.text,
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            error: (e, s) => const _VerseDisplay(
                              reference: 'John 15:16',
                              text:
                                  'You did not choose me, but I chose you and appointed you that you should go and bear fruit and that your fruit should abide, so that whatever you ask the Father in my name, he may give it to you',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 800.ms)
                          .slideX(begin: -0.1),

                      const SizedBox(height: 60),

                      // Features
                      Wrap(
                            spacing: 20,
                            runSpacing: 12,
                            children: [
                              _buildFeatureIndicator('Role-Based Access'),
                              _buildFeatureIndicator('Centralized Management'),
                              _buildFeatureIndicator('Insightful Analytics'),
                            ],
                          )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 800.ms)
                          .slideY(begin: 0.2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Panel - Login Form
        Expanded(
          flex: 4,
          child: Container(
            color: appColors.scaffold,
            child: const _LoginForm()
                .animate()
                .fadeIn(duration: 1000.ms)
                .slideX(begin: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildModernLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Center(
            child: Image.asset('assets/images/logo.png', height: 50, width: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIndicator(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.white.withValues(alpha: 0.95),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _VerseDisplay extends StatelessWidget {
  final String reference;
  final String text;
  final double bookFontSize;
  final double chapterVerseFontSize;
  final double textFontSize;
  final double? boxMaxWidth;
  final EdgeInsets boxPadding;
  final double gapHeight;

  const _VerseDisplay({
    required this.reference,
    required this.text,
    this.bookFontSize = 72,
    this.chapterVerseFontSize = 32,
    this.textFontSize = 18,
    this.boxMaxWidth = 500,
    this.boxPadding = const EdgeInsets.all(32),
    this.gapHeight = 30,
  });

  @override
  Widget build(BuildContext context) {
    final parts = reference.split(RegExp(r'\s(?=\d)'));
    final book = parts.length > 1 ? parts[0] : reference;
    final chapterVerse = parts.length > 1 ? parts[1] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: max(8.0, bookFontSize * 0.2),
          runSpacing: 8.0,
          children: [
            Text(
              book,
              style: TextStyle(
                fontSize: bookFontSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
                letterSpacing: -2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            if (chapterVerse.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: bookFontSize * 0.1),
                child: Text(
                  chapterVerse,
                  style: TextStyle(
                    fontSize: chapterVerseFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: gapHeight),
        Container(
          constraints: BoxConstraints(
            maxWidth: boxMaxWidth ?? MediaQuery.of(context).size.width,
          ),
          padding: boxPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Text(
              '"$text"',
              style: TextStyle(
                fontSize: textFontSize,
                color: Colors.white.withValues(alpha: 0.95),
                height: 1.6,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginSmallScreenView extends ConsumerWidget {
  final AnimationController backgroundController;

  const _LoginSmallScreenView({required this.backgroundController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final verseAsync = ref.watch(bibleVerseProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    final double headerHeight = max(size.height * 0.45, 380.0);
    final double logoSize = isTablet ? 70.0 : 50.0;
    final double logoIconSize = logoSize * 0.5;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: headerHeight,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(gradient: appColors.primaryGradient),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: backgroundController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _UltraModernBackgroundPainter(
                        backgroundController.value,
                        theme.colorScheme.primary,
                      ),
                      size: Size.infinite,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 20.0,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isTablet ? 24 : 16),
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: logoIconSize,
                            ),
                          ),
                        ).animate().fadeIn().scale(),
                        SizedBox(height: isTablet ? 24 : 16),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: verseAsync
                                  .when(
                                    data: (verse) => _VerseDisplay(
                                      reference: verse.reference,
                                      text: verse.text,
                                      bookFontSize: isTablet ? 42 : 32,
                                      chapterVerseFontSize: isTablet ? 24 : 20,
                                      textFontSize: isTablet ? 15 : 13.5,
                                      boxPadding: EdgeInsets.all(
                                        isTablet ? 20 : 16,
                                      ),
                                      boxMaxWidth: size.width * 0.85,
                                      gapHeight: isTablet ? 20 : 12,
                                    ),
                                    loading: () => const Center(
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    error: (e, s) => _VerseDisplay(
                                      reference: 'Ethiopian Genet Church',
                                      text: loc.welcomeToMinistry,
                                      bookFontSize: isTablet ? 42 : 32,
                                      chapterVerseFontSize: 0,
                                      textFontSize: isTablet ? 15 : 14,
                                      boxPadding: EdgeInsets.all(
                                        isTablet ? 20 : 16,
                                      ),
                                      boxMaxWidth: size.width * 0.85,
                                      gapHeight: 10,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 300.ms)
                                  .slideY(begin: 0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: appColors.scaffold,
            constraints: BoxConstraints(minHeight: size.height * 0.55),
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 40 : 24,
              horizontal: 16,
            ),
            child: const _LoginForm()
                .animate()
                .fadeIn(delay: 500.ms)
                .slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends HookConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();

    // Button animation
    final buttonController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );
    final buttonScale = useAnimation(
      Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: buttonController, curve: Curves.easeInOut),
      ),
    );

    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        final savedEmail = prefs.getString('email');
        if (savedEmail != null) {
          emailController.text = savedEmail;
          rememberMe.value = true;
        }
      });
      return null;
    }, []);

    void submitForm() async {
      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }
      if (isLoading.value) return;
      isLoading.value = true;
      buttonController.forward();
      try {
        await ref
            .read(authStateProvider.notifier)
            .login(
              emailController.text,
              passwordController.text,
              rememberMe.value,
            );
        if (context.mounted) {
          final user = ref.read(authStateProvider);
          final firstName = user?.fullName.split(' ').first ?? '';
          context.showSuccessNotification(
            title: 'Welcome Back, $firstName!',
            message: 'Login successful. Redirecting to dashboard...',
          );
          await Future.delayed(const Duration(milliseconds: 500));
          context.go('/dashboard');
        }
      } on DioException catch (e) {
        if (!context.mounted) return;
        String message = 'Login Failed: An unknown error occurred.';
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'The server is not responding. Please try again later.';
        } else if (e.response?.statusCode == 401) {
          message = 'Login Failed: Invalid credentials provided.';
        }
        context.showErrorNotification(title: 'Login Failed', message: message);
      } catch (e) {
        if (!context.mounted) return;
        context.showErrorNotification(
          title: 'Login Failed',
          message: 'An unexpected error occurred. Please try again.',
        );
      } finally {
        if (context.mounted) {
          isLoading.value = false;
          buttonController.reverse();
        }
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmall ? 8.0 : 32.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.welcomeBack,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: appColors.textPrimary,
                    fontSize: isSmall ? 28 : 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: isSmall ? 8 : 12),
                Text(
                  loc.signInPrompt,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appColors.textSecondary,
                    fontSize: isSmall ? 15 : 16,
                  ),
                ),
                SizedBox(height: isSmall ? 32 : 48),

                // Inputs
                EmailInput(
                  controller: emailController,
                  size: isSmall ? InputSize.medium : InputSize.large,
                  label: loc.usernameOrEmail,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
                ),
                SizedBox(height: isSmall ? 16 : 24),
                PasswordInput(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  size: isSmall ? InputSize.medium : InputSize.large,
                  onFieldSubmitted: (_) => submitForm(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.passwordRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: isSmall ? 16 : 24),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Transform.scale(
                            scale: isSmall ? 0.8 : 0.9,
                            child: Checkbox(
                              value: rememberMe.value,
                              onChanged: (val) =>
                                  rememberMe.value = val ?? false,
                              activeColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.rememberMe,
                          style: TextStyle(
                            fontSize: isSmall ? 13 : 14,
                            color: appColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.showInfoNotification(
                          title: 'Coming Soon',
                          message:
                              'Forgot Password feature is currently being developed.',
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        loc.forgotPassword,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: isSmall ? 13 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmall ? 32 : 40),

                // Submit Button
                Transform.scale(
                  scale: buttonScale,
                  child: Container(
                    width: double.infinity,
                    height: isSmall ? 50 : 58,
                    decoration: BoxDecoration(
                      gradient: appColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: submitForm,
                        child: Center(
                          child: isLoading.value
                              ? SizedBox(
                                  height: isSmall ? 20 : 24,
                                  width: isSmall ? 20 : 24,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  loc.signIn,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmall ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isSmall ? 32 : 40),

                // Help Section
                Container(
                  padding: EdgeInsets.all(isSmall ? 16 : 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.message_question,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.needHelp,
                              style: TextStyle(
                                color: appColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.contactAdmin,
                              style: TextStyle(
                                color: appColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _UltraModernBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;

  _UltraModernBackgroundPainter(this.animationValue, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Draw dynamic circles
    for (int i = 0; i < 6; i++) {
      final path = Path();
      final phase = i * (pi / 3);
      final centerX =
          size.width * (0.5 + 0.4 * sin(animationValue * 2 * pi + phase));
      final centerY =
          size.height * (0.5 + 0.4 * cos(animationValue * 1.5 * pi + phase));
      final radius = 100 + 50 * sin(animationValue * pi + phase);

      path.addOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      );
      canvas.drawPath(path, paint);
    }

    // Draw connecting lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final startX = size.width * (0.1 + i * 0.1);
      final startY =
          size.height * (0.2 + 0.1 * sin(animationValue * 2 * pi + i));
      final endX = size.width * (0.9 - i * 0.1);
      final endY = size.height * (0.8 + 0.1 * cos(animationValue * 2 * pi + i));

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _UltraModernBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
