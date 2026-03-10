// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BreakdownItem _$BreakdownItemFromJson(Map<String, dynamic> json) {
  return _BreakdownItem.fromJson(json);
}

/// @nodoc
mixin _$BreakdownItem {
  String get category => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_score')
  int get maxScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BreakdownItemCopyWith<BreakdownItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakdownItemCopyWith<$Res> {
  factory $BreakdownItemCopyWith(
          BreakdownItem value, $Res Function(BreakdownItem) then) =
      _$BreakdownItemCopyWithImpl<$Res, BreakdownItem>;
  @useResult
  $Res call(
      {String category, int score, @JsonKey(name: 'max_score') int maxScore});
}

/// @nodoc
class _$BreakdownItemCopyWithImpl<$Res, $Val extends BreakdownItem>
    implements $BreakdownItemCopyWith<$Res> {
  _$BreakdownItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? score = null,
    Object? maxScore = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      maxScore: null == maxScore
          ? _value.maxScore
          : maxScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BreakdownItemImplCopyWith<$Res>
    implements $BreakdownItemCopyWith<$Res> {
  factory _$$BreakdownItemImplCopyWith(
          _$BreakdownItemImpl value, $Res Function(_$BreakdownItemImpl) then) =
      __$$BreakdownItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category, int score, @JsonKey(name: 'max_score') int maxScore});
}

