import 'package:first_start/models/cart_item.dart';
import 'package:first_start/models/product.dart';
import 'package:first_start/models/transaction.dart';

class ProductRepository {
  static List<Product> products = [
    Product(
      id: 1,
      name: 'Premium Coffe Beans',
      title: '',
      category: 'Beverage',
      price: 12.99,
      stock: 50,
      image:
          'https://images.unsplash.com/photo-1447933601403-0c6688de566e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y29mZmVlfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 2,
      name: 'Fresh Sourdough Bread',
      title: '',
      category: 'Bakery',
      price: 4.99,
      stock: 30,
      image:
          'https://images.unsplash.com/photo-1564529726702-e1cb05b106b3?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fEZyZXNoJTIwU291cmRvdWdoJTIwQnJlYWR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 3,
      name: 'Artisan Chocolate Bar',
      title: '',
      category: 'Snacks',
      price: 5.99,
      stock: 75,
      image:
          'https://plus.unsplash.com/premium_photo-1671059792129-8fb1cff208f1?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fEFydGlzYW4lMjBDaG9jb2xhdGUlMjBCYXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
    ),
    Product(
      id: 4,
      name: 'A Blue Lagoon Cocktail',
      title: '',
      category: 'Beverages',
      price: 8.99,
      stock: 40,
      image:
          'https://frobishers.com/cdn/shop/articles/Screenshot_2024-08-16_at_12.55.17.png?v=1724236070',
    ),
  ];

  static List<CartItem> cartItems = [];
  static List<Transaction> allTransactions = [];
  static List<Transaction> recentTransactions = [];
  static int totalQty = 0;
  static void addToCart(Product product) {
    if (cartItems.isEmpty) {
      final CartItem item = CartItem(id: 1, product: product);
      item.qty = 1;
      cartItems.add(item);
    } else {
      int existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (existingItemIndex != -1) {
        CartItem item = cartItems[existingItemIndex];
        item.qty += 1;
        cartItems[existingItemIndex] = item;
      } else {
        int id = 1;
        if (cartItems.isNotEmpty) {
          id = cartItems.last.id + 1;
        }
        CartItem item = CartItem(id: id, product: product);
        item.qty = 1;
        cartItems.add(item);
      }
    }
    getTotalQty();
  }

  static void increaseQty() {}
  static void decreaseQty() {}
  static void clearCart() {
    cartItems.clear();
    getTotalQty();
  }

  static int getTotalQty() {
    int qty = 0;
    for (var element in cartItems) {
      qty += element.qty;
    }
    return qty;
  }

  static void removeProductFromCart(int id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    cartItems.removeAt(index);
  }

  static double getTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  static void checkout() {
    int trxId = 1;
    if (allTransactions.isNotEmpty) {
      trxId = allTransactions.last.id + 1;
    }
    Transaction trx = Transaction(
      id: trxId,
      code: 'TRX=$trxId',
      totalPrice: getTotalPrice(),
      items: cartItems,
      orderDate: DateTime.now(),
    );
    allTransactions.add(trx);
    getRecentTransactions();
    clearCart();
  }

  static void getRecentTransactions([int limit = 5]) {
    recentTransactions = allTransactions.reversed.take(5).toList();
  }
}
