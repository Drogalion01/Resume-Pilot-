import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OTPVerificationScreen
// ─────────────────────────────────────────────────────────────────────────────

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String subscriberId;
  final String referenceNo;

  const OTPVerificationScreen({
    super.key,
    required this.subscriberId,
    required this.referenceNo,
  });

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();

  bool _loading = false;
  AppException? _error;

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).verifyOtp(
            phone: widget.subscriberId,
            referenceNo: widget.referenceNo,
            otp: _otpCtrl.text.trim(),
          );
      // GoRouter redirect handles navigation on success (auth state changes).
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e);
    } catch (e) {
      if (mounted) setState(() => _error = ServerException(500, 'Unexpected error: '));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      showBack: true,
      hero: AuthHero(
        icon: Icons.message_rounded,
        title: 'Verify OTP',
        subtitle: 'Enter the 6-digit pin sent to ',
      ),
      form: AuthFormSheet(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthErrorBanner(
                error: _error,
                onDismiss: () => setState(() => _error = null),
              ),

              TextFormField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: '123456',
                  prefixIcon: Icon(Icons.password_outlined),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'OTP is required';
                  if (val.length != 6) return 'OTP must be 6 digits';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              AuthSubmitButton(
                label: 'Verify & Login',
                onPressed: _loading ? null : _submit,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
