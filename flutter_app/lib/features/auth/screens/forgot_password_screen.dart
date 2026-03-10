import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../app/router/routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _loading = false;
  bool _sent    = false;
  AppException? _error;
  String _sentEmail = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _loading = true; _error = null; });
    try {
      _sentEmail = _emailCtrl.text.trim();
      await ref.read(authNotifierProvider.notifier).forgotPassword(_sentEmail);
      if (mounted) setState(() => _sent = true);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return AuthScreenShell(
      showBack: true,
      hero: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _sent
            ? AuthHero(
                key: const ValueKey('sent'),
                icon: Icons.mark_email_read_outlined,
                title: 'Check your inbox',
                subtitle: 'We sent a reset link to\n$_sentEmail',
              )
            : const AuthHero(
                key: ValueKey('form'),
                icon: Icons.lock_reset_rounded,
                title: 'Forgot password?',
                subtitle: "Enter your email and we'll send\na reset link",
              ),
      ),
      form: AuthFormSheet(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _sent
              ? _SuccessContent(
                  key: const ValueKey('success'),
                  email: _sentEmail,
                  colors: colors,
                  textTheme: textTheme,
                  onBackToLogin: () => context.go(AppRoutes.login),
                  onTryAgain: () => setState(() {
                    _sent = false;
                    _emailCtrl.clear();
                  }),
                )
              : _EmailForm(
                  key: const ValueKey('emailForm'),
                  formKey: _formKey,
                  emailCtrl: _emailCtrl,
                  error: _error,
                  loading: _loading,
                  onDismissError: () => setState(() => _error = null),
                  onSubmit: _submit,
                  onBackToLogin: () => context.go(AppRoutes.login),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Email form (pre-send state)
// ─────────────────────────────────────────────────────────────────────────────

class _EmailForm extends StatelessWidget {
  const _EmailForm({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.error,
    required this.loading,
    required this.onDismissError,
    required this.onSubmit,
    required this.onBackToLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final AppException? error;
  final bool loading;
  final VoidCallback onDismissError;
  final VoidCallback onSubmit;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthErrorBanner(error: error, onDismiss: onDismissError),

          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            onFieldSubmitted: (_) => onSubmit(),
            decoration: const InputDecoration(
              labelText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: Validators.email,
          ),
          const SizedBox(height: 28),

          AuthSubmitButton(
            label: 'Send Reset Link',
            onPressed: loading ? null : onSubmit,
            loading: loading,
          ),
          const SizedBox(height: 20),

          AuthFooterLink(
            prefixText: 'Remember your password? ',
            linkText: 'Sign in',
            onTap: onBackToLogin,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success confirmation view (post-send state)
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({
    super.key,
    required this.email,
    required this.colors,
    required this.textTheme,
    required this.onBackToLogin,
    required this.onTryAgain,
  });

  final String email;
  final AppColors colors;
  final TextTheme textTheme;
  final VoidCallback onBackToLogin;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Didn't receive the email? Check your spam folder, or:",
          style: textTheme.bodyMedium?.copyWith(
            color: colors.foregroundSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.px28),

        AuthSubmitButton(
          label: 'Back to Sign In',
          onPressed: onBackToLogin,
        ),
        const SizedBox(height: 12),

        Center(
          child: TextButton(
            onPressed: onTryAgain,
            child: Text(
              'Try a different email',
              style: TextStyle(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
