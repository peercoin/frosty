// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DkgRound2Error {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DkgRound2Error);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DkgRound2Error()';
}


}

/// @nodoc
class $DkgRound2ErrorCopyWith<$Res>  {
$DkgRound2ErrorCopyWith(DkgRound2Error _, $Res Function(DkgRound2Error) __);
}


/// Adds pattern-matching-related methods to [DkgRound2Error].
extension DkgRound2ErrorPatterns on DkgRound2Error {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DkgRound2Error_General value)?  general,TResult Function( DkgRound2Error_InvalidProofOfKnowledge value)?  invalidProofOfKnowledge,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DkgRound2Error_General() when general != null:
return general(_that);case DkgRound2Error_InvalidProofOfKnowledge() when invalidProofOfKnowledge != null:
return invalidProofOfKnowledge(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DkgRound2Error_General value)  general,required TResult Function( DkgRound2Error_InvalidProofOfKnowledge value)  invalidProofOfKnowledge,}){
final _that = this;
switch (_that) {
case DkgRound2Error_General():
return general(_that);case DkgRound2Error_InvalidProofOfKnowledge():
return invalidProofOfKnowledge(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DkgRound2Error_General value)?  general,TResult? Function( DkgRound2Error_InvalidProofOfKnowledge value)?  invalidProofOfKnowledge,}){
final _that = this;
switch (_that) {
case DkgRound2Error_General() when general != null:
return general(_that);case DkgRound2Error_InvalidProofOfKnowledge() when invalidProofOfKnowledge != null:
return invalidProofOfKnowledge(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  general,TResult Function( IdentifierOpaque culprit)?  invalidProofOfKnowledge,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DkgRound2Error_General() when general != null:
return general(_that.message);case DkgRound2Error_InvalidProofOfKnowledge() when invalidProofOfKnowledge != null:
return invalidProofOfKnowledge(_that.culprit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  general,required TResult Function( IdentifierOpaque culprit)  invalidProofOfKnowledge,}) {final _that = this;
switch (_that) {
case DkgRound2Error_General():
return general(_that.message);case DkgRound2Error_InvalidProofOfKnowledge():
return invalidProofOfKnowledge(_that.culprit);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  general,TResult? Function( IdentifierOpaque culprit)?  invalidProofOfKnowledge,}) {final _that = this;
switch (_that) {
case DkgRound2Error_General() when general != null:
return general(_that.message);case DkgRound2Error_InvalidProofOfKnowledge() when invalidProofOfKnowledge != null:
return invalidProofOfKnowledge(_that.culprit);case _:
  return null;

}
}

}

/// @nodoc


class DkgRound2Error_General extends DkgRound2Error {
  const DkgRound2Error_General({required this.message}): super._();


 final  String message;

/// Create a copy of DkgRound2Error
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DkgRound2Error_GeneralCopyWith<DkgRound2Error_General> get copyWith => _$DkgRound2Error_GeneralCopyWithImpl<DkgRound2Error_General>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DkgRound2Error_General&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'DkgRound2Error.general(message: $message)';
}


}

/// @nodoc
abstract mixin class $DkgRound2Error_GeneralCopyWith<$Res> implements $DkgRound2ErrorCopyWith<$Res> {
  factory $DkgRound2Error_GeneralCopyWith(DkgRound2Error_General value, $Res Function(DkgRound2Error_General) _then) = _$DkgRound2Error_GeneralCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DkgRound2Error_GeneralCopyWithImpl<$Res>
    implements $DkgRound2Error_GeneralCopyWith<$Res> {
  _$DkgRound2Error_GeneralCopyWithImpl(this._self, this._then);

  final DkgRound2Error_General _self;
  final $Res Function(DkgRound2Error_General) _then;

/// Create a copy of DkgRound2Error
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DkgRound2Error_General(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DkgRound2Error_InvalidProofOfKnowledge extends DkgRound2Error {
  const DkgRound2Error_InvalidProofOfKnowledge({required this.culprit}): super._();


 final  IdentifierOpaque culprit;

/// Create a copy of DkgRound2Error
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DkgRound2Error_InvalidProofOfKnowledgeCopyWith<DkgRound2Error_InvalidProofOfKnowledge> get copyWith => _$DkgRound2Error_InvalidProofOfKnowledgeCopyWithImpl<DkgRound2Error_InvalidProofOfKnowledge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DkgRound2Error_InvalidProofOfKnowledge&&(identical(other.culprit, culprit) || other.culprit == culprit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,culprit);
}

@override
String toString() {
    return 'DkgRound2Error.invalidProofOfKnowledge(culprit: $culprit)';
}


}

/// @nodoc
abstract mixin class $DkgRound2Error_InvalidProofOfKnowledgeCopyWith<$Res> implements $DkgRound2ErrorCopyWith<$Res> {
  factory $DkgRound2Error_InvalidProofOfKnowledgeCopyWith(DkgRound2Error_InvalidProofOfKnowledge value, $Res Function(DkgRound2Error_InvalidProofOfKnowledge) _then) = _$DkgRound2Error_InvalidProofOfKnowledgeCopyWithImpl;
@useResult
$Res call({
 IdentifierOpaque culprit
});




}
/// @nodoc
class _$DkgRound2Error_InvalidProofOfKnowledgeCopyWithImpl<$Res>
    implements $DkgRound2Error_InvalidProofOfKnowledgeCopyWith<$Res> {
  _$DkgRound2Error_InvalidProofOfKnowledgeCopyWithImpl(this._self, this._then);

  final DkgRound2Error_InvalidProofOfKnowledge _self;
  final $Res Function(DkgRound2Error_InvalidProofOfKnowledge) _then;

/// Create a copy of DkgRound2Error
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? culprit = null,}) {
  return _then(DkgRound2Error_InvalidProofOfKnowledge(
culprit: null == culprit ? _self.culprit : culprit // ignore: cast_nullable_to_non_nullable
as IdentifierOpaque,
  ));
}


}

