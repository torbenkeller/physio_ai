// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../upload_rezept_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadRezeptState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadRezeptState()';
}


}

/// @nodoc
class $UploadRezeptStateCopyWith<$Res>  {
$UploadRezeptStateCopyWith(UploadRezeptState _, $Res Function(UploadRezeptState) __);
}


/// @nodoc


class UploadRezeptStateInitial implements UploadRezeptState {
  const UploadRezeptStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadRezeptState.initial()';
}


}




/// @nodoc


class UploadRezeptStateLoading implements UploadRezeptState {
  const UploadRezeptStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadRezeptState.loading()';
}


}




/// @nodoc


class UploadRezeptStateImageSelected implements UploadRezeptState {
  const UploadRezeptStateImageSelected({required this.selectedImage});
  

 final  File selectedImage;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRezeptStateImageSelectedCopyWith<UploadRezeptStateImageSelected> get copyWith => _$UploadRezeptStateImageSelectedCopyWithImpl<UploadRezeptStateImageSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStateImageSelected&&(identical(other.selectedImage, selectedImage) || other.selectedImage == selectedImage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedImage);

@override
String toString() {
  return 'UploadRezeptState.imageSelected(selectedImage: $selectedImage)';
}


}

/// @nodoc
abstract mixin class $UploadRezeptStateImageSelectedCopyWith<$Res> implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStateImageSelectedCopyWith(UploadRezeptStateImageSelected value, $Res Function(UploadRezeptStateImageSelected) _then) = _$UploadRezeptStateImageSelectedCopyWithImpl;
@useResult
$Res call({
 File selectedImage
});




}
/// @nodoc
class _$UploadRezeptStateImageSelectedCopyWithImpl<$Res>
    implements $UploadRezeptStateImageSelectedCopyWith<$Res> {
  _$UploadRezeptStateImageSelectedCopyWithImpl(this._self, this._then);

  final UploadRezeptStateImageSelected _self;
  final $Res Function(UploadRezeptStateImageSelected) _then;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedImage = null,}) {
  return _then(UploadRezeptStateImageSelected(
selectedImage: null == selectedImage ? _self.selectedImage : selectedImage // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class UploadRezeptStateRezeptEingelesen implements UploadRezeptState {
  const UploadRezeptStateRezeptEingelesen({required this.selectedImage, required this.response});
  

 final  File selectedImage;
 final  RezeptEinlesenResponse response;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRezeptStateRezeptEingelesenCopyWith<UploadRezeptStateRezeptEingelesen> get copyWith => _$UploadRezeptStateRezeptEingelesenCopyWithImpl<UploadRezeptStateRezeptEingelesen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStateRezeptEingelesen&&(identical(other.selectedImage, selectedImage) || other.selectedImage == selectedImage)&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,selectedImage,response);

@override
String toString() {
  return 'UploadRezeptState.rezeptEingelesen(selectedImage: $selectedImage, response: $response)';
}


}

/// @nodoc
abstract mixin class $UploadRezeptStateRezeptEingelesenCopyWith<$Res> implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStateRezeptEingelesenCopyWith(UploadRezeptStateRezeptEingelesen value, $Res Function(UploadRezeptStateRezeptEingelesen) _then) = _$UploadRezeptStateRezeptEingelesenCopyWithImpl;
@useResult
$Res call({
 File selectedImage, RezeptEinlesenResponse response
});


$RezeptEinlesenResponseCopyWith<$Res> get response;

}
/// @nodoc
class _$UploadRezeptStateRezeptEingelesenCopyWithImpl<$Res>
    implements $UploadRezeptStateRezeptEingelesenCopyWith<$Res> {
  _$UploadRezeptStateRezeptEingelesenCopyWithImpl(this._self, this._then);

  final UploadRezeptStateRezeptEingelesen _self;
  final $Res Function(UploadRezeptStateRezeptEingelesen) _then;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedImage = null,Object? response = null,}) {
  return _then(UploadRezeptStateRezeptEingelesen(
selectedImage: null == selectedImage ? _self.selectedImage : selectedImage // ignore: cast_nullable_to_non_nullable
as File,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RezeptEinlesenResponse,
  ));
}

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RezeptEinlesenResponseCopyWith<$Res> get response {
  
  return $RezeptEinlesenResponseCopyWith<$Res>(_self.response, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}

/// @nodoc


class UploadRezeptStatePatientSelected implements UploadRezeptState {
  const UploadRezeptStatePatientSelected({required this.selectedImage, required this.response, required this.selectedPatient});
  

 final  File selectedImage;
 final  RezeptEinlesenResponse response;
 final  Patient selectedPatient;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRezeptStatePatientSelectedCopyWith<UploadRezeptStatePatientSelected> get copyWith => _$UploadRezeptStatePatientSelectedCopyWithImpl<UploadRezeptStatePatientSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStatePatientSelected&&(identical(other.selectedImage, selectedImage) || other.selectedImage == selectedImage)&&(identical(other.response, response) || other.response == response)&&(identical(other.selectedPatient, selectedPatient) || other.selectedPatient == selectedPatient));
}


