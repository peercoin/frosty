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
mixin _$SignAggregationError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) general,
    required TResult Function(FrostIdentifier culprit) invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(FrostIdentifier culprit)? invalidSignShare,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(FrostIdentifier culprit)? invalidSignShare,
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

class _$SignAggregationError_GeneralImpl
    implements SignAggregationError_General {
  const _$SignAggregationError_GeneralImpl({required this.message});

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
    required TResult Function(FrostIdentifier culprit) invalidSignShare,
  }) {
    return general(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(FrostIdentifier culprit)? invalidSignShare,
  }) {
    return general?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(FrostIdentifier culprit)? invalidSignShare,
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

abstract class SignAggregationError_General implements SignAggregationError {
  const factory SignAggregationError_General({required final String message}) =
      _$SignAggregationError_GeneralImpl;

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
  $Res call({FrostIdentifier culprit});
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
              as FrostIdentifier,
    ));
  }
}

/// @nodoc

class _$SignAggregationError_InvalidSignShareImpl
    implements SignAggregationError_InvalidSignShare {
  const _$SignAggregationError_InvalidSignShareImpl({required this.culprit});

  @override
  final FrostIdentifier culprit;

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
    required TResult Function(FrostIdentifier culprit) invalidSignShare,
  }) {
    return invalidSignShare(culprit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? general,
    TResult? Function(FrostIdentifier culprit)? invalidSignShare,
  }) {
    return invalidSignShare?.call(culprit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? general,
    TResult Function(FrostIdentifier culprit)? invalidSignShare,
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
    implements SignAggregationError {
  const factory SignAggregationError_InvalidSignShare(
          {required final FrostIdentifier culprit}) =
      _$SignAggregationError_InvalidSignShareImpl;

  FrostIdentifier get culprit;
  @JsonKey(ignore: true)
  _$$SignAggregationError_InvalidSignShareImplCopyWith<
          _$SignAggregationError_InvalidSignShareImpl>
      get copyWith => throw _privateConstructorUsedError;
}
