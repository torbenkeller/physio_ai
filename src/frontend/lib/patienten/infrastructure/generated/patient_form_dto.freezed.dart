// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../patient_form_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientFormDto {
  String get vorname;
  String get nachname;
  DateTime get geburtstag;
  String? get titel;
  String? get strasse;
  String? get hausnummer;
  String? get plz;
  String? get stadt;
  String? get telMobil;
  String? get telFestnetz;
  String? get email;

  /// Create a copy of PatientFormDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PatientFormDtoCopyWith<PatientFormDto> get copyWith =>
      _$PatientFormDtoCopyWithImpl<PatientFormDto>(
          this as PatientFormDto, _$identity);

  /// Serializes this PatientFormDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PatientFormDto &&
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
  int get hashCode => Object.hash(runtimeType, vorname, nachname, geburtstag,
      titel, strasse, hausnummer, plz, stadt, telMobil, telFestnetz, email);

  @override
  String toString() {
    return 'PatientFormDto(vorname: $vorname, nachname: $nachname, geburtstag: $geburtstag, titel: $titel, strasse: $strasse, hausnummer: $hausnummer, plz: $plz, stadt: $stadt, telMobil: $telMobil, telFestnetz: $telFestnetz, email: $email)';
  }
}

/// @nodoc
abstract mixin class $PatientFormDtoCopyWith<$Res> {
  factory $PatientFormDtoCopyWith(
          PatientFormDto value, $Res Function(PatientFormDto) _then) =
      _$PatientFormDtoCopyWithImpl;
  @useResult
  $Res call(
      {String vorname,
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
class _$PatientFormDtoCopyWithImpl<$Res>
    implements $PatientFormDtoCopyWith<$Res> {
  _$PatientFormDtoCopyWithImpl(this._self, this._then);

  final PatientFormDto _self;
  final $Res Function(PatientFormDto) _then;

  /// Create a copy of PatientFormDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
    return _then(_self.copyWith(
      vorname: null == vorname
          ? _self.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _self.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _self.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _self.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
      strasse: freezed == strasse
          ? _self.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String?,
      hausnummer: freezed == hausnummer
          ? _self.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String?,
      plz: freezed == plz
          ? _self.plz
          : plz // ignore: cast_nullable_to_non_nullable
              as String?,
      stadt: freezed == stadt
          ? _self.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String?,
      telMobil: freezed == telMobil
          ? _self.telMobil
          : telMobil // ignore: cast_nullable_to_non_nullable
              as String?,
      telFestnetz: freezed == telFestnetz
          ? _self.telFestnetz
          : telFestnetz // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PatientFormDto extends PatientFormDto {
  const _PatientFormDto(
      {required this.vorname,
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
  factory _PatientFormDto.fromJson(Map<String, dynamic> json) =>
      _$PatientFormDtoFromJson(json);

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

  /// Create a copy of PatientFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PatientFormDtoCopyWith<_PatientFormDto> get copyWith =>
      __$PatientFormDtoCopyWithImpl<_PatientFormDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PatientFormDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PatientFormDto &&
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
  int get hashCode => Object.hash(runtimeType, vorname, nachname, geburtstag,
      titel, strasse, hausnummer, plz, stadt, telMobil, telFestnetz, email);

  @override
  String toString() {
    return 'PatientFormDto(vorname: $vorname, nachname: $nachname, geburtstag: $geburtstag, titel: $titel, strasse: $strasse, hausnummer: $hausnummer, plz: $plz, stadt: $stadt, telMobil: $telMobil, telFestnetz: $telFestnetz, email: $email)';
  }
}

/// @nodoc
abstract mixin class _$PatientFormDtoCopyWith<$Res>
    implements $PatientFormDtoCopyWith<$Res> {
  factory _$PatientFormDtoCopyWith(
          _PatientFormDto value, $Res Function(_PatientFormDto) _then) =
      __$PatientFormDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String vorname,
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
class __$PatientFormDtoCopyWithImpl<$Res>
    implements _$PatientFormDtoCopyWith<$Res> {
  __$PatientFormDtoCopyWithImpl(this._self, this._then);

  final _PatientFormDto _self;
  final $Res Function(_PatientFormDto) _then;

  /// Create a copy of PatientFormDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
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
    return _then(_PatientFormDto(
      vorname: null == vorname
          ? _self.vorname
          : vorname // ignore: cast_nullable_to_non_nullable
              as String,
      nachname: null == nachname
          ? _self.nachname
          : nachname // ignore: cast_nullable_to_non_nullable
              as String,
      geburtstag: null == geburtstag
          ? _self.geburtstag
          : geburtstag // ignore: cast_nullable_to_non_nullable
              as DateTime,
      titel: freezed == titel
          ? _self.titel
          : titel // ignore: cast_nullable_to_non_nullable
              as String?,
      strasse: freezed == strasse
          ? _self.strasse
          : strasse // ignore: cast_nullable_to_non_nullable
              as String?,
      hausnummer: freezed == hausnummer
          ? _self.hausnummer
          : hausnummer // ignore: cast_nullable_to_non_nullable
              as String?,
      plz: freezed == plz
          ? _self.plz
          : plz // ignore: cast_nullable_to_non_nullable
              as String?,
      stadt: freezed == stadt
          ? _self.stadt
          : stadt // ignore: cast_nullable_to_non_nullable
              as String?,
      telMobil: freezed == telMobil
          ? _self.telMobil
          : telMobil // ignore: cast_nullable_to_non_nullable
              as String?,
      telFestnetz: freezed == telFestnetz
          ? _self.telFestnetz
          : telFestnetz // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
