// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  String get id => throw _privateConstructorUsedError;
  String get vorname => throw _privateConstructorUsedError;
  String get nachname => throw _privateConstructorUsedError;
  DateTime get geburtstag => throw _privateConstructorUsedError;
  String? get titel => throw _privateConstructorUsedError;
  String? get strasse => throw _privateConstructorUsedError;
  String? get hausnummer => throw _privateConstructorUsedError;
  String? get plz => throw _privateConstructorUsedError;
  String? get stadt => throw _privateConstructorUsedError;
  String? get telMobil => throw _privateConstructorUsedError;
  String? get telFestnetz => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call(
      {String id,
      String vorname,
      String nachname,
      DateTime geburtstag,
      String? titel,
      String? strasse,
      String? hausnummer,
      String? plz,
      String? stadt,
      String? telMobil,
      String? telFestnetz,
      String? email});
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vorname = null,
    Object? nachname = null,
    Object? geburtstag = null,
    Object? titel = freezed,
    Object? strasse = freezed,
    Object? hausnummer = freezed,
    Object? plz = freezed,
    Object? stadt = freezed,
    Object? telMobil = freezed,
    Object? telFestnetz = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vorname: null == vorname
          ? _value.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _value.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _value.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _value.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
      strasse: freezed == strasse
          ? _value.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String?,
      hausnummer: freezed == hausnummer
          ? _value.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String?,
      plz: freezed == plz
          ? _value.plz
          : plz // ignore: cast_nullable_to_non_nullable
              as String?,
      stadt: freezed == stadt
          ? _value.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String?,
      telMobil: freezed == telMobil
          ? _value.telMobil
          : telMobil // ignore: cast_nullable_to_non_nullable
              as String?,
      telFestnetz: freezed == telFestnetz
          ? _value.telFestnetz
          : telFestnetz // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
          _$PatientImpl value, $Res Function(_$PatientImpl) then) =
      __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vorname,
      String nachname,
      DateTime geburtstag,
      String? titel,
      String? strasse,
      String? hausnummer,
      String? plz,
      String? stadt,
      String? telMobil,
      String? telFestnetz,
      String? email});
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
      _$PatientImpl _value, $Res Function(_$PatientImpl) _then)
      : super(_value, _then);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vorname = null,
    Object? nachname = null,
    Object? geburtstag = null,
    Object? titel = freezed,
    Object? strasse = freezed,
    Object? hausnummer = freezed,
    Object? plz = freezed,
    Object? stadt = freezed,
    Object? telMobil = freezed,
    Object? telFestnetz = freezed,
    Object? email = freezed,
  }) {
    return _then(_$PatientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vorname: null == vorname
          ? _value.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _value.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _value.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _value.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
      strasse: freezed == strasse
          ? _value.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String?,
      hausnummer: freezed == hausnummer
          ? _value.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String?,
      plz: freezed == plz
          ? _value.plz
          : plz // ignore: cast_nullable_to_non_nullable
              as String?,
      stadt: freezed == stadt
          ? _value.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String?,
      telMobil: freezed == telMobil
          ? _value.telMobil
          : telMobil // ignore: cast_nullable_to_non_nullable
              as String?,
      telFestnetz: freezed == telFestnetz
          ? _value.telFestnetz
          : telFestnetz // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl extends _Patient {
  const _$PatientImpl(
      {required this.id,
      required this.vorname,
      required this.nachname,
      required this.geburtstag,
      this.titel,
      this.strasse,
      this.hausnummer,
      this.plz,
      this.stadt,
      this.telMobil,
      this.telFestnetz,
      this.email})
      : super._();

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  @override
  final String id;
  @override
  final String vorname;
  @override
  final String nachname;
  @override
  final DateTime geburtstag;
  @override
  final String? titel;
  @override
  final String? strasse;
  @override
  final String? hausnummer;
  @override
  final String? plz;
  @override
  final String? stadt;
  @override
  final String? telMobil;
  @override
  final String? telFestnetz;
  @override
  final String? email;

  @override
  String toString() {
    return 'Patient(id: $id, vorname: $vorname, nachname: $nachname, geburtstag: $geburtstag, titel: $titel, strasse: $strasse, hausnummer: $hausnummer, plz: $plz, stadt: $stadt, telMobil: $telMobil, telFestnetz: $telFestnetz, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vorname, vorname) || other.vorname == vorname) &&
            (identical(other.nachname, nachname) ||
                other.nachname == nachname) &&
            (identical(other.geburtstag, geburtstag) ||
                other.geburtstag == geburtstag) &&
            (identical(other.titel, titel) || other.titel == titel) &&
            (identical(other.strasse, strasse) || other.strasse == strasse) &&
            (identical(other.hausnummer, hausnummer) ||
                other.hausnummer == hausnummer) &&
            (identical(other.plz, plz) || other.plz == plz) &&
            (identical(other.stadt, stadt) || other.stadt == stadt) &&
            (identical(other.telMobil, telMobil) ||
                other.telMobil == telMobil) &&
            (identical(other.telFestnetz, telFestnetz) ||
                other.telFestnetz == telFestnetz) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vorname,
      nachname,
      geburtstag,
      titel,
      strasse,
      hausnummer,
      plz,
      stadt,
      telMobil,
      telFestnetz,
      email);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(
      this,
    );
  }
}

abstract class _Patient extends Patient {
  const factory _Patient(
      {required final String id,
      required final String vorname,
      required final String nachname,
      required final DateTime geburtstag,
      final String? titel,
      final String? strasse,
      final String? hausnummer,
      final String? plz,
      final String? stadt,
      final String? telMobil,
      final String? telFestnetz,
      final String? email}) = _$PatientImpl;
  const _Patient._() : super._();

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  @override
  String get id;
  @override
  String get vorname;
  @override
  String get nachname;
  @override
  DateTime get geburtstag;
  @override
  String? get titel;
  @override
  String? get strasse;
  @override
  String? get hausnummer;
  @override
  String? get plz;
  @override
  String? get stadt;
  @override
  String? get telMobil;
  @override
  String? get telFestnetz;
  @override
  String? get email;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
