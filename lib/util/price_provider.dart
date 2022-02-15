import 'package:flutter/material.dart';

class PriceProvider extends ChangeNotifier {
  int _total = 0;
  int _advance = 0;

  int get total => _total;
  int get advance => _advance;

  set total(int total) {
    _total = total;
    notifyListeners();
  }

  set advance(int advance) {
    _advance = advance;
    notifyListeners();
  }
}
