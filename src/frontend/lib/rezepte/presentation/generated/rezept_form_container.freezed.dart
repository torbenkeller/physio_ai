// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rezept_form_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RezeptFormState {
  DateTime get ausgestelltAm;
  double get preisGesamt;
  IList<RezeptPositionState> get positionen;

  /// Create a copy of RezeptFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptFormStateCopyWith<RezeptFormState> get copyWith =>
      _$RezeptFormStateCopyWithImpl<RezeptFormState>(
          this as RezeptFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptFormState &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            (identical(other.preisGesamt, preisGesamt) ||
                other.preisGesamt == preisGesamt) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ausgestelltAm, preisGesamt,
      const DeepCollectionEquality().hash(positionen));

  @override
  String toString() {
    return 'RezeptFormState(ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class $RezeptFormStateCopyWith<$Res> {
  factory $RezeptFormStateCopyWith(
          RezeptFormState value, $Res Function(RezeptFormState) _then) =
      _$RezeptFormStateCopyWithImpl;
  @useResult
  $Res call(
      {DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPositionState> positionen});
}

/// @nodoc
class _$RezeptFormStateCopyWithImpl<$Res>
    implements $RezeptFormStateCopyWith<$Res> {
  _$RezeptFormStateCopyWithImpl(this._self, this._then);

  final RezeptFormState _self;
  final $Res Function(RezeptFormState) _then;

  /// Create a copy of RezeptFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_self.copyWith(
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _self.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _self.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPositionState>,
    ));
  }
}

/// @nodoc

class _RezeptFormState extends RezeptFormState {
  const _RezeptFormState(
      {required this.ausgestelltAm,
      required this.preisGesamt,
      required this.positionen})
      : super._();

  @override
  final DateTime ausgestelltAm;
  @override
  final double preisGesamt;
  @override
  final IList<RezeptPositionState> positionen;

  /// Create a copy of RezeptFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptFormStateCopyWith<_RezeptFormState> get copyWith =>
      __$RezeptFormStateCopyWithImpl<_RezeptFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptFormState &&
            (identical(other.ausgestelltAm, ausgestelltAm) ||
                other.ausgestelltAm == ausgestelltAm) &&
            (identical(other.preisGesamt, preisGesamt) ||
                other.preisGesamt == preisGesamt) &&
            const DeepCollectionEquality()
                .equals(other.positionen, positionen));
  }

  @override
  int get hashCode => Object.hash(runtimeType, ausgestelltAm, preisGesamt,
      const DeepCollectionEquality().hash(positionen));

  @override
  String toString() {
    return 'RezeptFormState(ausgestelltAm: $ausgestelltAm, preisGesamt: $preisGesamt, positionen: $positionen)';
  }
}

/// @nodoc
abstract mixin class _$RezeptFormStateCopyWith<$Res>
    implements $RezeptFormStateCopyWith<$Res> {
  factory _$RezeptFormStateCopyWith(
          _RezeptFormState value, $Res Function(_RezeptFormState) _then) =
      __$RezeptFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime ausgestelltAm,
      double preisGesamt,
      IList<RezeptPositionState> positionen});
}

/// @nodoc
class __$RezeptFormStateCopyWithImpl<$Res>
    implements _$RezeptFormStateCopyWith<$Res> {
  __$RezeptFormStateCopyWithImpl(this._self, this._then);

  final _RezeptFormState _self;
  final $Res Function(_RezeptFormState) _then;

  /// Create a copy of RezeptFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ausgestelltAm = null,
    Object? preisGesamt = null,
    Object? positionen = null,
  }) {
    return _then(_RezeptFormState(
      ausgestelltAm: null == ausgestelltAm
          ? _self.ausgestelltAm
          : ausgestelltAm // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preisGesamt: null == preisGesamt
          ? _self.preisGesamt
          : preisGesamt // ignore: cast_nullable_to_non_nullable
              as double,
      positionen: null == positionen
          ? _self.positionen
          : positionen // ignore: cast_nullable_to_non_nullable
              as IList<RezeptPositionState>,
    ));
  }
}

/// @nodoc
mixin _$RezeptPositionState {
  int get anzahl;
  Behandlungsart get behandlungsart;

  /// Create a copy of RezeptPositionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RezeptPositionStateCopyWith<RezeptPositionState> get copyWith =>
      _$RezeptPositionStateCopyWithImpl<RezeptPositionState>(
          this as RezeptPositionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RezeptPositionState &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'RezeptPositionState(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class $RezeptPositionStateCopyWith<$Res> {
  factory $RezeptPositionStateCopyWith(
          RezeptPositionState value, $Res Function(RezeptPositionState) _then) =
      _$RezeptPositionStateCopyWithImpl;
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class _$RezeptPositionStateCopyWithImpl<$Res>
    implements $RezeptPositionStateCopyWith<$Res> {
  _$RezeptPositionStateCopyWithImpl(this._self, this._then);

  final RezeptPositionState _self;
  final $Res Function(RezeptPositionState) _then;

  /// Create a copy of RezeptPositionState
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

  /// Create a copy of RezeptPositionState
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

class _RezeptPositionState implements RezeptPositionState {
  const _RezeptPositionState(
      {required this.anzahl, required this.behandlungsart});

  @override
  final int anzahl;
  @override
  final Behandlungsart behandlungsart;

  /// Create a copy of RezeptPositionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RezeptPositionStateCopyWith<_RezeptPositionState> get copyWith =>
      __$RezeptPositionStateCopyWithImpl<_RezeptPositionState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RezeptPositionState &&
            (identical(other.anzahl, anzahl) || other.anzahl == anzahl) &&
            (identical(other.behandlungsart, behandlungsart) ||
                other.behandlungsart == behandlungsart));
  }

  @override
  int get hashCode => Object.hash(runtimeType, anzahl, behandlungsart);

  @override
  String toString() {
    return 'RezeptPositionState(anzahl: $anzahl, behandlungsart: $behandlungsart)';
  }
}

/// @nodoc
abstract mixin class _$RezeptPositionStateCopyWith<$Res>
    implements $RezeptPositionStateCopyWith<$Res> {
  factory _$RezeptPositionStateCopyWith(_RezeptPositionState value,
          $Res Function(_RezeptPositionState) _then) =
      __$RezeptPositionStateCopyWithImpl;
  @override
  @useResult
  $Res call({int anzahl, Behandlungsart behandlungsart});

  @override
  $BehandlungsartCopyWith<$Res> get behandlungsart;
}

/// @nodoc
class __$RezeptPositionStateCopyWithImpl<$Res>
    implements _$RezeptPositionStateCopyWith<$Res> {
  __$RezeptPositionStateCopyWithImpl(this._self, this._then);

  final _RezeptPositionState _self;
  final $Res Function(_RezeptPositionState) _then;

  /// Create a copy of RezeptPositionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? anzahl = null,
    Object? behandlungsart = null,
  }) {
    return _then(_RezeptPositionState(
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

  /// Create a copy of RezeptPositionState
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
