import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/error/app_exception.dart';
import '../../../app/router/routes.dart';
import '../widgets/auth_widgets.dart';

const String _bdappsPhpBaseUrl = 'https://www.flicksize.com/resumepilot/';

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

  Future<bool> _checkSubscription(String phone) async {
    final response = await http
        .post(
          Uri.parse('${_bdappsPhpBaseUrl}check_subscription.php'),
          body: {'user_mobile': phone},
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Subscription check failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid check_subscription response');
    }

    final status =
        (decoded['subscriptionStatus']?.toString() ?? '').trim().toUpperCase();
    return status == 'REGISTERED';
  }

  Future<String> _sendOtp(String phone) async {
    final response = await http
        .post(
          Uri.parse('${_bdappsPhpBaseUrl}send_otp.php'),
          body: {'user_mobile': phone},
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('OTP send failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid send_otp response');
    }

    final referenceNo = (decoded['referenceNo']?.toString() ?? '').trim();
    if (referenceNo.isEmpty) {
      final detail = decoded['message']?.toString() ??
          decoded['statusDetail']?.toString() ??
          'OTP পাঠানো যায়নি';
      throw Exception(detail);
    }

    return referenceNo;
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
      final isSubscribed = await _checkSubscription(phone);
      if (!isSubscribed) {
        _showMessage('নম্বরটি সাবস্ক্রাইবড নয়। OTP যাচাই চলবে...', isError: false);
      }

      final referenceNo = await _sendOtp(phone);
      if (referenceNo.isNotEmpty) {
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
