// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept_einlesen_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RezeptEinlesenResponse {
  EingelesenerPatient get patient;
  EingelesenesRezept get rezept;
  String get path;
  Patient? get existingPatient;

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptEinlesenResponseCopyWith<RezeptEinlesenResponse> get copyWith =>
      _$RezeptEinlesenResponseCopyWithImpl<RezeptEinlesenResponse>(
          this as RezeptEinlesenResponse, _$identity);

  /// Serializes this RezeptEinlesenResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptEinlesenResponse &&
            (identical(other.patient, patient) || other.patient == patient) &&
            (identical(other.rezept, rezept) || other.rezept == rezept) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.existingPatient, existingPatient) ||
                other.existingPatient == existingPatient));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, patient, rezept, path, existingPatient);

  @override
  String toString() {
    return 'RezeptEinlesenResponse(patient: $patient, rezept: $rezept, path: $path, existingPatient: $existingPatient)';
  }
}

/// @nodoc
abstract mixin class $RezeptEinlesenResponseCopyWith<$Res> {
  factory $RezeptEinlesenResponseCopyWith(RezeptEinlesenResponse value,
          $Res Function(RezeptEinlesenResponse) _then) =
      _$RezeptEinlesenResponseCopyWithImpl;
  @useResult
  $Res call(
      {EingelesenerPatient patient,
      EingelesenesRezept rezept,
      String path,
      Patient? existingPatient});

  $EingelesenerPatientCopyWith<$Res> get patient;
  $EingelesenesRezeptCopyWith<$Res> get rezept;
  $PatientCopyWith<$Res>? get existingPatient;
}