/// @nodoc
class __$$BreakdownItemImplCopyWithImpl<$Res>
    extends _$BreakdownItemCopyWithImpl<$Res, _$BreakdownItemImpl>
    implements _$$BreakdownItemImplCopyWith<$Res> {
  __$$BreakdownItemImplCopyWithImpl(
      _$BreakdownItemImpl _value, $Res Function(_$BreakdownItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? score = null,
    Object? maxScore = null,
  }) {
    return _then(_$BreakdownItemImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      maxScore: null == maxScore
          ? _value.maxScore
          : maxScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakdownItemImpl implements _BreakdownItem {
  const _$BreakdownItemImpl(
      {required this.category,
      required this.score,
      @JsonKey(name: 'max_score') required this.maxScore});

  factory _$BreakdownItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakdownItemImplFromJson(json);

  @override
  final String category;
  @override
  final int score;
  @override
  @JsonKey(name: 'max_score')
  final int maxScore;

  @override
  String toString() {
    return 'BreakdownItem(category: $category, score: $score, maxScore: $maxScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakdownItemImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.maxScore, maxScore) ||
                other.maxScore == maxScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, score, maxScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakdownItemImplCopyWith<_$BreakdownItemImpl> get copyWith =>
      __$$BreakdownItemImplCopyWithImpl<_$BreakdownItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakdownItemImplToJson(
      this,
    );
  }
}

abstract class _BreakdownItem implements BreakdownItem {
  const factory _BreakdownItem(
          {required final String category,
          required final int score,
          @JsonKey(name: 'max_score') required final int maxScore}) =
      _$BreakdownItemImpl;

  factory _BreakdownItem.fromJson(Map<String, dynamic> json) =
      _$BreakdownItemImpl.fromJson;

  @override
  String get category;
  @override
  int get score;
  @override
  @JsonKey(name: 'max_score')
  int get maxScore;
  @override
  @JsonKey(ignore: true)
  _$$BreakdownItemImplCopyWith<_$BreakdownItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IssueItem _$IssueItemFromJson(Map<String, dynamic> json) {
  return _IssueItem.fromJson(json);
}

/// @nodoc
mixin _$IssueItem {
  String get severity => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IssueItemCopyWith<IssueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueItemCopyWith<$Res> {
  factory $IssueItemCopyWith(IssueItem value, $Res Function(IssueItem) then) =
      _$IssueItemCopyWithImpl<$Res, IssueItem>;
  @useResult
  $Res call({String severity, String description});
}

/// @nodoc
class _$IssueItemCopyWithImpl<$Res, $Val extends IssueItem>
    implements $IssueItemCopyWith<$Res> {
  _$IssueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severity = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssueItemImplCopyWith<$Res>
    implements $IssueItemCopyWith<$Res> {
  factory _$$IssueItemImplCopyWith(
          _$IssueItemImpl value, $Res Function(_$IssueItemImpl) then) =
      __$$IssueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String severity, String description});
}

/// @nodoc
class __$$IssueItemImplCopyWithImpl<$Res>
    extends _$IssueItemCopyWithImpl<$Res, _$IssueItemImpl>
    implements _$$IssueItemImplCopyWith<$Res> {
  __$$IssueItemImplCopyWithImpl(
      _$IssueItemImpl _value, $Res Function(_$IssueItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severity = null,
    Object? description = null,
  }) {
    return _then(_$IssueItemImpl(
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueItemImpl implements _IssueItem {
  const _$IssueItemImpl({required this.severity, required this.description});

  factory _$IssueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueItemImplFromJson(json);

  @override
  final String severity;
  @override
  final String description;

  @override
  String toString() {
    return 'IssueItem(severity: $severity, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueItemImpl &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, severity, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueItemImplCopyWith<_$IssueItemImpl> get copyWith =>
      __$$IssueItemImplCopyWithImpl<_$IssueItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueItemImplToJson(
      this,
    );
  }
}

abstract class _IssueItem implements IssueItem {
  const factory _IssueItem(
      {required final String severity,
      required final String description}) = _$IssueItemImpl;

  factory _IssueItem.fromJson(Map<String, dynamic> json) =
      _$IssueItemImpl.fromJson;

  @override
  String get severity;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$IssueItemImplCopyWith<_$IssueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissingKeywordItem _$MissingKeywordItemFromJson(Map<String, dynamic> json) {
  return _MissingKeywordItem.fromJson(json);
}

/// @nodoc
mixin _$MissingKeywordItem {
  String get word => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissingKeywordItemCopyWith<MissingKeywordItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissingKeywordItemCopyWith<$Res> {
  factory $MissingKeywordItemCopyWith(
          MissingKeywordItem value, $Res Function(MissingKeywordItem) then) =
      _$MissingKeywordItemCopyWithImpl<$Res, MissingKeywordItem>;
  @useResult
  $Res call({String word, String priority});
}

/// @nodoc
class _$MissingKeywordItemCopyWithImpl<$Res, $Val extends MissingKeywordItem>
    implements $MissingKeywordItemCopyWith<$Res> {
  _$MissingKeywordItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissingKeywordItemImplCopyWith<$Res>
    implements $MissingKeywordItemCopyWith<$Res> {
  factory _$$MissingKeywordItemImplCopyWith(_$MissingKeywordItemImpl value,
          $Res Function(_$MissingKeywordItemImpl) then) =
      __$$MissingKeywordItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String word, String priority});
}

/// @nodoc
class __$$MissingKeywordItemImplCopyWithImpl<$Res>
    extends _$MissingKeywordItemCopyWithImpl<$Res, _$MissingKeywordItemImpl>
    implements _$$MissingKeywordItemImplCopyWith<$Res> {
  __$$MissingKeywordItemImplCopyWithImpl(_$MissingKeywordItemImpl _value,
      $Res Function(_$MissingKeywordItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? priority = null,
  }) {
    return _then(_$MissingKeywordItemImpl(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissingKeywordItemImpl implements _MissingKeywordItem {
  const _$MissingKeywordItemImpl({required this.word, required this.priority});

  factory _$MissingKeywordItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissingKeywordItemImplFromJson(json);

  @override
  final String word;
  @override
  final String priority;

  @override
  String toString() {
    return 'MissingKeywordItem(word: $word, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissingKeywordItemImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, word, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissingKeywordItemImplCopyWith<_$MissingKeywordItemImpl> get copyWith =>
      __$$MissingKeywordItemImplCopyWithImpl<_$MissingKeywordItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissingKeywordItemImplToJson(
      this,
    );
  }
}

abstract class _MissingKeywordItem implements MissingKeywordItem {
  const factory _MissingKeywordItem(
      {required final String word,
      required final String priority}) = _$MissingKeywordItemImpl;

  factory _MissingKeywordItem.fromJson(Map<String, dynamic> json) =
      _$MissingKeywordItemImpl.fromJson;

  @override
  String get word;
  @override
  String get priority;
  @override
  @JsonKey(ignore: true)
  _$$MissingKeywordItemImplCopyWith<_$MissingKeywordItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RewriteItem _$RewriteItemFromJson(Map<String, dynamic> json) {
  return _RewriteItem.fromJson(json);
}

/// @nodoc
mixin _$RewriteItem {
  String get original => throw _privateConstructorUsedError;
  String get improved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RewriteItemCopyWith<RewriteItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RewriteItemCopyWith<$Res> {
  factory $RewriteItemCopyWith(
          RewriteItem value, $Res Function(RewriteItem) then) =
      _$RewriteItemCopyWithImpl<$Res, RewriteItem>;
  @useResult
  $Res call({String original, String improved});
}

/// @nodoc
class _$RewriteItemCopyWithImpl<$Res, $Val extends RewriteItem>
    implements $RewriteItemCopyWith<$Res> {
  _$RewriteItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? improved = null,
  }) {
    return _then(_value.copyWith(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      improved: null == improved
          ? _value.improved
          : improved // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RewriteItemImplCopyWith<$Res>
    implements $RewriteItemCopyWith<$Res> {
  factory _$$RewriteItemImplCopyWith(
          _$RewriteItemImpl value, $Res Function(_$RewriteItemImpl) then) =
      __$$RewriteItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String original, String improved});
}

/// @nodoc
class __$$RewriteItemImplCopyWithImpl<$Res>
    extends _$RewriteItemCopyWithImpl<$Res, _$RewriteItemImpl>
    implements _$$RewriteItemImplCopyWith<$Res> {
  __$$RewriteItemImplCopyWithImpl(
      _$RewriteItemImpl _value, $Res Function(_$RewriteItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? improved = null,
  }) {
    return _then(_$RewriteItemImpl(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      improved: null == improved
          ? _value.improved
          : improved // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RewriteItemImpl implements _RewriteItem {
  const _$RewriteItemImpl({required this.original, required this.improved});

  factory _$RewriteItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RewriteItemImplFromJson(json);

  @override
  final String original;
  @override
  final String improved;

  @override
  String toString() {
    return 'RewriteItem(original: $original, improved: $improved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RewriteItemImpl &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.improved, improved) ||
                other.improved == improved));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, original, improved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RewriteItemImplCopyWith<_$RewriteItemImpl> get copyWith =>
      __$$RewriteItemImplCopyWithImpl<_$RewriteItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RewriteItemImplToJson(
      this,
    );
  }
}

abstract class _RewriteItem implements RewriteItem {
  const factory _RewriteItem(
      {required final String original,
      required final String improved}) = _$RewriteItemImpl;

  factory _RewriteItem.fromJson(Map<String, dynamic> json) =
      _$RewriteItemImpl.fromJson;

  @override
  String get original;
  @override
  String get improved;
  @override
  @JsonKey(ignore: true)
  _$$RewriteItemImplCopyWith<_$RewriteItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionPlanItem _$ActionPlanItemFromJson(Map<String, dynamic> json) {
  return _ActionPlanItem.fromJson(json);
}

/// @nodoc
mixin _$ActionPlanItem {
  int get step => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'potential_gain')
  String? get potentialGain => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionPlanItemCopyWith<ActionPlanItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionPlanItemCopyWith<$Res> {
  factory $ActionPlanItemCopyWith(
          ActionPlanItem value, $Res Function(ActionPlanItem) then) =
      _$ActionPlanItemCopyWithImpl<$Res, ActionPlanItem>;
  @useResult
  $Res call(
      {int step,
      String description,
      @JsonKey(name: 'potential_gain') String? potentialGain});
}

/// @nodoc
class _$ActionPlanItemCopyWithImpl<$Res, $Val extends ActionPlanItem>
    implements $ActionPlanItemCopyWith<$Res> {
  _$ActionPlanItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? description = null,
    Object? potentialGain = freezed,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      potentialGain: freezed == potentialGain
          ? _value.potentialGain
          : potentialGain // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionPlanItemImplCopyWith<$Res>
    implements $ActionPlanItemCopyWith<$Res> {
  factory _$$ActionPlanItemImplCopyWith(_$ActionPlanItemImpl value,
          $Res Function(_$ActionPlanItemImpl) then) =
      __$$ActionPlanItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int step,
      String description,
      @JsonKey(name: 'potential_gain') String? potentialGain});
}

/// @nodoc
class __$$ActionPlanItemImplCopyWithImpl<$Res>
    extends _$ActionPlanItemCopyWithImpl<$Res, _$ActionPlanItemImpl>
    implements _$$ActionPlanItemImplCopyWith<$Res> {
  __$$ActionPlanItemImplCopyWithImpl(
      _$ActionPlanItemImpl _value, $Res Function(_$ActionPlanItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? description = null,
    Object? potentialGain = freezed,
  }) {
    return _then(_$ActionPlanItemImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      potentialGain: freezed == potentialGain
          ? _value.potentialGain
          : potentialGain // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionPlanItemImpl implements _ActionPlanItem {
  const _$ActionPlanItemImpl(
      {required this.step,
      required this.description,
      @JsonKey(name: 'potential_gain') this.potentialGain});

  factory _$ActionPlanItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionPlanItemImplFromJson(json);

  @override
  final int step;
  @override
  final String description;
  @override
  @JsonKey(name: 'potential_gain')
  final String? potentialGain;

  @override
  String toString() {
    return 'ActionPlanItem(step: $step, description: $description, potentialGain: $potentialGain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionPlanItemImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.potentialGain, potentialGain) ||
                other.potentialGain == potentialGain));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, step, description, potentialGain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionPlanItemImplCopyWith<_$ActionPlanItemImpl> get copyWith =>
      __$$ActionPlanItemImplCopyWithImpl<_$ActionPlanItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionPlanItemImplToJson(
      this,
    );
  }
}

abstract class _ActionPlanItem implements ActionPlanItem {
  const factory _ActionPlanItem(
          {required final int step,
          required final String description,
          @JsonKey(name: 'potential_gain') final String? potentialGain}) =
      _$ActionPlanItemImpl;

  factory _ActionPlanItem.fromJson(Map<String, dynamic> json) =
      _$ActionPlanItemImpl.fromJson;

  @override
  int get step;
  @override
  String get description;
  @override
  @JsonKey(name: 'potential_gain')
  String? get potentialGain;
  @override
  @JsonKey(ignore: true)
  _$$ActionPlanItemImplCopyWith<_$ActionPlanItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalysisResultResponse _$AnalysisResultResponseFromJson(
    Map<String, dynamic> json) {
  return _AnalysisResultResponse.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResultResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_id')
  int get resumeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_score')
  int? get overallScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'ats_score')
  int? get atsScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'recruiter_score')
  int? get recruiterScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_label')
  String? get overallLabel => throw _privateConstructorUsedError;
  List<BreakdownItem> get breakdown => throw _privateConstructorUsedError;
  List<IssueItem> get issues => throw _privateConstructorUsedError;
  @JsonKey(name: 'missing_keywords')
  List<MissingKeywordItem> get missingKeywords =>
      throw _privateConstructorUsedError;
  List<RewriteItem> get rewrites => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_plan')
  List<ActionPlanItem> get actionPlan => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnalysisResultResponseCopyWith<AnalysisResultResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResultResponseCopyWith<$Res> {
  factory $AnalysisResultResponseCopyWith(AnalysisResultResponse value,
          $Res Function(AnalysisResultResponse) then) =
      _$AnalysisResultResponseCopyWithImpl<$Res, AnalysisResultResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'resume_id') int resumeId,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId,
      @JsonKey(name: 'overall_score') int? overallScore,
      @JsonKey(name: 'ats_score') int? atsScore,
      @JsonKey(name: 'recruiter_score') int? recruiterScore,
      @JsonKey(name: 'overall_label') String? overallLabel,
      List<BreakdownItem> breakdown,
      List<IssueItem> issues,
      @JsonKey(name: 'missing_keywords')
      List<MissingKeywordItem> missingKeywords,
      List<RewriteItem> rewrites,
      @JsonKey(name: 'action_plan') List<ActionPlanItem> actionPlan,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$AnalysisResultResponseCopyWithImpl<$Res,
        $Val extends AnalysisResultResponse>
    implements $AnalysisResultResponseCopyWith<$Res> {
  _$AnalysisResultResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resumeId = null,
    Object? resumeVersionId = freezed,
    Object? overallScore = freezed,
    Object? atsScore = freezed,
    Object? recruiterScore = freezed,
    Object? overallLabel = freezed,
    Object? breakdown = null,
    Object? issues = null,
    Object? missingKeywords = null,
    Object? rewrites = null,
    Object? actionPlan = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      resumeId: null == resumeId
          ? _value.resumeId
          : resumeId // ignore: cast_nullable_to_non_nullable
              as int,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
      overallScore: freezed == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int?,
      atsScore: freezed == atsScore
          ? _value.atsScore
          : atsScore // ignore: cast_nullable_to_non_nullable
              as int?,
      recruiterScore: freezed == recruiterScore
          ? _value.recruiterScore
          : recruiterScore // ignore: cast_nullable_to_non_nullable
              as int?,
      overallLabel: freezed == overallLabel
          ? _value.overallLabel
          : overallLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      breakdown: null == breakdown
          ? _value.breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as List<BreakdownItem>,
      issues: null == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<IssueItem>,
      missingKeywords: null == missingKeywords
          ? _value.missingKeywords
          : missingKeywords // ignore: cast_nullable_to_non_nullable
              as List<MissingKeywordItem>,
      rewrites: null == rewrites
          ? _value.rewrites
          : rewrites // ignore: cast_nullable_to_non_nullable
              as List<RewriteItem>,
      actionPlan: null == actionPlan
          ? _value.actionPlan
          : actionPlan // ignore: cast_nullable_to_non_nullable
              as List<ActionPlanItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalysisResultResponseImplCopyWith<$Res>
    implements $AnalysisResultResponseCopyWith<$Res> {
  factory _$$AnalysisResultResponseImplCopyWith(
          _$AnalysisResultResponseImpl value,
          $Res Function(_$AnalysisResultResponseImpl) then) =
      __$$AnalysisResultResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'resume_id') int resumeId,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId,
      @JsonKey(name: 'overall_score') int? overallScore,
      @JsonKey(name: 'ats_score') int? atsScore,
      @JsonKey(name: 'recruiter_score') int? recruiterScore,
      @JsonKey(name: 'overall_label') String? overallLabel,
      List<BreakdownItem> breakdown,
      List<IssueItem> issues,
      @JsonKey(name: 'missing_keywords')
      List<MissingKeywordItem> missingKeywords,
      List<RewriteItem> rewrites,
      @JsonKey(name: 'action_plan') List<ActionPlanItem> actionPlan,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$AnalysisResultResponseImplCopyWithImpl<$Res>
    extends _$AnalysisResultResponseCopyWithImpl<$Res,
        _$AnalysisResultResponseImpl>
    implements _$$AnalysisResultResponseImplCopyWith<$Res> {
  __$$AnalysisResultResponseImplCopyWithImpl(
      _$AnalysisResultResponseImpl _value,
      $Res Function(_$AnalysisResultResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resumeId = null,
    Object? resumeVersionId = freezed,
    Object? overallScore = freezed,
    Object? atsScore = freezed,
    Object? recruiterScore = freezed,
    Object? overallLabel = freezed,
    Object? breakdown = null,
    Object? issues = null,
    Object? missingKeywords = null,
    Object? rewrites = null,
    Object? actionPlan = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AnalysisResultResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      resumeId: null == resumeId
          ? _value.resumeId
          : resumeId // ignore: cast_nullable_to_non_nullable
              as int,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
      overallScore: freezed == overallScore
          ? _value.overallScore
          : overallScore // ignore: cast_nullable_to_non_nullable
              as int?,
      atsScore: freezed == atsScore
          ? _value.atsScore
          : atsScore // ignore: cast_nullable_to_non_nullable
              as int?,
      recruiterScore: freezed == recruiterScore
          ? _value.recruiterScore
          : recruiterScore // ignore: cast_nullable_to_non_nullable
              as int?,
      overallLabel: freezed == overallLabel
          ? _value.overallLabel
          : overallLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      breakdown: null == breakdown
          ? _value._breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as List<BreakdownItem>,
      issues: null == issues
          ? _value._issues
          : issues // ignore: cast_nullable_to_non_nullable
              as List<IssueItem>,
      missingKeywords: null == missingKeywords
          ? _value._missingKeywords
          : missingKeywords // ignore: cast_nullable_to_non_nullable
              as List<MissingKeywordItem>,
      rewrites: null == rewrites
          ? _value._rewrites
          : rewrites // ignore: cast_nullable_to_non_nullable
              as List<RewriteItem>,
      actionPlan: null == actionPlan
          ? _value._actionPlan
          : actionPlan // ignore: cast_nullable_to_non_nullable
              as List<ActionPlanItem>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResultResponseImpl implements _AnalysisResultResponse {
  const _$AnalysisResultResponseImpl(
      {required this.id,
      @JsonKey(name: 'resume_id') required this.resumeId,
      @JsonKey(name: 'resume_version_id') this.resumeVersionId,
      @JsonKey(name: 'overall_score') this.overallScore,
      @JsonKey(name: 'ats_score') this.atsScore,
      @JsonKey(name: 'recruiter_score') this.recruiterScore,
      @JsonKey(name: 'overall_label') this.overallLabel,
      final List<BreakdownItem> breakdown = const [],
      final List<IssueItem> issues = const [],
      @JsonKey(name: 'missing_keywords')
      final List<MissingKeywordItem> missingKeywords = const [],
      final List<RewriteItem> rewrites = const [],
      @JsonKey(name: 'action_plan')
      final List<ActionPlanItem> actionPlan = const [],
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _breakdown = breakdown,
        _issues = issues,
        _missingKeywords = missingKeywords,
        _rewrites = rewrites,
        _actionPlan = actionPlan;

  factory _$AnalysisResultResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResultResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'resume_id')
  final int resumeId;
  @override
  @JsonKey(name: 'resume_version_id')
  final int? resumeVersionId;
  @override
  @JsonKey(name: 'overall_score')
  final int? overallScore;
  @override
  @JsonKey(name: 'ats_score')
  final int? atsScore;
  @override
  @JsonKey(name: 'recruiter_score')
  final int? recruiterScore;
  @override
  @JsonKey(name: 'overall_label')
  final String? overallLabel;
  final List<BreakdownItem> _breakdown;
  @override
  @JsonKey()
  List<BreakdownItem> get breakdown {
    if (_breakdown is EqualUnmodifiableListView) return _breakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakdown);
  }

  final List<IssueItem> _issues;
  @override
  @JsonKey()
  List<IssueItem> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  final List<MissingKeywordItem> _missingKeywords;
  @override
  @JsonKey(name: 'missing_keywords')
  List<MissingKeywordItem> get missingKeywords {
    if (_missingKeywords is EqualUnmodifiableListView) return _missingKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingKeywords);
  }

  final List<RewriteItem> _rewrites;
  @override
  @JsonKey()
  List<RewriteItem> get rewrites {
    if (_rewrites is EqualUnmodifiableListView) return _rewrites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rewrites);
  }

  final List<ActionPlanItem> _actionPlan;
  @override
  @JsonKey(name: 'action_plan')
  List<ActionPlanItem> get actionPlan {
    if (_actionPlan is EqualUnmodifiableListView) return _actionPlan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionPlan);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AnalysisResultResponse(id: $id, resumeId: $resumeId, resumeVersionId: $resumeVersionId, overallScore: $overallScore, atsScore: $atsScore, recruiterScore: $recruiterScore, overallLabel: $overallLabel, breakdown: $breakdown, issues: $issues, missingKeywords: $missingKeywords, rewrites: $rewrites, actionPlan: $actionPlan, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResultResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.resumeId, resumeId) ||
                other.resumeId == resumeId) &&
            (identical(other.resumeVersionId, resumeVersionId) ||
                other.resumeVersionId == resumeVersionId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.atsScore, atsScore) ||
                other.atsScore == atsScore) &&
            (identical(other.recruiterScore, recruiterScore) ||
                other.recruiterScore == recruiterScore) &&
            (identical(other.overallLabel, overallLabel) ||
                other.overallLabel == overallLabel) &&
            const DeepCollectionEquality()
                .equals(other._breakdown, _breakdown) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            const DeepCollectionEquality()
                .equals(other._missingKeywords, _missingKeywords) &&
            const DeepCollectionEquality().equals(other._rewrites, _rewrites) &&
            const DeepCollectionEquality()
                .equals(other._actionPlan, _actionPlan) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      resumeId,
      resumeVersionId,
      overallScore,
      atsScore,
      recruiterScore,
      overallLabel,
      const DeepCollectionEquality().hash(_breakdown),
      const DeepCollectionEquality().hash(_issues),
      const DeepCollectionEquality().hash(_missingKeywords),
      const DeepCollectionEquality().hash(_rewrites),
      const DeepCollectionEquality().hash(_actionPlan),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResultResponseImplCopyWith<_$AnalysisResultResponseImpl>
      get copyWith => __$$AnalysisResultResponseImplCopyWithImpl<
          _$AnalysisResultResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResultResponseImplToJson(
      this,
    );
  }
}

abstract class _AnalysisResultResponse implements AnalysisResultResponse {
  const factory _AnalysisResultResponse(
          {required final int id,
          @JsonKey(name: 'resume_id') required final int resumeId,
          @JsonKey(name: 'resume_version_id') final int? resumeVersionId,
          @JsonKey(name: 'overall_score') final int? overallScore,
          @JsonKey(name: 'ats_score') final int? atsScore,
          @JsonKey(name: 'recruiter_score') final int? recruiterScore,
          @JsonKey(name: 'overall_label') final String? overallLabel,
          final List<BreakdownItem> breakdown,
          final List<IssueItem> issues,
          @JsonKey(name: 'missing_keywords')
          final List<MissingKeywordItem> missingKeywords,
          final List<RewriteItem> rewrites,
          @JsonKey(name: 'action_plan') final List<ActionPlanItem> actionPlan,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$AnalysisResultResponseImpl;

  factory _AnalysisResultResponse.fromJson(Map<String, dynamic> json) =
      _$AnalysisResultResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'resume_id')
  int get resumeId;
  @override
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId;
  @override
  @JsonKey(name: 'overall_score')
  int? get overallScore;
  @override
  @JsonKey(name: 'ats_score')
  int? get atsScore;
  @override
  @JsonKey(name: 'recruiter_score')
  int? get recruiterScore;
  @override
  @JsonKey(name: 'overall_label')
  String? get overallLabel;
  @override
  List<BreakdownItem> get breakdown;
  @override
  List<IssueItem> get issues;
  @override
  @JsonKey(name: 'missing_keywords')
  List<MissingKeywordItem> get missingKeywords;
  @override
  List<RewriteItem> get rewrites;
  @override
  @JsonKey(name: 'action_plan')
  List<ActionPlanItem> get actionPlan;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AnalysisResultResponseImplCopyWith<_$AnalysisResultResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
