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
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UploadRezeptState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UploadRezeptState()';
  }
}

/// @nodoc
class $UploadRezeptStateCopyWith<$Res> {
  $UploadRezeptStateCopyWith(
      UploadRezeptState _, $Res Function(UploadRezeptState) __);
}

/// @nodoc

class UploadRezeptStateInitial implements UploadRezeptState {
  const UploadRezeptStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UploadRezeptStateInitial);
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
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UploadRezeptStateLoading);
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
  const UploadRezeptStateImageSelected({required this.selectedFile});

  final File selectedFile;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadRezeptStateImageSelectedCopyWith<UploadRezeptStateImageSelected>
      get copyWith => _$UploadRezeptStateImageSelectedCopyWithImpl<
          UploadRezeptStateImageSelected>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadRezeptStateImageSelected &&
            (identical(other.selectedFile, selectedFile) ||
                other.selectedFile == selectedFile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedFile);

  @override
  String toString() {
    return 'UploadRezeptState.imageSelected(selectedFile: $selectedFile)';
  }
}

/// @nodoc
abstract mixin class $UploadRezeptStateImageSelectedCopyWith<$Res>
    implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStateImageSelectedCopyWith(
          UploadRezeptStateImageSelected value,
          $Res Function(UploadRezeptStateImageSelected) _then) =
      _$UploadRezeptStateImageSelectedCopyWithImpl;
  @useResult
  $Res call({File selectedFile});
}

/// @nodoc
class _$UploadRezeptStateImageSelectedCopyWithImpl<$Res>
    implements $UploadRezeptStateImageSelectedCopyWith<$Res> {
  _$UploadRezeptStateImageSelectedCopyWithImpl(this._self, this._then);

  final UploadRezeptStateImageSelected _self;
  final $Res Function(UploadRezeptStateImageSelected) _then;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedFile = null,
  }) {
    return _then(UploadRezeptStateImageSelected(
      selectedFile: null == selectedFile
          ? _self.selectedFile
          : selectedFile // ignore: cast_nullable_to_non_nullable
              as File,
    ));
  }
}

/// @nodoc

class UploadRezeptStatePatientSelection implements UploadRezeptState {
  const UploadRezeptStatePatientSelection({required this.response});

  final RezeptEinlesenResponse response;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadRezeptStatePatientSelectionCopyWith<UploadRezeptStatePatientSelection>
      get copyWith => _$UploadRezeptStatePatientSelectionCopyWithImpl<
          UploadRezeptStatePatientSelection>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadRezeptStatePatientSelection &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  @override
  String toString() {
    return 'UploadRezeptState.patientSelection(response: $response)';
  }
}

/// @nodoc
abstract mixin class $UploadRezeptStatePatientSelectionCopyWith<$Res>
    implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStatePatientSelectionCopyWith(
          UploadRezeptStatePatientSelection value,
          $Res Function(UploadRezeptStatePatientSelection) _then) =
      _$UploadRezeptStatePatientSelectionCopyWithImpl;
  @useResult
  $Res call({RezeptEinlesenResponse response});

  $RezeptEinlesenResponseCopyWith<$Res> get response;
}

/// @nodoc
class _$UploadRezeptStatePatientSelectionCopyWithImpl<$Res>
    implements $UploadRezeptStatePatientSelectionCopyWith<$Res> {
  _$UploadRezeptStatePatientSelectionCopyWithImpl(this._self, this._then);

  final UploadRezeptStatePatientSelection _self;
  final $Res Function(UploadRezeptStatePatientSelection) _then;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? response = null,
  }) {
    return _then(UploadRezeptStatePatientSelection(
      response: null == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
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

class UploadRezeptStateError implements UploadRezeptState {
  const UploadRezeptStateError({required this.message});

  final String message;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UploadRezeptStateErrorCopyWith<UploadRezeptStateError> get copyWith =>
      _$UploadRezeptStateErrorCopyWithImpl<UploadRezeptStateError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UploadRezeptStateError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'UploadRezeptState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $UploadRezeptStateErrorCopyWith<$Res>
    implements $UploadRezeptStateCopyWith<$Res> {
  factory $UploadRezeptStateErrorCopyWith(UploadRezeptStateError value,
          $Res Function(UploadRezeptStateError) _then) =
      _$UploadRezeptStateErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UploadRezeptStateErrorCopyWithImpl<$Res>
    implements $UploadRezeptStateErrorCopyWith<$Res> {
  _$UploadRezeptStateErrorCopyWithImpl(this._self, this._then);

  final UploadRezeptStateError _self;
  final $Res Function(UploadRezeptStateError) _then;

  /// Create a copy of UploadRezeptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(UploadRezeptStateError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