/// @nodoc
class _$RezeptEinlesenResponseCopyWithImpl<$Res>
    implements $RezeptEinlesenResponseCopyWith<$Res> {
  _$RezeptEinlesenResponseCopyWithImpl(this._self, this._then);

  final RezeptEinlesenResponse _self;
  final $Res Function(RezeptEinlesenResponse) _then;

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patient = null,
    Object? rezept = null,
    Object? path = null,
    Object? existingPatient = freezed,
  }) {
    return _then(_self.copyWith(
      patient: null == patient
          ? _self.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as EingelesenerPatient,
      rezept: null == rezept
          ? _self.rezept
          : rezept // ignore: cast_nullable_to_non_nullable
              as EingelesenesRezept,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      existingPatient: freezed == existingPatient
          ? _self.existingPatient
          : existingPatient // ignore: cast_nullable_to_non_nullable
              as Patient?,
    ));
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EingelesenerPatientCopyWith<$Res> get patient {
    return $EingelesenerPatientCopyWith<$Res>(_self.patient, (value) {
      return _then(_self.copyWith(patient: value));
    });
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EingelesenesRezeptCopyWith<$Res> get rezept {
    return $EingelesenesRezeptCopyWith<$Res>(_self.rezept, (value) {
      return _then(_self.copyWith(rezept: value));
    });
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientCopyWith<$Res>? get existingPatient {
    if (_self.existingPatient == null) {
      return null;
    }

    return $PatientCopyWith<$Res>(_self.existingPatient!, (value) {
      return _then(_self.copyWith(existingPatient: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _RezeptEinlesenResponse extends RezeptEinlesenResponse {
  const _RezeptEinlesenResponse(
      {required this.patient,
      required this.rezept,
      required this.path,
      this.existingPatient})
      : super._();
  factory _RezeptEinlesenResponse.fromJson(Map<String, dynamic> json) =>
      _$RezeptEinlesenResponseFromJson(json);

  @override
  final EingelesenerPatient patient;
  @override
  final EingelesenesRezept rezept;
  @override
  final String path;
  @override
  final Patient? existingPatient;

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptEinlesenResponseCopyWith<_RezeptEinlesenResponse> get copyWith =>
      __$RezeptEinlesenResponseCopyWithImpl<_RezeptEinlesenResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RezeptEinlesenResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptEinlesenResponse &&
            (identical(other.patient, patient) || other.patient == patient) &&
            (identical(other.rezept, rezept) || other.rezept == rezept) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.existingPatient, existingPatient) ||
                other.existingPatient == existingPatient));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, patient, rezept, path, existingPatient);

  @override
  String toString() {
    return 'RezeptEinlesenResponse(patient: $patient, rezept: $rezept, path: $path, existingPatient: $existingPatient)';
  }
}

/// @nodoc
abstract mixin class _$RezeptEinlesenResponseCopyWith<$Res>
    implements $RezeptEinlesenResponseCopyWith<$Res> {
  factory _$RezeptEinlesenResponseCopyWith(_RezeptEinlesenResponse value,
          $Res Function(_RezeptEinlesenResponse) _then) =
      __$RezeptEinlesenResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {EingelesenerPatient patient,
      EingelesenesRezept rezept,
      String path,
      Patient? existingPatient});

  @override
  $EingelesenerPatientCopyWith<$Res> get patient;
  @override
  $EingelesenesRezeptCopyWith<$Res> get rezept;
  @override
  $PatientCopyWith<$Res>? get existingPatient;
}

/// @nodoc
class __$RezeptEinlesenResponseCopyWithImpl<$Res>
    implements _$RezeptEinlesenResponseCopyWith<$Res> {
  __$RezeptEinlesenResponseCopyWithImpl(this._self, this._then);

  final _RezeptEinlesenResponse _self;
  final $Res Function(_RezeptEinlesenResponse) _then;

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? patient = null,
    Object? rezept = null,
    Object? path = null,
    Object? existingPatient = freezed,
  }) {
    return _then(_RezeptEinlesenResponse(
      patient: null == patient
          ? _self.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as EingelesenerPatient,
      rezept: null == rezept
          ? _self.rezept
          : rezept // ignore: cast_nullable_to_non_nullable
              as EingelesenesRezept,
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      existingPatient: freezed == existingPatient
          ? _self.existingPatient
          : existingPatient // ignore: cast_nullable_to_non_nullable
              as Patient?,
    ));
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EingelesenerPatientCopyWith<$Res> get patient {
    return $EingelesenerPatientCopyWith<$Res>(_self.patient, (value) {
      return _then(_self.copyWith(patient: value));
    });
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EingelesenesRezeptCopyWith<$Res> get rezept {
    return $EingelesenesRezeptCopyWith<$Res>(_self.rezept, (value) {
      return _then(_self.copyWith(rezept: value));
    });
  }

  /// Create a copy of RezeptEinlesenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PatientCopyWith<$Res>? get existingPatient {
    if (_self.existingPatient == null) {
      return null;
    }

    return $PatientCopyWith<$Res>(_self.existingPatient!, (value) {
      return _then(_self.copyWith(existingPatient: value));
    });
  }
}

/// @nodoc
mixin _$EingelesenerPatient {
  String get vorname;
  String get nachname;
  String get strasse;
  String get hausnummer;
  String get postleitzahl;
  String get stadt;
  DateTime get geburtstag;
  String? get titel;

  /// Create a copy of EingelesenerPatient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EingelesenerPatientCopyWith<EingelesenerPatient> get copyWith =>
      _$EingelesenerPatientCopyWithImpl<EingelesenerPatient>(
          this as EingelesenerPatient, _$identity);

  /// Serializes this EingelesenerPatient to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EingelesenerPatient &&
            (identical(other.vorname, vorname) || other.vorname == vorname) &&
            (identical(other.nachname, nachname) ||
                other.nachname == nachname) &&
            (identical(other.strasse, strasse) || other.strasse == strasse) &&
            (identical(other.hausnummer, hausnummer) ||
                other.hausnummer == hausnummer) &&
            (identical(other.postleitzahl, postleitzahl) ||
                other.postleitzahl == postleitzahl) &&
            (identical(other.stadt, stadt) || other.stadt == stadt) &&
            (identical(other.geburtstag, geburtstag) ||
                other.geburtstag == geburtstag) &&
            (identical(other.titel, titel) || other.titel == titel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vorname, nachname, strasse,
      hausnummer, postleitzahl, stadt, geburtstag, titel);

  @override
  String toString() {
    return 'EingelesenerPatient(vorname: $vorname, nachname: $nachname, strasse: $strasse, hausnummer: $hausnummer, postleitzahl: $postleitzahl, stadt: $stadt, geburtstag: $geburtstag, titel: $titel)';
  }
}

/// @nodoc
abstract mixin class $EingelesenerPatientCopyWith<$Res> {
  factory $EingelesenerPatientCopyWith(
          EingelesenerPatient value, $Res Function(EingelesenerPatient) _then) =
      _$EingelesenerPatientCopyWithImpl;
  @useResult
  $Res call(
      {String vorname,
      String nachname,
      String strasse,
      String hausnummer,
      String postleitzahl,
      String stadt,
      DateTime geburtstag,
      String? titel});
}

/// @nodoc
class _$EingelesenerPatientCopyWithImpl<$Res>
    implements $EingelesenerPatientCopyWith<$Res> {
  _$EingelesenerPatientCopyWithImpl(this._self, this._then);

  final EingelesenerPatient _self;
  final $Res Function(EingelesenerPatient) _then;

  /// Create a copy of EingelesenerPatient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vorname = null,
    Object? nachname = null,
    Object? strasse = null,
    Object? hausnummer = null,
    Object? postleitzahl = null,
    Object? stadt = null,
    Object? geburtstag = null,
    Object? titel = freezed,
  }) {
    return _then(_self.copyWith(
      vorname: null == vorname
          ? _self.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _self.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      strasse: null == strasse
          ? _self.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String,
      hausnummer: null == hausnummer
          ? _self.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String,
      postleitzahl: null == postleitzahl
          ? _self.postleitzahl
          : postleitzahl // ignore: cast_nullable_to_non_nullable
              as String,
      stadt: null == stadt
          ? _self.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _self.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _self.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EingelesenerPatient extends EingelesenerPatient {
  const _EingelesenerPatient(
      {required this.vorname,
      required this.nachname,
      required this.strasse,
      required this.hausnummer,
      required this.postleitzahl,
      required this.stadt,
      required this.geburtstag,
      this.titel})
      : super._();
  factory _EingelesenerPatient.fromJson(Map<String, dynamic> json) =>
      _$EingelesenerPatientFromJson(json);

  @override
  final String vorname;
  @override
  final String nachname;
  @override
  final String strasse;
  @override
  final String hausnummer;
  @override
  final String postleitzahl;
  @override
  final String stadt;
  @override
  final DateTime geburtstag;
  @override
  final String? titel;

  /// Create a copy of EingelesenerPatient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EingelesenerPatientCopyWith<_EingelesenerPatient> get copyWith =>
      __$EingelesenerPatientCopyWithImpl<_EingelesenerPatient>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EingelesenerPatientToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EingelesenerPatient &&
            (identical(other.vorname, vorname) || other.vorname == vorname) &&
            (identical(other.nachname, nachname) ||
                other.nachname == nachname) &&
            (identical(other.strasse, strasse) || other.strasse == strasse) &&
            (identical(other.hausnummer, hausnummer) ||
                other.hausnummer == hausnummer) &&
            (identical(other.postleitzahl, postleitzahl) ||
                other.postleitzahl == postleitzahl) &&
            (identical(other.stadt, stadt) || other.stadt == stadt) &&
            (identical(other.geburtstag, geburtstag) ||
                other.geburtstag == geburtstag) &&
            (identical(other.titel, titel) || other.titel == titel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vorname, nachname, strasse,
      hausnummer, postleitzahl, stadt, geburtstag, titel);

  @override
  String toString() {
    return 'EingelesenerPatient(vorname: $vorname, nachname: $nachname, strasse: $strasse, hausnummer: $hausnummer, postleitzahl: $postleitzahl, stadt: $stadt, geburtstag: $geburtstag, titel: $titel)';
  }
}

/// @nodoc
abstract mixin class _$EingelesenerPatientCopyWith<$Res>
    implements $EingelesenerPatientCopyWith<$Res> {
  factory _$EingelesenerPatientCopyWith(_EingelesenerPatient value,
          $Res Function(_EingelesenerPatient) _then) =
      __$EingelesenerPatientCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String vorname,
      String nachname,
      String strasse,
      String hausnummer,
      String postleitzahl,
      String stadt,
      DateTime geburtstag,
      String? titel});
}

/// @nodoc
class __$EingelesenerPatientCopyWithImpl<$Res>
    implements _$EingelesenerPatientCopyWith<$Res> {
  __$EingelesenerPatientCopyWithImpl(this._self, this._then);

  final _EingelesenerPatient _self;
  final $Res Function(_EingelesenerPatient) _then;

  /// Create a copy of EingelesenerPatient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? vorname = null,
    Object? nachname = null,
    Object? strasse = null,
    Object? hausnummer = null,
    Object? postleitzahl = null,
    Object? stadt = null,
    Object? geburtstag = null,
    Object? titel = freezed,
  }) {
    return _then(_EingelesenerPatient(
      vorname: null == vorname
          ? _self.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _self.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      strasse: null == strasse
          ? _self.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String,
      hausnummer: null == hausnummer
          ? _self.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String,
      postleitzahl: null == postleitzahl
          ? _self.postleitzahl
          : postleitzahl // ignore: cast_nullable_to_non_nullable
              as String,
      stadt: null == stadt
          ? _self.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _self.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _self.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$EingelesenesRezept {
  DateTime get ausgestelltAm;
  List<EingelesenesRezeptPos> get rezeptpositionen;

  /// Create a copy of EingelesenesRezept
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EingelesenesRezeptCopyWith<EingelesenesRezept> get copyWith =>
      _$EingelesenesRezeptCopyWithImpl<EingelesenesRezept>(
          this as EingelesenesRezept, _$identity);

  /// Serializes this EingelesenesRezept to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EingelesenesRezept &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            const DeepCollectionEquality()
                .equals(other.rezeptpositionen, rezeptpositionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ausgestelltAm,
      const DeepCollectionEquality().hash(rezeptpositionen));

  @override
  String toString() {
    return 'EingelesenesRezept(ausgestelltAm: $ausgestelltAm, rezeptpositionen: $rezeptpositionen)';
  }
}

/// @nodoc
abstract mixin class $EingelesenesRezeptCopyWith<$Res> {
  factory $EingelesenesRezeptCopyWith(
          EingelesenesRezept value, $Res Function(EingelesenesRezept) _then) =
      _$EingelesenesRezeptCopyWithImpl;
  @useResult
  $Res call(
      {DateTime ausgestelltAm, List<EingelesenesRezeptPos> rezeptpositionen});
}

/// @nodoc
class _$EingelesenesRezeptCopyWithImpl<$Res>
    implements $EingelesenesRezeptCopyWith<$Res> {
  _$EingelesenesRezeptCopyWithImpl(this._self, this._then);

  final EingelesenesRezept _self;
  final $Res Function(EingelesenesRezept) _then;

  /// Create a copy of EingelesenesRezept
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ausgestelltAm = null,
    Object? rezeptpositionen = null,
  }) {
    return _then(_self.copyWith(
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptpositionen: null == rezeptpositionen
          ? _self.rezeptpositionen
          : rezeptpositionen // ignore: cast_nullable_to_non_nullable
              as List<EingelesenesRezeptPos>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EingelesenesRezept extends EingelesenesRezept {
  const _EingelesenesRezept(
      {required this.ausgestelltAm,
      required final List<EingelesenesRezeptPos> rezeptpositionen})
      : _rezeptpositionen = rezeptpositionen,
        super._();
  factory _EingelesenesRezept.fromJson(Map<String, dynamic> json) =>
      _$EingelesenesRezeptFromJson(json);

  @override
  final DateTime ausgestelltAm;
  final List<EingelesenesRezeptPos> _rezeptpositionen;
  @override
  List<EingelesenesRezeptPos> get rezeptpositionen {
    if (_rezeptpositionen is EqualUnmodifiableListView)
      return _rezeptpositionen;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rezeptpositionen);
  }

  /// Create a copy of EingelesenesRezept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EingelesenesRezeptCopyWith<_EingelesenesRezept> get copyWith =>
      __$EingelesenesRezeptCopyWithImpl<_EingelesenesRezept>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EingelesenesRezeptToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EingelesenesRezept &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            const DeepCollectionEquality()
                .equals(other._rezeptpositionen, _rezeptpositionen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ausgestelltAm,
      const DeepCollectionEquality().hash(_rezeptpositionen));

  @override
  String toString() {
    return 'EingelesenesRezept(ausgestelltAm: $ausgestelltAm, rezeptpositionen: $rezeptpositionen)';
  }
}

/// @nodoc
abstract mixin class _$EingelesenesRezeptCopyWith<$Res>
    implements $EingelesenesRezeptCopyWith<$Res> {
  factory _$EingelesenesRezeptCopyWith(
          _EingelesenesRezept value, $Res Function(_EingelesenesRezept) _then) =
      __$EingelesenesRezeptCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime ausgestelltAm, List<EingelesenesRezeptPos> rezeptpositionen});
}

/// @nodoc
class __$EingelesenesRezeptCopyWithImpl<$Res>
    implements _$EingelesenesRezeptCopyWith<$Res> {
  __$EingelesenesRezeptCopyWithImpl(this._self, this._then);

  final _EingelesenesRezept _self;
  final $Res Function(_EingelesenesRezept) _then;

  /// Create a copy of EingelesenesRezept
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ausgestelltAm = null,
    Object? rezeptpositionen = null,
  }) {
    return _then(_EingelesenesRezept(
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rezeptpositionen: null == rezeptpositionen
          ? _self._rezeptpositionen
          : rezeptpositionen // ignore: cast_nullable_to_non_nullable
              as List<EingelesenesRezeptPos>,
    ));
  }
}

/// @nodoc
mixin _$EingelesenesRezeptPos {
  int get anzahl;
  Behandlungsart get behandlungsart;

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EingelesenesRezeptPosCopyWith<EingelesenesRezeptPos> get copyWith =>
      _$EingelesenesRezeptPosCopyWithImpl<EingelesenesRezeptPos>(
          this as EingelesenesRezeptPos, _$identity);

  /// Serializes this EingelesenesRezeptPos to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EingelesenesRezeptPos &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'EingelesenesRezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class $EingelesenesRezeptPosCopyWith<$Res> {
  factory $EingelesenesRezeptPosCopyWith(EingelesenesRezeptPos value,
          $Res Function(EingelesenesRezeptPos) _then) =
      _$EingelesenesRezeptPosCopyWithImpl;
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class _$EingelesenesRezeptPosCopyWithImpl<$Res>
    implements $EingelesenesRezeptPosCopyWith<$Res> {
  _$EingelesenesRezeptPosCopyWithImpl(this._self, this._then);

  final EingelesenesRezeptPos _self;
  final $Res Function(EingelesenesRezeptPos) _then;

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_self.copyWith(
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _self.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ));
  }

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<$Res> get behandlungsart {
    return $BehandlungsartCopyWith<$Res>(_self.behandlungsart, (value) {
      return _then(_self.copyWith(behandlungsart: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _EingelesenesRezeptPos extends EingelesenesRezeptPos {
  const _EingelesenesRezeptPos(
      {required this.anzahl, required this.behandlungsart})
      : super._();
  factory _EingelesenesRezeptPos.fromJson(Map<String, dynamic> json) =>
      _$EingelesenesRezeptPosFromJson(json);

  @override
  final int anzahl;
  @override
  final Behandlungsart behandlungsart;

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EingelesenesRezeptPosCopyWith<_EingelesenesRezeptPos> get copyWith =>
      __$EingelesenesRezeptPosCopyWithImpl<_EingelesenesRezeptPos>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EingelesenesRezeptPosToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EingelesenesRezeptPos &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'EingelesenesRezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class _$EingelesenesRezeptPosCopyWith<$Res>
    implements $EingelesenesRezeptPosCopyWith<$Res> {
  factory _$EingelesenesRezeptPosCopyWith(_EingelesenesRezeptPos value,
          $Res Function(_EingelesenesRezeptPos) _then) =
      __$EingelesenesRezeptPosCopyWithImpl;
  @override
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  @override
  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class __$EingelesenesRezeptPosCopyWithImpl<$Res>
    implements _$EingelesenesRezeptPosCopyWith<$Res> {
  __$EingelesenesRezeptPosCopyWithImpl(this._self, this._then);

  final _EingelesenesRezeptPos _self;
  final $Res Function(_EingelesenesRezeptPos) _then;

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_EingelesenesRezeptPos(
      anzahl: null == anzahl
          ? _self.anzahl
          : anzahl // ignore: cast_nullable_to_non_nullable
              as int,
      behandlungsart: null == behandlungsart
          ? _self.behandlungsart
          : behandlungsart // ignore: cast_nullable_to_non_nullable
              as Behandlungsart,
    ));
  }

  /// Create a copy of EingelesenesRezeptPos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BehandlungsartCopyWith<$Res> get behandlungsart {
    return $BehandlungsartCopyWith<$Res>(_self.behandlungsart, (value) {
      return _then(_self.copyWith(behandlungsart: value));
    });
  }
}

// dart format on