@override
int get hashCode => Object.hash(runtimeType,selectedImage,response,selectedPatient);

@override
String toString() {
  return 'UploadRezeptState.patientSelected(selectedImage: $selectedImage, response: $response, selectedPatient: $selectedPatient)';
}


}

/// @nodoc
abstract mixin class $UploadRezeptStatePatientSelectedCopyWith<$Res> implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStatePatientSelectedCopyWith(UploadRezeptStatePatientSelected value, $Res Function(UploadRezeptStatePatientSelected) _then) = _$UploadRezeptStatePatientSelectedCopyWithImpl;
@useResult
$Res call({
 File selectedImage, RezeptEinlesenResponse response, Patient selectedPatient
});


$RezeptEinlesenResponseCopyWith<$Res> get response;$PatientCopyWith<$Res> get selectedPatient;

}
/// @nodoc
class _$UploadRezeptStatePatientSelectedCopyWithImpl<$Res>
    implements $UploadRezeptStatePatientSelectedCopyWith<$Res> {
  _$UploadRezeptStatePatientSelectedCopyWithImpl(this._self, this._then);

  final UploadRezeptStatePatientSelected _self;
  final $Res Function(UploadRezeptStatePatientSelected) _then;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedImage = null,Object? response = null,Object? selectedPatient = null,}) {
  return _then(UploadRezeptStatePatientSelected(
selectedImage: null == selectedImage ? _self.selectedImage : selectedImage // ignore: cast_nullable_to_non_nullable
as File,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RezeptEinlesenResponse,selectedPatient: null == selectedPatient ? _self.selectedPatient : selectedPatient // ignore: cast_nullable_to_non_nullable
as Patient,
  ));
}

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RezeptEinlesenResponseCopyWith<$Res> get response {
  
  return $RezeptEinlesenResponseCopyWith<$Res>(_self.response, (value) {
    return _then(_self.copyWith(response: value));
  });
}/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientCopyWith<$Res> get selectedPatient {
  
  return $PatientCopyWith<$Res>(_self.selectedPatient, (value) {
    return _then(_self.copyWith(selectedPatient: value));
  });
}
}

/// @nodoc


class UploadRezeptStateError implements UploadRezeptState {
  const UploadRezeptStateError({required this.message});
  

 final  String message;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRezeptStateErrorCopyWith<UploadRezeptStateError> get copyWith => _$UploadRezeptStateErrorCopyWithImpl<UploadRezeptStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRezeptStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UploadRezeptState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UploadRezeptStateErrorCopyWith<$Res> implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStateErrorCopyWith(UploadRezeptStateError value, $Res Function(UploadRezeptStateError) _then) = _$UploadRezeptStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UploadRezeptStateErrorCopyWithImpl<$Res>
    implements $UploadRezeptStateErrorCopyWith<$Res> {
  _$UploadRezeptStateErrorCopyWithImpl(this._self, this._then);

  final UploadRezeptStateError _self;
  final $Res Function(UploadRezeptStateError) _then;

/// Create a copy of UploadRezeptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UploadRezeptStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
