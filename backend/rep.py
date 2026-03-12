import re

file_path = r'f:\Resume Pilot app\flutter_app\lib\core\auth\auth_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# I will find the bounds
start_str = '  // -- Login'
start_idx = text.find(start_str)
if start_idx == -1: 
    start_str = '  // ── Login'
    start_idx = text.find(start_str)

end_str = '  // -- Current user'
end_idx = text.find(end_str)
if end_idx == -1:
    end_str = '  // ── Current user'
    end_idx = text.find(end_str)

if start_idx != -1 and end_idx != -1:
    new_text = text[:start_idx] + '''  // -- Phone Auth -------------------------------------------------------------

  Future<Map<String, dynamic>> checkSubscription(String phone) => _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/phone/check',
          data: {'phone': phone},
        );
        return res.data!;
      });

  Future<AuthStateAuthenticated> verifyOtp({
    required String phone,
    required String otp,
    required String referenceNo,
  }) =>
      _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/phone/verify-otp',
          data: {
            'phone': phone,
            'otp': otp,
            'referenceNo': referenceNo,
          },
        );
        return _processResponse(res.data!);
      });

''' + text[end_idx:]

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_text)
    print("Cleaned up!")
else:
    print("fail")
