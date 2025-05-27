// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../behandlung.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Behandlung {
  String get id;
  String get patientId;
  DateTime get startZeit;
  DateTime get endZeit;
  String? get rezeptId;

  /// Create a copy of Behandlung
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BehandlungCopyWith<Behandlung> get copyWith =>
      _$BehandlungCopyWithImpl<Behandlung>(this as Behandlung, _$identity);

  /// Serializes this Behandlung to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Behandlung &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, patientId, startZeit, endZeit, rezeptId);

  @override
  String toString() {
    return 'Behandlung(id: $id, patientId: $patientId, startZeit: $startZeit, endZeit: $endZeit, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class $BehandlungCopyWith<$Res> {
  factory $BehandlungCopyWith(
          Behandlung value, $Res Function(Behandlung) _then) =
      _$BehandlungCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String patientId,
      DateTime startZeit,
      DateTime endZeit,
      String? rezeptId});
}

/// @nodoc
class _$BehandlungCopyWithImpl<$Res> implements $BehandlungCopyWith<$Res> {
  _$BehandlungCopyWithImpl(this._self, this._then);

  final Behandlung _self;
  final $Res Function(Behandlung) _then;

  /// Create a copy of Behandlung
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Behandlung implements Behandlung {
  const _Behandlung(
      {required this.id,
      required this.patientId,
      required this.startZeit,
      required this.endZeit,
      this.rezeptId});
  factory _Behandlung.fromJson(Map<String, dynamic> json) =>
      _$BehandlungFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final DateTime startZeit;
  @override
  final DateTime endZeit;
  @override
  final String? rezeptId;

  /// Create a copy of Behandlung
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BehandlungCopyWith<_Behandlung> get copyWith =>
      __$BehandlungCopyWithImpl<_Behandlung>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BehandlungToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Behandlung &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, patientId, startZeit, endZeit, rezeptId);

  @override
  String toString() {
    return 'Behandlung(id: $id, patientId: $patientId, startZeit: $startZeit, endZeit: $endZeit, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class _$BehandlungCopyWith<$Res>
    implements $BehandlungCopyWith<$Res> {
  factory _$BehandlungCopyWith(
          _Behandlung value, $Res Function(_Behandlung) _then) =
      __$BehandlungCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String patientId,
      DateTime startZeit,
      DateTime endZeit,
      String? rezeptId});
}

/// @nodoc
class __$BehandlungCopyWithImpl<$Res> implements _$BehandlungCopyWith<$Res> {
  __$BehandlungCopyWithImpl(this._self, this._then);

  final _Behandlung _self;
  final $Res Function(_Behandlung) _then;

