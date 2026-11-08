import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xFF2E7D6B);
const kSecondaryColor = Color(0xFF3A7CA5);
const kBackgroundColor = Color(0xFFF5F7FA);

final currencyFormat = NumberFormat.currency(
  locale: 'ar_SY',
  symbol: 'ل.س',
  decimalDigits: 0,
);

final dateFormat = DateFormat('yyyy/MM/dd HH:mm', 'ar');
