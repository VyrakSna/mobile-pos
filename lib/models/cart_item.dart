import 'package:first_start/models/product.dart';

class CartItem {
  final int id;
  final Product product;

  CartItem({required this.id, required this.product});

  int _qty = 0;
  double _totalPirce = 0.00;

  set qty(int value) => _qty = value;
  int get qty => _qty;

  double get totalPrice => _qty * product.price;
}
