import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    String? phone,
    String? initials,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileX on UserProfile {
  String get firstName => fullName?.split(' ').first ?? 'User';

  String get displayInitials {
    if (initials != null && initials!.isNotEmpty) return initials!;
    final parts = (fullName ?? '').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || (fullName ?? '').isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