/// @nodoc
mixin _$SignAggregationError {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignAggregationError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SignAggregationError()';
}


}

/// @nodoc
class $SignAggregationErrorCopyWith<$Res>  {
$SignAggregationErrorCopyWith(SignAggregationError _, $Res Function(SignAggregationError) __);
}


/// Adds pattern-matching-related methods to [SignAggregationError].
extension SignAggregationErrorPatterns on SignAggregationError {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignAggregationError_General value)?  general,TResult Function( SignAggregationError_InvalidSignShare value)?  invalidSignShare,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignAggregationError_General() when general != null:
return general(_that);case SignAggregationError_InvalidSignShare() when invalidSignShare != null:
return invalidSignShare(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignAggregationError_General value)  general,required TResult Function( SignAggregationError_InvalidSignShare value)  invalidSignShare,}){
final _that = this;
switch (_that) {
case SignAggregationError_General():
return general(_that);case SignAggregationError_InvalidSignShare():
return invalidSignShare(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignAggregationError_General value)?  general,TResult? Function( SignAggregationError_InvalidSignShare value)?  invalidSignShare,}){
final _that = this;
switch (_that) {
case SignAggregationError_General() when general != null:
return general(_that);case SignAggregationError_InvalidSignShare() when invalidSignShare != null:
return invalidSignShare(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  general,TResult Function( IdentifierOpaque culprit)?  invalidSignShare,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignAggregationError_General() when general != null:
return general(_that.message);case SignAggregationError_InvalidSignShare() when invalidSignShare != null:
return invalidSignShare(_that.culprit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  general,required TResult Function( IdentifierOpaque culprit)  invalidSignShare,}) {final _that = this;
switch (_that) {
case SignAggregationError_General():
return general(_that.message);case SignAggregationError_InvalidSignShare():
return invalidSignShare(_that.culprit);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  general,TResult? Function( IdentifierOpaque culprit)?  invalidSignShare,}) {final _that = this;
switch (_that) {
case SignAggregationError_General() when general != null:
return general(_that.message);case SignAggregationError_InvalidSignShare() when invalidSignShare != null:
return invalidSignShare(_that.culprit);case _:
  return null;

}
}

}

/// @nodoc


class SignAggregationError_General extends SignAggregationError {
  const SignAggregationError_General({required this.message}): super._();


 final  String message;

/// Create a copy of SignAggregationError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignAggregationError_GeneralCopyWith<SignAggregationError_General> get copyWith => _$SignAggregationError_GeneralCopyWithImpl<SignAggregationError_General>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignAggregationError_General&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SignAggregationError.general(message: $message)';
}


}

/// @nodoc
abstract mixin class $SignAggregationError_GeneralCopyWith<$Res> implements $SignAggregationErrorCopyWith<$Res> {
  factory $SignAggregationError_GeneralCopyWith(SignAggregationError_General value, $Res Function(SignAggregationError_General) _then) = _$SignAggregationError_GeneralCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SignAggregationError_GeneralCopyWithImpl<$Res>
    implements $SignAggregationError_GeneralCopyWith<$Res> {
  _$SignAggregationError_GeneralCopyWithImpl(this._self, this._then);

  final SignAggregationError_General _self;
  final $Res Function(SignAggregationError_General) _then;

/// Create a copy of SignAggregationError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SignAggregationError_General(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignAggregationError_InvalidSignShare extends SignAggregationError {
  const SignAggregationError_InvalidSignShare({required this.culprit}): super._();


 final  IdentifierOpaque culprit;

/// Create a copy of SignAggregationError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignAggregationError_InvalidSignShareCopyWith<SignAggregationError_InvalidSignShare> get copyWith => _$SignAggregationError_InvalidSignShareCopyWithImpl<SignAggregationError_InvalidSignShare>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignAggregationError_InvalidSignShare&&(identical(other.culprit, culprit) || other.culprit == culprit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,culprit);
}

@override
String toString() {
    return 'SignAggregationError.invalidSignShare(culprit: $culprit)';
}


}

/// @nodoc
abstract mixin class $SignAggregationError_InvalidSignShareCopyWith<$Res> implements $SignAggregationErrorCopyWith<$Res> {
  factory $SignAggregationError_InvalidSignShareCopyWith(SignAggregationError_InvalidSignShare value, $Res Function(SignAggregationError_InvalidSignShare) _then) = _$SignAggregationError_InvalidSignShareCopyWithImpl;
@useResult
$Res call({
 IdentifierOpaque culprit
});




}
/// @nodoc
class _$SignAggregationError_InvalidSignShareCopyWithImpl<$Res>
    implements $SignAggregationError_InvalidSignShareCopyWith<$Res> {
  _$SignAggregationError_InvalidSignShareCopyWithImpl(this._self, this._then);

  final SignAggregationError_InvalidSignShare _self;
  final $Res Function(SignAggregationError_InvalidSignShare) _then;

/// Create a copy of SignAggregationError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? culprit = null,}) {
  return _then(SignAggregationError_InvalidSignShare(
culprit: null == culprit ? _self.culprit : culprit // ignore: cast_nullable_to_non_nullable
as IdentifierOpaque,
  ));
}


}

// dart format on
