// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DkgRound2Error {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidProofOfKnowledge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DkgRound2Error_General value) general,
    required TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)
        invalidProofOfKnowledge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DkgRound2Error_General value)? general,
    TResult? Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DkgRound2Error_General value)? general,
    TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DkgRound2ErrorCopyWith<$Res> {
  factory $DkgRound2ErrorCopyWith(
          DkgRound2Error value, $Res Function(DkgRound2Error) then) =
      _$DkgRound2ErrorCopyWithImpl<$Res, DkgRound2Error>;
}

/// @nodoc
class _$DkgRound2ErrorCopyWithImpl<$Res, $Val extends DkgRound2Error>
    implements $DkgRound2ErrorCopyWith<$Res> {
  _$DkgRound2ErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DkgRound2Error_GeneralImplCopyWith<$Res> {
  factory _$$DkgRound2Error_GeneralImplCopyWith(
          _$DkgRound2Error_GeneralImpl value,
          $Res Function(_$DkgRound2Error_GeneralImpl) then) =
      __$$DkgRound2Error_GeneralImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DkgRound2Error_GeneralImplCopyWithImpl<$Res>
    extends _$DkgRound2ErrorCopyWithImpl<$Res, _$DkgRound2Error_GeneralImpl>
    implements _$$DkgRound2Error_GeneralImplCopyWith<$Res> {
  __$$DkgRound2Error_GeneralImplCopyWithImpl(
      _$DkgRound2Error_GeneralImpl _value,
      $Res Function(_$DkgRound2Error_GeneralImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$DkgRound2Error_GeneralImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DkgRound2Error_GeneralImpl extends DkgRound2Error_General {
  const _$DkgRound2Error_GeneralImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'DkgRound2Error.general(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DkgRound2Error_GeneralImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DkgRound2Error_GeneralImplCopyWith<_$DkgRound2Error_GeneralImpl>
      get copyWith => __$$DkgRound2Error_GeneralImplCopyWithImpl<
          _$DkgRound2Error_GeneralImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidProofOfKnowledge,
  }) {
    return general(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
  }) {
    return general?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DkgRound2Error_General value) general,
    required TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)
        invalidProofOfKnowledge,
  }) {
    return general(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DkgRound2Error_General value)? general,
    TResult? Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
  }) {
    return general?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DkgRound2Error_General value)? general,
    TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(this);
    }
    return orElse();
  }
}

abstract class DkgRound2Error_General extends DkgRound2Error {
  const factory DkgRound2Error_General({required final String message}) =
      _$DkgRound2Error_GeneralImpl;
  const DkgRound2Error_General._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$DkgRound2Error_GeneralImplCopyWith<_$DkgRound2Error_GeneralImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWith<$Res> {
  factory _$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWith(
          _$DkgRound2Error_InvalidProofOfKnowledgeImpl value,
          $Res Function(_$DkgRound2Error_InvalidProofOfKnowledgeImpl) then) =
      __$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IdentifierOpaque culprit});
}

/// @nodoc
class __$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWithImpl<$Res>
    extends _$DkgRound2ErrorCopyWithImpl<$Res,
        _$DkgRound2Error_InvalidProofOfKnowledgeImpl>
    implements _$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWith<$Res> {
  __$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWithImpl(
      _$DkgRound2Error_InvalidProofOfKnowledgeImpl _value,
      $Res Function(_$DkgRound2Error_InvalidProofOfKnowledgeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? culprit = null,
  }) {
    return _then(_$DkgRound2Error_InvalidProofOfKnowledgeImpl(
      culprit: null == culprit
          ? _value.culprit
          : culprit // ignore: cast_nullable_to_non_nullable
              as IdentifierOpaque,
    ));
  }
}

/// @nodoc

