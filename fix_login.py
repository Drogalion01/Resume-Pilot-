import re
with open(r"F:\Resume Pilot app\flutter_app\lib\features\auth\screens\login_screen.dart", "r", encoding="utf-8") as f:
    text = f.read()

new_methods = """  Future<Map<String, dynamic>> _sendOtp(String phone) async {
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
          await ref.read(authNotifierProvider.notifier).sessionByPhone(phone: phone);
        } catch (e) {
          if (mounted) {
            _showMessage('লগইন করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।', isError: true);
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
      } else if (statusCode == 'E1351' || message.toLowerCase().contains('already registered')) {
        _showMessage('ইতিমধ্যে রেজিস্টার করা! লগইন হচ্ছে...', isError: false);
        await Future.delayed(const Duration(milliseconds: 800));

        try {
          await ref.read(authNotifierProvider.notifier).sessionByPhone(phone: phone);
        } catch (e) {
          if (mounted) {
            _showMessage('লগইন করতে সমস্যা হয়েছে।', isError: true);
          }
        }
        return;
      } else {
        final errorMsg = message.isNotEmpty ? message : (statusDetail.isNotEmpty ? statusDetail : 'OTP পাঠানো যায়নি');
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
  }"""

pattern = re.compile(r"Future<String>\s+_sendOtp.*?\} finally \{\s*if \(mounted\) setState\(\(\) => _loading = false\);\s*\}\s*\}", re.DOTALL)
new_text = pattern.sub(new_methods, text)

with open(r"F:\Resume Pilot app\flutter_app\lib\features\auth\screens\login_screen.dart", "w", encoding="utf-8") as f:
    f.write(new_text)

print("Done logic patch for login screen")
