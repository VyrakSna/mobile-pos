import 'dart:convert';
import 'dart:io';

import 'package:first_start/api/domain/domain.dart';
import 'package:first_start/api/end_point/api_end_point.dart';
import 'package:first_start/database/db_helper.dart';
import 'package:first_start/models/product.dart';
import 'package:first_start/repositories/auth_repository.dart';
import 'package:first_start/repositories/product_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  bool isCardEmpty = false;

  final TextEditingController _searchcontroller = TextEditingController();
  List<Product> products = [];
  bool isLoading = true;

  int qty = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addToCart(Product product) {
    ProductRepository.addToCart(product);
    setState(() {});
  }

  void initData() async {
    final response = await http.get(
      Uri.parse(ApiDomain.domain + ApiEndPoint.products),
      headers: {
        "Authorization": "Bearer ${AuthRepository.token}",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      for (var element in data) {
        products.add(Product.fromJson(element));
      }
      ProductRepository.products = products;
    }
    isLoading = false;
    setState(() {});
  }

  _showLoading() {
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: 160,
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dialog(
            constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text(
                  'Please Wait.....',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCardEmpty = false;
    return Scaffold(
      appBar: AppBar(title: Text('New Sale'), centerTitle: false),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSearchTextField(
              placeholder: 'Serach products or  scan barcode...',
              padding: EdgeInsets.all(12),
              prefixInsets: EdgeInsets.only(left: 16),
              suffixIcon: Icon(Icons.center_focus_strong_outlined),
              suffixMode: OverlayVisibilityMode.always,
              placeholderStyle: TextStyle(
                fontSize: 16,
                color: Color(0xFF717182),
              ),
            ),
          ),
          isLoading
              ? Center(child: CupertinoActivityIndicator())
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: EdgeInsets.all(16),
                  childAspectRatio: 0.625,
                  children: ProductRepository.products
                      .map(
                        (product) => TextButton(
                          onPressed: () {
                            qty++;
                            addToCart(product);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                width: 0.65,
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minWidth: double.infinity,
                                        minHeight: 160,
                                        maxHeight: 160,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        product.image,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  CupertinoIcons.cube,
                                                  size: 48,
                                                  color: Color(0xFF99A1AF),
                                                ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    product.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6A7282),
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF00A63E),
                                        ),
                                      ),
                                      Text(
                                        'Stock: ${product.stock}',
                                        style: TextStyle(
                                          color: Color(0xFF6A7282),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () async {
                                    await DbHelper.instance
                                        .saveProductToFavorite(product);
                                  },
                                  icon: Icon(Icons.favorite_border),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.1),
                  width: 0.65,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.shopping_cart, color: Color(0xFF4A5565)),
                SizedBox(width: 8),
                Text(
                  'Cart (${ProductRepository.getTotalQty()})',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(64),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.65,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: ProductRepository.cartItems.isEmpty
                ? Column(
                    children: [
                      Lottie.asset('lotties/empty_cart.json'),
                      SizedBox(height: 8),
                      Text(
                        'Cart is empty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ProductRepository.cartItems
                        .map(
                          (item) => Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.product.name),
                                    IconButton(
                                      onPressed: () {
                                        ProductRepository.removeProductFromCart(
                                          item.id,
                                        );
                                        setState(() {});
                                      },
                                      icon: Icon(CupertinoIcons.delete),
                                    ),
                                  ],
                                ),
                                Text(item.product.price.toStringAsFixed(2)),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text(item.qty.toString()),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    Text(item.totalPrice.toStringAsFixed(2)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 18)),
                    Text(
                      '\$${ProductRepository.getTotalPrice().toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: Color(0xFF00A63E)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          ProductRepository.clearCart();
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 0.65,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: ProductRepository.cartItems.isEmpty ? 0.5 : 1,
                        child: TextButton(
                          onPressed: ProductRepository.cartItems.isEmpty
                              ? null
                              : () async {
                                  ProductRepository.checkout();
                                  _showLoading();
                                  await Future.delayed(
                                    Duration(seconds: 2),
                                    () {
                                      Navigator.pop(context);
                                    },
                                  );
                                  Navigator.pop(
                                    context,
                                    'Checkout Successfully',
                                  );
                                },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: Color(0xFF00A63E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
