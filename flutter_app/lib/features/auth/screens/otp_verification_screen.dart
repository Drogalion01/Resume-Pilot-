import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/error/app_exception.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

const String _bdappsPhpBaseUrl = 'https://www.flicksize.com/resumepilot/';

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
  ConsumerState<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
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

  Future<void> _verifyOtpWithPhp() async {
    final response = await http
        .post(
          Uri.parse('${_bdappsPhpBaseUrl}verify_otp.php'),
          body: {
            'Otp': _otpCtrl.text.trim(),
            'referenceNo': widget.referenceNo,
            'user_mobile': widget.subscriberId,
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('OTP verify failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid verify_otp response');
    }

    final statusCode =
        (decoded['statusCode']?.toString() ?? '').trim().toUpperCase();
    if (statusCode != 'S1000') {
      final detail = decoded['message']?.toString() ??
          decoded['statusDetail']?.toString() ??
          'OTP ভুল হয়েছে';
      throw Exception(detail);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _verifyOtpWithPhp();
      await ref
          .read(authNotifierProvider.notifier)
          .sessionByPhone(phone: widget.subscriberId);
      _showMessage('যাচাই সফল হয়েছে', isError: false);
      // GoRouter redirect handles navigation on success (auth state changes).
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
      showBack: true,
      hero: AuthHero(
        icon: Icons.message_rounded,
        title: 'OTP দিন',
        subtitle: '${widget.subscriberId} নম্বরে কোড পাঠানো হয়েছে',
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
                  hintText: '******',
                  prefixIcon: Icon(Icons.password_outlined),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'OTP is required';
                  if (val.length < 4) return 'OTP সঠিকভাবে দাও';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'RefNo: ${widget.referenceNo}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 24),
              AuthSubmitButton(
                label: 'যাচাই করুন',
                onPressed: _loading ? null : _submit,
                loading: _loading,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _loading ? null : () => Navigator.pop(context),
                child: const Text('ভুল নম্বর? পিছনে যাও'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