  /// Create a copy of Behandlung
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_Behandlung(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _self.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$BehandlungKalender {
  String get id;
  DateTime get startZeit;
  DateTime get endZeit;
  PatientSummary get patient;
  String? get rezeptId;

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BehandlungKalenderCopyWith<BehandlungKalender> get copyWith =>
      _$BehandlungKalenderCopyWithImpl<BehandlungKalender>(
          this as BehandlungKalender, _$identity);

  /// Serializes this BehandlungKalender to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BehandlungKalender &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.patient, patient) || other.patient == patient) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startZeit, endZeit, patient, rezeptId);

  @override
  String toString() {
    return 'BehandlungKalender(id: $id, startZeit: $startZeit, endZeit: $endZeit, patient: $patient, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class $BehandlungKalenderCopyWith<$Res> {
  factory $BehandlungKalenderCopyWith(
          BehandlungKalender value, $Res Function(BehandlungKalender) _then) =
      _$BehandlungKalenderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      DateTime startZeit,
      DateTime endZeit,
      PatientSummary patient,
      String? rezeptId});

  $PatientSummaryCopyWith<$Res> get patient;
}

/// @nodoc
class _$BehandlungKalenderCopyWithImpl<$Res>
    implements $BehandlungKalenderCopyWith<$Res> {
  _$BehandlungKalenderCopyWithImpl(this._self, this._then);

  final BehandlungKalender _self;
  final $Res Function(BehandlungKalender) _then;

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? patient = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      patient: null == patient
          ? _self.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as PatientSummary,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientSummaryCopyWith<$Res> get patient {
    return $PatientSummaryCopyWith<$Res>(_self.patient, (value) {
      return _then(_self.copyWith(patient: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _BehandlungKalender implements BehandlungKalender {
  const _BehandlungKalender(
      {required this.id,
      required this.startZeit,
      required this.endZeit,
      required this.patient,
      this.rezeptId});
  factory _BehandlungKalender.fromJson(Map<String, dynamic> json) =>
      _$BehandlungKalenderFromJson(json);

  @override
  final String id;
  @override
  final DateTime startZeit;
  @override
  final DateTime endZeit;
  @override
  final PatientSummary patient;
  @override
  final String? rezeptId;

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BehandlungKalenderCopyWith<_BehandlungKalender> get copyWith =>
      __$BehandlungKalenderCopyWithImpl<_BehandlungKalender>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BehandlungKalenderToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BehandlungKalender &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startZeit, startZeit) ||
                other.startZeit == startZeit) &&
            (identical(other.endZeit, endZeit) || other.endZeit == endZeit) &&
            (identical(other.patient, patient) || other.patient == patient) &&
            (identical(other.rezeptId, rezeptId) ||
                other.rezeptId == rezeptId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startZeit, endZeit, patient, rezeptId);

  @override
  String toString() {
    return 'BehandlungKalender(id: $id, startZeit: $startZeit, endZeit: $endZeit, patient: $patient, rezeptId: $rezeptId)';
  }
}

/// @nodoc
abstract mixin class _$BehandlungKalenderCopyWith<$Res>
    implements $BehandlungKalenderCopyWith<$Res> {
  factory _$BehandlungKalenderCopyWith(
          _BehandlungKalender value, $Res Function(_BehandlungKalender) _then) =
      __$BehandlungKalenderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime startZeit,
      DateTime endZeit,
      PatientSummary patient,
      String? rezeptId});

  @override
  $PatientSummaryCopyWith<$Res> get patient;
}

/// @nodoc
class __$BehandlungKalenderCopyWithImpl<$Res>
    implements _$BehandlungKalenderCopyWith<$Res> {
  __$BehandlungKalenderCopyWithImpl(this._self, this._then);

  final _BehandlungKalender _self;
  final $Res Function(_BehandlungKalender) _then;

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? startZeit = null,
    Object? endZeit = null,
    Object? patient = null,
    Object? rezeptId = freezed,
  }) {
    return _then(_BehandlungKalender(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startZeit: null == startZeit
          ? _self.startZeit
          : startZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endZeit: null == endZeit
          ? _self.endZeit
          : endZeit // ignore: cast_nullable_to_non_nullable
              as DateTime,
      patient: null == patient
          ? _self.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as PatientSummary,
      rezeptId: freezed == rezeptId
          ? _self.rezeptId
          : rezeptId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BehandlungKalender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientSummaryCopyWith<$Res> get patient {
    return $PatientSummaryCopyWith<$Res>(_self.patient, (value) {
      return _then(_self.copyWith(patient: value));
    });
  }
}

/// @nodoc
mixin _$PatientSummary {
  String get id;
  String get name;
  DateTime? get birthday;

  /// Create a copy of PatientSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PatientSummaryCopyWith<PatientSummary> get copyWith =>
      _$PatientSummaryCopyWithImpl<PatientSummary>(
          this as PatientSummary, _$identity);

  /// Serializes this PatientSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PatientSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, birthday);

  @override
  String toString() {
    return 'PatientSummary(id: $id, name: $name, birthday: $birthday)';
  }
}

/// @nodoc
abstract mixin class $PatientSummaryCopyWith<$Res> {
  factory $PatientSummaryCopyWith(
          PatientSummary value, $Res Function(PatientSummary) _then) =
      _$PatientSummaryCopyWithImpl;
  @useResult
  $Res call({String id, String name, DateTime? birthday});
}

/// @nodoc
class _$PatientSummaryCopyWithImpl<$Res>
    implements $PatientSummaryCopyWith<$Res> {
  _$PatientSummaryCopyWithImpl(this._self, this._then);

  final PatientSummary _self;
  final $Res Function(PatientSummary) _then;

  /// Create a copy of PatientSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthday = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _self.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PatientSummary implements PatientSummary {
  const _PatientSummary({required this.id, required this.name, this.birthday});
  factory _PatientSummary.fromJson(Map<String, dynamic> json) =>
      _$PatientSummaryFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime? birthday;

  /// Create a copy of PatientSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PatientSummaryCopyWith<_PatientSummary> get copyWith =>
      __$PatientSummaryCopyWithImpl<_PatientSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PatientSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PatientSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, birthday);

  @override
  String toString() {
    return 'PatientSummary(id: $id, name: $name, birthday: $birthday)';
  }
}

/// @nodoc
abstract mixin class _$PatientSummaryCopyWith<$Res>
    implements $PatientSummaryCopyWith<$Res> {
  factory _$PatientSummaryCopyWith(
          _PatientSummary value, $Res Function(_PatientSummary) _then) =
      __$PatientSummaryCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, DateTime? birthday});
}

/// @nodoc
class __$PatientSummaryCopyWithImpl<$Res>
    implements _$PatientSummaryCopyWith<$Res> {
  __$PatientSummaryCopyWithImpl(this._self, this._then);

  final _PatientSummary _self;
  final $Res Function(_PatientSummary) _then;

  /// Create a copy of PatientSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? birthday = freezed,
  }) {
    return _then(_PatientSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: freezed == birthday
          ? _self.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
