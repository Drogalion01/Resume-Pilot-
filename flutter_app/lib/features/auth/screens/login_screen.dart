import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/error/app_exception.dart';
import '../../../app/router/routes.dart';
import '../providers/auth_provider.dart';
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
    final response = await http.post(
      Uri.parse('${_bdappsPhpBaseUrl}check_subscription.php'),
      body: {'user_mobile': phone},
    ).timeout(const Duration(seconds: 15));

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

  Future<Map<String, dynamic>> _sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('${_bdappsPhpBaseUrl}send_otp.php'),
      body: {'user_mobile': phone},
    ).timeout(const Duration(seconds: 15));

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('সার্ভার থেকে ভুল তথ্য এসেছে');
    }

    return decoded;
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

      if (isSubscribed) {
        _showMessage('স্বাগতম! লগইন হচ্ছে...', isError: false);
        await Future.delayed(const Duration(milliseconds: 800));

        try {
          await ref
              .read(authNotifierProvider.notifier)
              .sessionByPhone(phone: phone);
        } catch (e) {
          if (mounted) {
            _showMessage('লগইন করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
                isError: true);
          }
        }
        return;
      }

      final otpData = await _sendOtp(phone);

      final success = otpData['success'] == true;
      final referenceNo = otpData['referenceNo']?.toString().trim() ?? '';
      final message = otpData['message']?.toString() ?? '';
      final statusDetail = otpData['statusDetail']?.toString() ?? '';
      final statusCode = otpData['statusCode']?.toString().trim() ?? '';

      if (success && referenceNo.isNotEmpty) {
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
      } else if (statusCode == 'E1351' ||
          message.toLowerCase().contains('already registered')) {
        _showMessage('ইতিমধ্যে রেজিস্টার করা! লগইন হচ্ছে...', isError: false);
        await Future.delayed(const Duration(milliseconds: 800));

        try {
          await ref
              .read(authNotifierProvider.notifier)
              .sessionByPhone(phone: phone);
        } catch (e) {
          if (mounted) {
            _showMessage('লগইন করতে সমস্যা হয়েছে।', isError: true);
          }
        }
        return;
      } else {
        final errorMsg = message.isNotEmpty
            ? message
            : (statusDetail.isNotEmpty ? statusDetail : 'OTP পাঠানো যায়নি');
        _showMessage(errorMsg, isError: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = const ServerException(500, 'Unexpected error'));
        _showMessage('নেটওয়ার্ক সমস্যা হয়েছে', isError: true);
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
