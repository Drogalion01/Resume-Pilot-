// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) {
  return _DashboardResponse.fromJson(json);
}

/// @nodoc
mixin _$DashboardResponse {
  UserProfile get user => throw _privateConstructorUsedError;
  DashboardSummary get summary => throw _privateConstructorUsedError;
  DashboardInsight get insight => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_resumes')
  List<ResumeResponse> get recentResumes => throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_interviews')
  List<InterviewResponse> get upcomingInterviews =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_applications')
  List<ApplicationResponse> get recentApplications =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardResponseCopyWith<DashboardResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardResponseCopyWith<$Res> {
  factory $DashboardResponseCopyWith(
          DashboardResponse value, $Res Function(DashboardResponse) then) =
      _$DashboardResponseCopyWithImpl<$Res, DashboardResponse>;
  @useResult
  $Res call(
      {UserProfile user,
      DashboardSummary summary,
      DashboardInsight insight,
      @JsonKey(name: 'recent_resumes') List<ResumeResponse> recentResumes,
      @JsonKey(name: 'upcoming_interviews')
      List<InterviewResponse> upcomingInterviews,
      @JsonKey(name: 'recent_applications')
      List<ApplicationResponse> recentApplications});

  $UserProfileCopyWith<$Res> get user;
  $DashboardSummaryCopyWith<$Res> get summary;
  $DashboardInsightCopyWith<$Res> get insight;
}

/// @nodoc
class _$DashboardResponseCopyWithImpl<$Res, $Val extends DashboardResponse>
    implements $DashboardResponseCopyWith<$Res> {
  _$DashboardResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? summary = null,
    Object? insight = null,
    Object? recentResumes = null,
    Object? upcomingInterviews = null,
    Object? recentApplications = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as DashboardSummary,
      insight: null == insight
          ? _value.insight
          : insight // ignore: cast_nullable_to_non_nullable
              as DashboardInsight,
      recentResumes: null == recentResumes
          ? _value.recentResumes
          : recentResumes // ignore: cast_nullable_to_non_nullable
              as List<ResumeResponse>,
      upcomingInterviews: null == upcomingInterviews
          ? _value.upcomingInterviews
          : upcomingInterviews // ignore: cast_nullable_to_non_nullable
              as List<InterviewResponse>,
      recentApplications: null == recentApplications
          ? _value.recentApplications
          : recentApplications // ignore: cast_nullable_to_non_nullable
              as List<ApplicationResponse>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get user {
    return $UserProfileCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DashboardSummaryCopyWith<$Res> get summary {
    return $DashboardSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DashboardInsightCopyWith<$Res> get insight {
    return $DashboardInsightCopyWith<$Res>(_value.insight, (value) {
      return _then(_value.copyWith(insight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardResponseImplCopyWith<$Res>
    implements $DashboardResponseCopyWith<$Res> {
  factory _$$DashboardResponseImplCopyWith(_$DashboardResponseImpl value,
          $Res Function(_$DashboardResponseImpl) then) =
      __$$DashboardResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserProfile user,
      DashboardSummary summary,
      DashboardInsight insight,
      @JsonKey(name: 'recent_resumes') List<ResumeResponse> recentResumes,
      @JsonKey(name: 'upcoming_interviews')
      List<InterviewResponse> upcomingInterviews,
      @JsonKey(name: 'recent_applications')
      List<ApplicationResponse> recentApplications});

  @override
  $UserProfileCopyWith<$Res> get user;
  @override
  $DashboardSummaryCopyWith<$Res> get summary;
  @override
  $DashboardInsightCopyWith<$Res> get insight;
}

/// @nodoc
class __$$DashboardResponseImplCopyWithImpl<$Res>
    extends _$DashboardResponseCopyWithImpl<$Res, _$DashboardResponseImpl>
    implements _$$DashboardResponseImplCopyWith<$Res> {
  __$$DashboardResponseImplCopyWithImpl(_$DashboardResponseImpl _value,
      $Res Function(_$DashboardResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? summary = null,
    Object? insight = null,
    Object? recentResumes = null,
    Object? upcomingInterviews = null,
    Object? recentApplications = null,
  }) {
    return _then(_$DashboardResponseImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as DashboardSummary,
      insight: null == insight
          ? _value.insight
          : insight // ignore: cast_nullable_to_non_nullable
              as DashboardInsight,
      recentResumes: null == recentResumes
          ? _value._recentResumes
          : recentResumes // ignore: cast_nullable_to_non_nullable
              as List<ResumeResponse>,
      upcomingInterviews: null == upcomingInterviews
          ? _value._upcomingInterviews
          : upcomingInterviews // ignore: cast_nullable_to_non_nullable
              as List<InterviewResponse>,
      recentApplications: null == recentApplications
          ? _value._recentApplications
          : recentApplications // ignore: cast_nullable_to_non_nullable
              as List<ApplicationResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardResponseImpl implements _DashboardResponse {
  const _$DashboardResponseImpl(
      {required this.user,
      required this.summary,
      required this.insight,
      @JsonKey(name: 'recent_resumes')
      final List<ResumeResponse> recentResumes = const [],
      @JsonKey(name: 'upcoming_interviews')
      final List<InterviewResponse> upcomingInterviews = const [],
      @JsonKey(name: 'recent_applications')
      final List<ApplicationResponse> recentApplications = const []})
      : _recentResumes = recentResumes,
        _upcomingInterviews = upcomingInterviews,
        _recentApplications = recentApplications;

  factory _$DashboardResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardResponseImplFromJson(json);

  @override
  final UserProfile user;
  @override
  final DashboardSummary summary;
  @override
  final DashboardInsight insight;
  final List<ResumeResponse> _recentResumes;
  @override
  @JsonKey(name: 'recent_resumes')
  List<ResumeResponse> get recentResumes {
    if (_recentResumes is EqualUnmodifiableListView) return _recentResumes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentResumes);
  }

  final List<InterviewResponse> _upcomingInterviews;
  @override
  @JsonKey(name: 'upcoming_interviews')
  List<InterviewResponse> get upcomingInterviews {
    if (_upcomingInterviews is EqualUnmodifiableListView)
      return _upcomingInterviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingInterviews);
  }

  final List<ApplicationResponse> _recentApplications;
  @override
  @JsonKey(name: 'recent_applications')
  List<ApplicationResponse> get recentApplications {
    if (_recentApplications is EqualUnmodifiableListView)
      return _recentApplications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentApplications);
  }

  @override
  String toString() {
    return 'DashboardResponse(user: $user, summary: $summary, insight: $insight, recentResumes: $recentResumes, upcomingInterviews: $upcomingInterviews, recentApplications: $recentApplications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardResponseImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.insight, insight) || other.insight == insight) &&
            const DeepCollectionEquality()
                .equals(other._recentResumes, _recentResumes) &&
            const DeepCollectionEquality()
                .equals(other._upcomingInterviews, _upcomingInterviews) &&
            const DeepCollectionEquality()
                .equals(other._recentApplications, _recentApplications));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user,
      summary,
      insight,
      const DeepCollectionEquality().hash(_recentResumes),
      const DeepCollectionEquality().hash(_upcomingInterviews),
      const DeepCollectionEquality().hash(_recentApplications));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      __$$DashboardResponseImplCopyWithImpl<_$DashboardResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardResponseImplToJson(
      this,
    );
  }
}

abstract class _DashboardResponse implements DashboardResponse {
  const factory _DashboardResponse(
      {required final UserProfile user,
      required final DashboardSummary summary,
      required final DashboardInsight insight,
      @JsonKey(name: 'recent_resumes') final List<ResumeResponse> recentResumes,
      @JsonKey(name: 'upcoming_interviews')
      final List<InterviewResponse> upcomingInterviews,
      @JsonKey(name: 'recent_applications')
      final List<ApplicationResponse>
          recentApplications}) = _$DashboardResponseImpl;

  factory _DashboardResponse.fromJson(Map<String, dynamic> json) =
      _$DashboardResponseImpl.fromJson;

  @override
  UserProfile get user;
  @override
  DashboardSummary get summary;
  @override
  DashboardInsight get insight;
  @override
  @JsonKey(name: 'recent_resumes')
  List<ResumeResponse> get recentResumes;
  @override
  @JsonKey(name: 'upcoming_interviews')
  List<InterviewResponse> get upcomingInterviews;
  @override
  @JsonKey(name: 'recent_applications')
  List<ApplicationResponse> get recentApplications;
  @override
  @JsonKey(ignore: true)
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) {
  return _DashboardSummary.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummary {
  @JsonKey(name: 'total_resumes')
  int get totalResumes => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_applications')
  int get totalApplications => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_interviews')
  int get totalInterviews => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardSummaryCopyWith<DashboardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryCopyWith<$Res> {
  factory $DashboardSummaryCopyWith(
          DashboardSummary value, $Res Function(DashboardSummary) then) =
      _$DashboardSummaryCopyWithImpl<$Res, DashboardSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_resumes') int totalResumes,
      @JsonKey(name: 'total_applications') int totalApplications,
      @JsonKey(name: 'total_interviews') int totalInterviews});
}

/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res, $Val extends DashboardSummary>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalResumes = null,
    Object? totalApplications = null,
    Object? totalInterviews = null,
  }) {
    return _then(_value.copyWith(
      totalResumes: null == totalResumes
          ? _value.totalResumes
          : totalResumes // ignore: cast_nullable_to_non_nullable
              as int,
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      totalInterviews: null == totalInterviews
          ? _value.totalInterviews
          : totalInterviews // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardSummaryImplCopyWith<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  factory _$$DashboardSummaryImplCopyWith(_$DashboardSummaryImpl value,
          $Res Function(_$DashboardSummaryImpl) then) =
      __$$DashboardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_resumes') int totalResumes,
      @JsonKey(name: 'total_applications') int totalApplications,
      @JsonKey(name: 'total_interviews') int totalInterviews});
}

/// @nodoc
class __$$DashboardSummaryImplCopyWithImpl<$Res>
    extends _$DashboardSummaryCopyWithImpl<$Res, _$DashboardSummaryImpl>
    implements _$$DashboardSummaryImplCopyWith<$Res> {
  __$$DashboardSummaryImplCopyWithImpl(_$DashboardSummaryImpl _value,
      $Res Function(_$DashboardSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalResumes = null,
    Object? totalApplications = null,
    Object? totalInterviews = null,
  }) {
    return _then(_$DashboardSummaryImpl(
      totalResumes: null == totalResumes
          ? _value.totalResumes
          : totalResumes // ignore: cast_nullable_to_non_nullable
              as int,
      totalApplications: null == totalApplications
          ? _value.totalApplications
          : totalApplications // ignore: cast_nullable_to_non_nullable
              as int,
      totalInterviews: null == totalInterviews
          ? _value.totalInterviews
          : totalInterviews // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryImpl implements _DashboardSummary {
  const _$DashboardSummaryImpl(
      {@JsonKey(name: 'total_resumes') required this.totalResumes,
      @JsonKey(name: 'total_applications') required this.totalApplications,
      @JsonKey(name: 'total_interviews') required this.totalInterviews});

  factory _$DashboardSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_resumes')
  final int totalResumes;
  @override
  @JsonKey(name: 'total_applications')
  final int totalApplications;
  @override
  @JsonKey(name: 'total_interviews')
  final int totalInterviews;

  @override
  String toString() {
    return 'DashboardSummary(totalResumes: $totalResumes, totalApplications: $totalApplications, totalInterviews: $totalInterviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryImpl &&
            (identical(other.totalResumes, totalResumes) ||
                other.totalResumes == totalResumes) &&
            (identical(other.totalApplications, totalApplications) ||
                other.totalApplications == totalApplications) &&
            (identical(other.totalInterviews, totalInterviews) ||
                other.totalInterviews == totalInterviews));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalResumes, totalApplications, totalInterviews);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      __$$DashboardSummaryImplCopyWithImpl<_$DashboardSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryImplToJson(
      this,
    );
  }
}

abstract class _DashboardSummary implements DashboardSummary {
  const factory _DashboardSummary(
      {@JsonKey(name: 'total_resumes') required final int totalResumes,
      @JsonKey(name: 'total_applications') required final int totalApplications,
      @JsonKey(name: 'total_interviews')
      required final int totalInterviews}) = _$DashboardSummaryImpl;

  factory _DashboardSummary.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_resumes')
  int get totalResumes;
  @override
  @JsonKey(name: 'total_applications')
  int get totalApplications;
  @override
  @JsonKey(name: 'total_interviews')
  int get totalInterviews;
  @override
  @JsonKey(ignore: true)
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardInsight _$DashboardInsightFromJson(Map<String, dynamic> json) {
  return _DashboardInsight.fromJson(json);
}

/// @nodoc
mixin _$DashboardInsight {
  /// e.g. "3 Active Applications"
  @JsonKey(name: 'trending_stat')
  String get trendingStat => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardInsightCopyWith<DashboardInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardInsightCopyWith<$Res> {
  factory $DashboardInsightCopyWith(
          DashboardInsight value, $Res Function(DashboardInsight) then) =
      _$DashboardInsightCopyWithImpl<$Res, DashboardInsight>;
  @useResult
  $Res call(
      {@JsonKey(name: 'trending_stat') String trendingStat,
      String? description});
}

/// @nodoc
class _$DashboardInsightCopyWithImpl<$Res, $Val extends DashboardInsight>
    implements $DashboardInsightCopyWith<$Res> {
  _$DashboardInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trendingStat = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      trendingStat: null == trendingStat
          ? _value.trendingStat
          : trendingStat // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardInsightImplCopyWith<$Res>
    implements $DashboardInsightCopyWith<$Res> {
  factory _$$DashboardInsightImplCopyWith(_$DashboardInsightImpl value,
          $Res Function(_$DashboardInsightImpl) then) =
      __$$DashboardInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'trending_stat') String trendingStat,
      String? description});
}

/// @nodoc
class __$$DashboardInsightImplCopyWithImpl<$Res>
    extends _$DashboardInsightCopyWithImpl<$Res, _$DashboardInsightImpl>
    implements _$$DashboardInsightImplCopyWith<$Res> {
  __$$DashboardInsightImplCopyWithImpl(_$DashboardInsightImpl _value,
      $Res Function(_$DashboardInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trendingStat = null,
    Object? description = freezed,
  }) {
    return _then(_$DashboardInsightImpl(
      trendingStat: null == trendingStat
          ? _value.trendingStat
          : trendingStat // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardInsightImpl implements _DashboardInsight {
  const _$DashboardInsightImpl(
      {@JsonKey(name: 'trending_stat') required this.trendingStat,
      this.description});

  factory _$DashboardInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardInsightImplFromJson(json);

  /// e.g. "3 Active Applications"
  @override
  @JsonKey(name: 'trending_stat')
  final String trendingStat;
  @override
  final String? description;

  @override
  String toString() {
    return 'DashboardInsight(trendingStat: $trendingStat, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardInsightImpl &&
            (identical(other.trendingStat, trendingStat) ||
                other.trendingStat == trendingStat) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, trendingStat, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardInsightImplCopyWith<_$DashboardInsightImpl> get copyWith =>
      __$$DashboardInsightImplCopyWithImpl<_$DashboardInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardInsightImplToJson(
      this,
    );
  }
}

abstract class _DashboardInsight implements DashboardInsight {
  const factory _DashboardInsight(
      {@JsonKey(name: 'trending_stat') required final String trendingStat,
      final String? description}) = _$DashboardInsightImpl;

  factory _DashboardInsight.fromJson(Map<String, dynamic> json) =
      _$DashboardInsightImpl.fromJson;

  @override

  /// e.g. "3 Active Applications"
  @JsonKey(name: 'trending_stat')
  String get trendingStat;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$DashboardInsightImplCopyWith<_$DashboardInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
