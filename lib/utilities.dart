import 'package:flutter/services.dart';

// TODO Fix the bug with the difference in the input with "," and "."
final filteringTextInputOnlyNumbersWithDecimalPoint =
    FilteringTextInputFormatter.allow(RegExp(r'^\d+(\s*((\.|\,)\d{0,1}))?'));