class _$DkgRound2Error_InvalidProofOfKnowledgeImpl
    extends DkgRound2Error_InvalidProofOfKnowledge {
  const _$DkgRound2Error_InvalidProofOfKnowledgeImpl({required this.culprit})
      : super._();

  @override
  final IdentifierOpaque culprit;

  @override
  String toString() {
    return 'DkgRound2Error.invalidProofOfKnowledge(culprit: $culprit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DkgRound2Error_InvalidProofOfKnowledgeImpl &&
            (identical(other.culprit, culprit) || other.culprit == culprit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, culprit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWith<
          _$DkgRound2Error_InvalidProofOfKnowledgeImpl>
      get copyWith =>
          __$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWithImpl<
              _$DkgRound2Error_InvalidProofOfKnowledgeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidProofOfKnowledge,
  }) {
    return invalidProofOfKnowledge(culprit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
  }) {
    return invalidProofOfKnowledge?.call(culprit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidProofOfKnowledge,
    required TResult orElse(),
  }) {
    if (invalidProofOfKnowledge != null) {
      return invalidProofOfKnowledge(culprit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DkgRound2Error_General value) general,
    required TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)
        invalidProofOfKnowledge,
  }) {
    return invalidProofOfKnowledge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DkgRound2Error_General value)? general,
    TResult? Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
  }) {
    return invalidProofOfKnowledge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DkgRound2Error_General value)? general,
    TResult Function(DkgRound2Error_InvalidProofOfKnowledge value)?
        invalidProofOfKnowledge,
    required TResult orElse(),
  }) {
    if (invalidProofOfKnowledge != null) {
      return invalidProofOfKnowledge(this);
    }
    return orElse();
  }
}

abstract class DkgRound2Error_InvalidProofOfKnowledge extends DkgRound2Error {
  const factory DkgRound2Error_InvalidProofOfKnowledge(
          {required final IdentifierOpaque culprit}) =
      _$DkgRound2Error_InvalidProofOfKnowledgeImpl;
  const DkgRound2Error_InvalidProofOfKnowledge._() : super._();

  IdentifierOpaque get culprit;
  @JsonKey(ignore: true)
  _$$DkgRound2Error_InvalidProofOfKnowledgeImplCopyWith<
          _$DkgRound2Error_InvalidProofOfKnowledgeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SignAggregationError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidSignShare,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignAggregationError_General value) general,
    required TResult Function(SignAggregationError_InvalidSignShare value)
        invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignAggregationError_General value)? general,
    TResult? Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignAggregationError_General value)? general,
    TResult Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignAggregationErrorCopyWith<$Res> {
  factory $SignAggregationErrorCopyWith(SignAggregationError value,
          $Res Function(SignAggregationError) then) =
      _$SignAggregationErrorCopyWithImpl<$Res, SignAggregationError>;
}

/// @nodoc
class _$SignAggregationErrorCopyWithImpl<$Res,
        $Val extends SignAggregationError>
    implements $SignAggregationErrorCopyWith<$Res> {
  _$SignAggregationErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SignAggregationError_GeneralImplCopyWith<$Res> {
  factory _$$SignAggregationError_GeneralImplCopyWith(
          _$SignAggregationError_GeneralImpl value,
          $Res Function(_$SignAggregationError_GeneralImpl) then) =
      __$$SignAggregationError_GeneralImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SignAggregationError_GeneralImplCopyWithImpl<$Res>
    extends _$SignAggregationErrorCopyWithImpl<$Res,
        _$SignAggregationError_GeneralImpl>
    implements _$$SignAggregationError_GeneralImplCopyWith<$Res> {
  __$$SignAggregationError_GeneralImplCopyWithImpl(
      _$SignAggregationError_GeneralImpl _value,
      $Res Function(_$SignAggregationError_GeneralImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SignAggregationError_GeneralImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignAggregationError_GeneralImpl extends SignAggregationError_General {
  const _$SignAggregationError_GeneralImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'SignAggregationError.general(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignAggregationError_GeneralImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignAggregationError_GeneralImplCopyWith<
          _$SignAggregationError_GeneralImpl>
      get copyWith => __$$SignAggregationError_GeneralImplCopyWithImpl<
          _$SignAggregationError_GeneralImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidSignShare,
  }) {
    return general(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidSignShare,
  }) {
    return general?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidSignShare,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignAggregationError_General value) general,
    required TResult Function(SignAggregationError_InvalidSignShare value)
        invalidSignShare,
  }) {
    return general(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignAggregationError_General value)? general,
    TResult? Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
  }) {
    return general?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignAggregationError_General value)? general,
    TResult Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
    required TResult orElse(),
  }) {
    if (general != null) {
      return general(this);
    }
    return orElse();
  }
}

