import re
with open(r"F:\Resume Pilot app\flutter_app\lib\features\auth\screens\otp_verification_screen.dart", "r", encoding="utf-8") as f:
    text = f.read()

new_methods = """  Future<void> _verifyOtpWithPhp() async {
    final response = await http.post(
      Uri.parse('${_bdappsPhpBaseUrl}verify_otp.php'),
      body: {
        'Otp': _otpCtrl.text.trim(),
        'referenceNo': widget.referenceNo,
        'user_mobile': widget.subscriberId,
      },
    ).timeout(const Duration(seconds: 15));

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

  Future<bool> _waitForSubscriptionSync() async {
    for (var i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      try {
        final response = await http.post(
          Uri.parse('${_bdappsPhpBaseUrl}check_subscription.php'),
          body: {'user_mobile': widget.subscriberId},
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            final status = (data['subscriptionStatus']?.toString() ?? '').trim().toUpperCase();
            if (status == 'REGISTERED') {
              return true;
            }
          }
        }
      } catch (e) {
        // ignore and retry
      }
    }
    return false;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _verifyOtpWithPhp();
      
      final subscribed = await _waitForSubscriptionSync();
      if (!mounted) return;

      if (!subscribed) {
        _showMessage('সাবস্ক্রিপশন চলছে। অনুগ্রহ করে কিছুক্ষণ পর আবার চেষ্টা করুন।', isError: true);
        setState(() => _loading = false);
        return;
      }

      await ref
          .read(authNotifierProvider.notifier)
          .sessionByPhone(phone: widget.subscriberId);
          
      _showMessage('যাচাই সফল হয়েছে', isError: false);
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _error = e);
        _showMessage(e.userMessage, isError: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = const ServerException(500, 'Unexpected error'));
        _showMessage('নেটওয়ার্ক সমস্যা হয়েছে: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }"""

pattern = re.compile(r"Future<void>\s+_verifyOtpWithPhp.*?(?=void _showMessage\()", re.DOTALL)
new_text = pattern.sub(new_methods + "\n  ", text)

with open(r"F:\Resume Pilot app\flutter_app\lib\features\auth\screens\otp_verification_screen.dart", "w", encoding="utf-8") as f:
    f.write(new_text)

print("Done logic patch for otp screen")
