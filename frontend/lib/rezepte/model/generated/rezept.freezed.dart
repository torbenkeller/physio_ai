// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rezept {

 String get id; RezeptPatient get patient; DateTime get ausgestelltAm; double get preisGesamt; IList<RezeptPos> get positionen; IList<Behandlung> get behandlungen;
/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RezeptCopyWith<Rezept> get copyWith => _$RezeptCopyWithImpl<Rezept>(this as Rezept, _$identity);

  /// Serializes this Rezept to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rezept&&(identical(other.id, id) || other.id == id)&&(identical(other.patient, patient) || other.patient == patient)&&(identical(other.ausgestelltAm, ausgestelltAm) || other.ausgestelltAm == ausgestelltAm)&&(identical(other.preisGesamt, preisGesamt) || other.preisGesamt == preisGesamt)&&const DeepCollectionEquality().equals(other.positionen, positionen)&&const DeepCollectionEquality().equals(other.behandlungen, behandlungen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patient,ausgestelltAm,preisGesamt,const DeepCollectionEquality().hash(positionen),const DeepCollectionEquality().hash(behandlungen));

@override
String toString() {
  return 'Rezept(id: $id, patient: $patient, ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen, behandlungen: $behandlungen)';
}


}

/// @nodoc
abstract mixin class $RezeptCopyWith<$Res>  {
  factory $RezeptCopyWith(Rezept value, $Res Function(Rezept) _then) = _$RezeptCopyWithImpl;
@useResult
$Res call({
 String id, RezeptPatient patient, DateTime ausgestelltAm, double preisGesamt, IList<RezeptPos> positionen, IList<Behandlung> behandlungen
});


$RezeptPatientCopyWith<$Res> get patient;

}
/// @nodoc
class _$RezeptCopyWithImpl<$Res>
    implements $RezeptCopyWith<$Res> {
  _$RezeptCopyWithImpl(this._self, this._then);

  final Rezept _self;
  final $Res Function(Rezept) _then;

/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patient = null,Object? ausgestelltAm = null,Object? preisGesamt = null,Object? positionen = null,Object? behandlungen = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patient: null == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as RezeptPatient,ausgestelltAm: null == ausgestelltAm ? _self.ausgestelltAm : ausgestelltAm // ignore: cast_nullable_to_non_nullable
as DateTime,preisGesamt: null == preisGesamt ? _self.preisGesamt : preisGesamt // ignore: cast_nullable_to_non_nullable
as double,positionen: null == positionen ? _self.positionen : positionen // ignore: cast_nullable_to_non_nullable
as IList<RezeptPos>,behandlungen: null == behandlungen ? _self.behandlungen : behandlungen // ignore: cast_nullable_to_non_nullable
as IList<Behandlung>,
  ));
}
/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RezeptPatientCopyWith<$Res> get patient {
  
  return $RezeptPatientCopyWith<$Res>(_self.patient, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Rezept extends Rezept {
  const _Rezept({required this.id, required this.patient, required this.ausgestelltAm, required this.preisGesamt, this.positionen = const IListConst([]), this.behandlungen = const IListConst([])}): super._();
  factory _Rezept.fromJson(Map<String, dynamic> json) => _$RezeptFromJson(json);

@override final  String id;
@override final  RezeptPatient patient;
@override final  DateTime ausgestelltAm;
@override final  double preisGesamt;
@override@JsonKey() final  IList<RezeptPos> positionen;
@override@JsonKey() final  IList<Behandlung> behandlungen;

/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RezeptCopyWith<_Rezept> get copyWith => __$RezeptCopyWithImpl<_Rezept>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RezeptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rezept&&(identical(other.id, id) || other.id == id)&&(identical(other.patient, patient) || other.patient == patient)&&(identical(other.ausgestelltAm, ausgestelltAm) || other.ausgestelltAm == ausgestelltAm)&&(identical(other.preisGesamt, preisGesamt) || other.preisGesamt == preisGesamt)&&const DeepCollectionEquality().equals(other.positionen, positionen)&&const DeepCollectionEquality().equals(other.behandlungen, behandlungen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patient,ausgestelltAm,preisGesamt,const DeepCollectionEquality().hash(positionen),const DeepCollectionEquality().hash(behandlungen));

@override
String toString() {
  return 'Rezept(id: $id, patient: $patient, ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen, behandlungen: $behandlungen)';
}


}

/// @nodoc
abstract mixin class _$RezeptCopyWith<$Res> implements $RezeptCopyWith<$Res> {
  factory _$RezeptCopyWith(_Rezept value, $Res Function(_Rezept) _then) = __$RezeptCopyWithImpl;
@override @useResult
$Res call({
 String id, RezeptPatient patient, DateTime ausgestelltAm, double preisGesamt, IList<RezeptPos> positionen, IList<Behandlung> behandlungen
});


@override $RezeptPatientCopyWith<$Res> get patient;

}
/// @nodoc
class __$RezeptCopyWithImpl<$Res>
    implements _$RezeptCopyWith<$Res> {
  __$RezeptCopyWithImpl(this._self, this._then);

  final _Rezept _self;
  final $Res Function(_Rezept) _then;

/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patient = null,Object? ausgestelltAm = null,Object? preisGesamt = null,Object? positionen = null,Object? behandlungen = null,}) {
  return _then(_Rezept(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patient: null == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as RezeptPatient,ausgestelltAm: null == ausgestelltAm ? _self.ausgestelltAm : ausgestelltAm // ignore: cast_nullable_to_non_nullable
as DateTime,preisGesamt: null == preisGesamt ? _self.preisGesamt : preisGesamt // ignore: cast_nullable_to_non_nullable
as double,positionen: null == positionen ? _self.positionen : positionen // ignore: cast_nullable_to_non_nullable
as IList<RezeptPos>,behandlungen: null == behandlungen ? _self.behandlungen : behandlungen // ignore: cast_nullable_to_non_nullable
as IList<Behandlung>,
  ));
}

/// Create a copy of Rezept
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RezeptPatientCopyWith<$Res> get patient {
  
  return $RezeptPatientCopyWith<$Res>(_self.patient, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}


/// @nodoc
mixin _$RezeptPos {

 int get anzahl; Behandlungsart get behandlungsart;
/// Create a copy of RezeptPos
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RezeptPosCopyWith<RezeptPos> get copyWith => _$RezeptPosCopyWithImpl<RezeptPos>(this as RezeptPos, _$identity);

  /// Serializes this RezeptPos to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RezeptPos&&(identical(other.anzahl, anzahl) || other.anzahl == anzahl)&&(identical(other.behandlungsart, behandlungsart) || other.behandlungsart == behandlungsart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anzahl,behandlungsart);

@override
String toString() {
  return 'RezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
}


}

/// @nodoc
abstract mixin class $RezeptPosCopyWith<$Res>  {
  factory $RezeptPosCopyWith(RezeptPos value, $Res Function(RezeptPos) _then) = _$RezeptPosCopyWithImpl;
@useResult
$Res call({
 int anzahl, Behandlungsart behandlungsart
});


$BehandlungsartCopyWith<$Res> get behandlungsart;

}
/// @nodoc
class _$RezeptPosCopyWithImpl<$Res>
    implements $RezeptPosCopyWith<$Res> {
  _$RezeptPosCopyWithImpl(this._self, this._then);

  final RezeptPos _self;
  final $Res Function(RezeptPos) _then;

/// Create a copy of RezeptPos
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anzahl = null,Object? behandlungsart = null,}) {
  return _then(_self.copyWith(
anzahl: null == anzahl ? _self.anzahl : anzahl // ignore: cast_nullable_to_non_nullable
as int,behandlungsart: null == behandlungsart ? _self.behandlungsart : behandlungsart // ignore: cast_nullable_to_non_nullable
as Behandlungsart,
  ));
}
/// Create a copy of RezeptPos
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

class _RezeptPos extends RezeptPos {
  const _RezeptPos({required this.anzahl, required this.behandlungsart}): super._();
  factory _RezeptPos.fromJson(Map<String, dynamic> json) => _$RezeptPosFromJson(json);

@override final  int anzahl;
@override final  Behandlungsart behandlungsart;

/// Create a copy of RezeptPos
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RezeptPosCopyWith<_RezeptPos> get copyWith => __$RezeptPosCopyWithImpl<_RezeptPos>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RezeptPosToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RezeptPos&&(identical(other.anzahl, anzahl) || other.anzahl == anzahl)&&(identical(other.behandlungsart, behandlungsart) || other.behandlungsart == behandlungsart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anzahl,behandlungsart);

@override
String toString() {
  return 'RezeptPos(anzahl: $anzahl, behandlungsart: $behandlungsart)';
}


}

/// @nodoc
abstract mixin class _$RezeptPosCopyWith<$Res> implements $RezeptPosCopyWith<$Res> {
  factory _$RezeptPosCopyWith(_RezeptPos value, $Res Function(_RezeptPos) _then) = __$RezeptPosCopyWithImpl;
@override @useResult
$Res call({
 int anzahl, Behandlungsart behandlungsart
});


@override $BehandlungsartCopyWith<$Res> get behandlungsart;

}
/// @nodoc
class __$RezeptPosCopyWithImpl<$Res>
    implements _$RezeptPosCopyWith<$Res> {
  __$RezeptPosCopyWithImpl(this._self, this._then);

  final _RezeptPos _self;
  final $Res Function(_RezeptPos) _then;

/// Create a copy of RezeptPos
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anzahl = null,Object? behandlungsart = null,}) {
  return _then(_RezeptPos(
anzahl: null == anzahl ? _self.anzahl : anzahl // ignore: cast_nullable_to_non_nullable
as int,behandlungsart: null == behandlungsart ? _self.behandlungsart : behandlungsart // ignore: cast_nullable_to_non_nullable
as Behandlungsart,
  ));
}