abstract class SignAggregationError_General extends SignAggregationError {
  const factory SignAggregationError_General({required final String message}) =
      _$SignAggregationError_GeneralImpl;
  const SignAggregationError_General._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$SignAggregationError_GeneralImplCopyWith<
          _$SignAggregationError_GeneralImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignAggregationError_InvalidSignShareImplCopyWith<$Res> {
  factory _$$SignAggregationError_InvalidSignShareImplCopyWith(
          _$SignAggregationError_InvalidSignShareImpl value,
          $Res Function(_$SignAggregationError_InvalidSignShareImpl) then) =
      __$$SignAggregationError_InvalidSignShareImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IdentifierOpaque culprit});
}

/// @nodoc
class __$$SignAggregationError_InvalidSignShareImplCopyWithImpl<$Res>
    extends _$SignAggregationErrorCopyWithImpl<$Res,
        _$SignAggregationError_InvalidSignShareImpl>
    implements _$$SignAggregationError_InvalidSignShareImplCopyWith<$Res> {
  __$$SignAggregationError_InvalidSignShareImplCopyWithImpl(
      _$SignAggregationError_InvalidSignShareImpl _value,
      $Res Function(_$SignAggregationError_InvalidSignShareImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? culprit = null,
  }) {
    return _then(_$SignAggregationError_InvalidSignShareImpl(
      culprit: null == culprit
          ? _value.culprit
          : culprit // ignore: cast_nullable_to_non_nullable
              as IdentifierOpaque,
    ));
  }
}

/// @nodoc

class _$SignAggregationError_InvalidSignShareImpl
    extends SignAggregationError_InvalidSignShare {
  const _$SignAggregationError_InvalidSignShareImpl({required this.culprit})
      : super._();

  @override
  final IdentifierOpaque culprit;

  @override
  String toString() {
    return 'SignAggregationError.invalidSignShare(culprit: $culprit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignAggregationError_InvalidSignShareImpl &&
            (identical(other.culprit, culprit) || other.culprit == culprit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, culprit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignAggregationError_InvalidSignShareImplCopyWith<
          _$SignAggregationError_InvalidSignShareImpl>
      get copyWith => __$$SignAggregationError_InvalidSignShareImplCopyWithImpl<
          _$SignAggregationError_InvalidSignShareImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(IdentifierOpaque culprit) invalidSignShare,
  }) {
    return invalidSignShare(culprit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(IdentifierOpaque culprit)? invalidSignShare,
  }) {
    return invalidSignShare?.call(culprit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(IdentifierOpaque culprit)? invalidSignShare,
    required TResult orElse(),
  }) {
    if (invalidSignShare != null) {
      return invalidSignShare(culprit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignAggregationError_General value) general,
    required TResult Function(SignAggregationError_InvalidSignShare value)
        invalidSignShare,
  }) {
    return invalidSignShare(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignAggregationError_General value)? general,
    TResult? Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
  }) {
    return invalidSignShare?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignAggregationError_General value)? general,
    TResult Function(SignAggregationError_InvalidSignShare value)?
        invalidSignShare,
    required TResult orElse(),
  }) {
    if (invalidSignShare != null) {
      return invalidSignShare(this);
    }
    return orElse();
  }
}

abstract class SignAggregationError_InvalidSignShare
    extends SignAggregationError {
  const factory SignAggregationError_InvalidSignShare(
          {required final IdentifierOpaque culprit}) =
      _$SignAggregationError_InvalidSignShareImpl;
  const SignAggregationError_InvalidSignShare._() : super._();

  IdentifierOpaque get culprit;
  @JsonKey(ignore: true)
  _$$SignAggregationError_InvalidSignShareImplCopyWith<
          _$SignAggregationError_InvalidSignShareImpl>
      get copyWith => throw _privateConstructorUsedError;
}
