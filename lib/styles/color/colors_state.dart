import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'colors_state.freezed.dart';

@freezed
class ColorsState with _$ColorsState {
  factory ColorsState({
    @Default(Colors.white) Color primary,
    @Default(Colors.black) Color fontDarkPrimary,
    @Default(Colors.black54) Color blackShade54,
    @Default(Color(0xFF4AC85D)) Color common,
    @Default(Color(0xFF4B4A4A)) Color darkFont,
    @Default(Color(0xFF767676)) Color labelFont,
    @Default(Color(0xFF949191)) Color navigationIcon,
    @Default(Color(0xFFADADAD)) Color lightFont,
    @Default(Color(0xFFF8F8F8)) Color background,
    @Default(Color(0xFFFFFFFF)) Color navigationBackground,
  }) = _Default;
}