/// Create a copy of RezeptPos
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
mixin _$Behandlungsart {

 String get id; String get name; double get preis;
/// Create a copy of Behandlungsart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BehandlungsartCopyWith<Behandlungsart> get copyWith => _$BehandlungsartCopyWithImpl<Behandlungsart>(this as Behandlungsart, _$identity);

  /// Serializes this Behandlungsart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Behandlungsart&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preis, preis) || other.preis == preis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preis);

@override
String toString() {
  return 'Behandlungsart(id: $id, name: $name, preis: $preis)';
}


}

/// @nodoc
abstract mixin class $BehandlungsartCopyWith<$Res>  {
  factory $BehandlungsartCopyWith(Behandlungsart value, $Res Function(Behandlungsart) _then) = _$BehandlungsartCopyWithImpl;
@useResult
$Res call({
 String id, String name, double preis
});




}
/// @nodoc
class _$BehandlungsartCopyWithImpl<$Res>
    implements $BehandlungsartCopyWith<$Res> {
  _$BehandlungsartCopyWithImpl(this._self, this._then);

  final Behandlungsart _self;
  final $Res Function(Behandlungsart) _then;

/// Create a copy of Behandlungsart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? preis = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preis: null == preis ? _self.preis : preis // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Behandlungsart extends Behandlungsart {
  const _Behandlungsart({required this.id, required this.name, required this.preis}): super._();
  factory _Behandlungsart.fromJson(Map<String, dynamic> json) => _$BehandlungsartFromJson(json);

@override final  String id;
@override final  String name;
@override final  double preis;

/// Create a copy of Behandlungsart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BehandlungsartCopyWith<_Behandlungsart> get copyWith => __$BehandlungsartCopyWithImpl<_Behandlungsart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BehandlungsartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Behandlungsart&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preis, preis) || other.preis == preis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preis);

@override
String toString() {
  return 'Behandlungsart(id: $id, name: $name, preis: $preis)';
}


}

