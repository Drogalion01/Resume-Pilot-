import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../app/router/routes.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

bool _isSupportedRobiAirtelNumber(String phone) {
  return RegExp(r'^01(?:6|8)\d{8}$').hasMatch(phone);
}

// ─────────────────────────────────────────────────────────────────────────────
// LoginScreen
// ─────────────────────────────────────────────────────────────────────────────

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneCtrl = TextEditingController();

  bool _loading = false;
  AppException? _error;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneCtrl.text.trim();

    if (phone.isEmpty) {
      _showMessage('মোবাইল নম্বর দাও', isError: true);
      return;
    }
    if (!_isSupportedRobiAirtelNumber(phone)) {
      _showMessage('সঠিক Robi/Airtel নম্বর দাও', isError: true);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ref
          .read(authNotifierProvider.notifier)
          .checkSubscription(phone);
      final status = (res['status']?.toString() ?? '').trim();
      final loginUrl = (res['loginUrl']?.toString() ?? '').trim();
      final statusDetail = (res['statusDetail']?.toString() ?? '').trim();

      if (status == 'subscribed' || status == 'requires_subscription') {
        if (status == 'requires_subscription' && statusDetail.isNotEmpty) {
          _showMessage(statusDetail, isError: false);
        }
        final otpRes =
            await ref.read(authNotifierProvider.notifier).sendOtp(phone);
        final referenceNo = (otpRes['referenceNo']?.toString() ?? '').trim();
        if (referenceNo.isEmpty) {
          _showMessage('OTP রেফারেন্স পাওয়া যায়নি। আবার চেষ্টা করুন।',
              isError: true);
          return;
        }
        _showMessage('OTP পাঠানো হয়েছে', isError: false);
        if (!mounted) return;
        context.push(
          AppRoutes.otpVerification,
          extra: {
            'subscriberId': phone,
            'referenceNo': referenceNo,
          },
        );
        return;
      }

      if (loginUrl.isNotEmpty) {
        _showMessage('সাবস্ক্রিপশন দরকার। লিংক: $loginUrl', isError: true);
        return;
      }

      _showMessage('লগইন প্রক্রিয়া সম্পন্ন করা যায়নি। আবার চেষ্টা করুন।',
          isError: true);
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _error = e);
        _showMessage(e.userMessage, isError: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = const ServerException(500, 'Unexpected error'));
        _showMessage('নেটওয়ার্ক সমস্যা হয়েছে: ${e.toString()}',
            isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String text, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration:
            isError ? const Duration(seconds: 4) : const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      showBack: context.canPop(),
      hero: const AuthHero(
        icon: Icons.phone_android_rounded,
        title: 'Welcome',
        subtitle: 'Enter your phone number to sign in or subscribe',
      ),
      form: AuthFormSheet(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthErrorBanner(
              error: _error,
              onDismiss: () => setState(() => _error = null),
            ),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              enabled: !_loading,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'মোবাইল নম্বর',
                hintText: '018********',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 24),
            AuthSubmitButton(
              label: 'পরবর্তী',
              onPressed: _loading ? null : _submit,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