/// @nodoc
abstract mixin class _$BehandlungsartCopyWith<$Res> implements $BehandlungsartCopyWith<$Res> {
  factory _$BehandlungsartCopyWith(_Behandlungsart value, $Res Function(_Behandlungsart) _then) = __$BehandlungsartCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double preis
});




}
/// @nodoc
class __$BehandlungsartCopyWithImpl<$Res>
    implements _$BehandlungsartCopyWith<$Res> {
  __$BehandlungsartCopyWithImpl(this._self, this._then);

  final _Behandlungsart _self;
  final $Res Function(_Behandlungsart) _then;

/// Create a copy of Behandlungsart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? preis = null,}) {
  return _then(_Behandlungsart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preis: null == preis ? _self.preis : preis // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$RezeptPatient {

 String get id; String get vorname; String get nachname;
/// Create a copy of RezeptPatient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RezeptPatientCopyWith<RezeptPatient> get copyWith => _$RezeptPatientCopyWithImpl<RezeptPatient>(this as RezeptPatient, _$identity);

  /// Serializes this RezeptPatient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RezeptPatient&&(identical(other.id, id) || other.id == id)&&(identical(other.vorname, vorname) || other.vorname == vorname)&&(identical(other.nachname, nachname) || other.nachname == nachname));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vorname,nachname);

@override
String toString() {
  return 'RezeptPatient(id: $id, vorname: $vorname, nachname: $nachname)';
}


}

/// @nodoc
abstract mixin class $RezeptPatientCopyWith<$Res>  {
  factory $RezeptPatientCopyWith(RezeptPatient value, $Res Function(RezeptPatient) _then) = _$RezeptPatientCopyWithImpl;
@useResult
$Res call({
 String id, String vorname, String nachname
});




}
/// @nodoc
class _$RezeptPatientCopyWithImpl<$Res>
    implements $RezeptPatientCopyWith<$Res> {
  _$RezeptPatientCopyWithImpl(this._self, this._then);

  final RezeptPatient _self;
  final $Res Function(RezeptPatient) _then;

/// Create a copy of RezeptPatient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vorname = null,Object? nachname = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vorname: null == vorname ? _self.vorname : vorname // ignore: cast_nullable_to_non_nullable
as String,nachname: null == nachname ? _self.nachname : nachname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RezeptPatient extends RezeptPatient {
  const _RezeptPatient({required this.id, required this.vorname, required this.nachname}): super._();
  factory _RezeptPatient.fromJson(Map<String, dynamic> json) => _$RezeptPatientFromJson(json);

@override final  String id;
@override final  String vorname;
@override final  String nachname;

/// Create a copy of RezeptPatient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RezeptPatientCopyWith<_RezeptPatient> get copyWith => __$RezeptPatientCopyWithImpl<_RezeptPatient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RezeptPatientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RezeptPatient&&(identical(other.id, id) || other.id == id)&&(identical(other.vorname, vorname) || other.vorname == vorname)&&(identical(other.nachname, nachname) || other.nachname == nachname));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vorname,nachname);

@override
String toString() {
  return 'RezeptPatient(id: $id, vorname: $vorname, nachname: $nachname)';
}


}

/// @nodoc
abstract mixin class _$RezeptPatientCopyWith<$Res> implements $RezeptPatientCopyWith<$Res> {
  factory _$RezeptPatientCopyWith(_RezeptPatient value, $Res Function(_RezeptPatient) _then) = __$RezeptPatientCopyWithImpl;
@override @useResult
$Res call({
 String id, String vorname, String nachname
});




}
/// @nodoc
class __$RezeptPatientCopyWithImpl<$Res>
    implements _$RezeptPatientCopyWith<$Res> {
  __$RezeptPatientCopyWithImpl(this._self, this._then);

  final _RezeptPatient _self;
  final $Res Function(_RezeptPatient) _then;

/// Create a copy of RezeptPatient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vorname = null,Object? nachname = null,}) {
  return _then(_RezeptPatient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vorname: null == vorname ? _self.vorname : vorname // ignore: cast_nullable_to_non_nullable
as String,nachname: null == nachname ? _self.nachname : nachname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Behandlung {

 String get id; DateTime get startZeit; DateTime get endZeit;
/// Create a copy of Behandlung
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BehandlungCopyWith<Behandlung> get copyWith => _$BehandlungCopyWithImpl<Behandlung>(this as Behandlung, _$identity);

  /// Serializes this Behandlung to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Behandlung&&(identical(other.id, id) || other.id == id)&&(identical(other.startZeit, startZeit) || other.startZeit == startZeit)&&(identical(other.endZeit, endZeit) || other.endZeit == endZeit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startZeit,endZeit);

@override
String toString() {
  return 'Behandlung(id: $id, startZeit: $startZeit, endZeit: $endZeit)';
}


}

/// @nodoc
abstract mixin class $BehandlungCopyWith<$Res>  {
  factory $BehandlungCopyWith(Behandlung value, $Res Function(Behandlung) _then) = _$BehandlungCopyWithImpl;
@useResult
$Res call({
 String id, DateTime startZeit, DateTime endZeit
});




}
/// @nodoc
class _$BehandlungCopyWithImpl<$Res>
    implements $BehandlungCopyWith<$Res> {
  _$BehandlungCopyWithImpl(this._self, this._then);

  final Behandlung _self;
  final $Res Function(Behandlung) _then;

/// Create a copy of Behandlung
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startZeit = null,Object? endZeit = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startZeit: null == startZeit ? _self.startZeit : startZeit // ignore: cast_nullable_to_non_nullable
as DateTime,endZeit: null == endZeit ? _self.endZeit : endZeit // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Behandlung extends Behandlung {
  const _Behandlung({required this.id, required this.startZeit, required this.endZeit}): super._();
  factory _Behandlung.fromJson(Map<String, dynamic> json) => _$BehandlungFromJson(json);

@override final  String id;
@override final  DateTime startZeit;
@override final  DateTime endZeit;

/// Create a copy of Behandlung
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BehandlungCopyWith<_Behandlung> get copyWith => __$BehandlungCopyWithImpl<_Behandlung>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BehandlungToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Behandlung&&(identical(other.id, id) || other.id == id)&&(identical(other.startZeit, startZeit) || other.startZeit == startZeit)&&(identical(other.endZeit, endZeit) || other.endZeit == endZeit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startZeit,endZeit);

@override
String toString() {
  return 'Behandlung(id: $id, startZeit: $startZeit, endZeit: $endZeit)';
}


}

/// @nodoc
abstract mixin class _$BehandlungCopyWith<$Res> implements $BehandlungCopyWith<$Res> {
  factory _$BehandlungCopyWith(_Behandlung value, $Res Function(_Behandlung) _then) = __$BehandlungCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime startZeit, DateTime endZeit
});




}
/// @nodoc
class __$BehandlungCopyWithImpl<$Res>
    implements _$BehandlungCopyWith<$Res> {
  __$BehandlungCopyWithImpl(this._self, this._then);

  final _Behandlung _self;
  final $Res Function(_Behandlung) _then;

/// Create a copy of Behandlung
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startZeit = null,Object? endZeit = null,}) {
  return _then(_Behandlung(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startZeit: null == startZeit ? _self.startZeit : startZeit // ignore: cast_nullable_to_non_nullable
as DateTime,endZeit: null == endZeit ? _self.endZeit : endZeit // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
