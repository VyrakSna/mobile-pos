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
    initData();
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

  // _showLoading() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => SizedBox(
  //       width: 300,
  //       height: 300,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Dialog(
  //           constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               CircularProgressIndicator(),
  //               SizedBox(height: 10, width: 10),
  //               Text(
  //                 'Please Wait.....',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w300,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        child: Container(
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
              placeholder: 'Search products or  scan barcode...',
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
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ), // reduced
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
                      const SizedBox(height: 8),
                      const Text(
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
                    physics: const NeverScrollableScrollPhysics(),
                    children: ProductRepository.cartItems
                        .map(
                          (item) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ProductRepository.removeProductFromCart(
                                          item.id,
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(CupertinoIcons.delete),
                                      color: Colors.redAccent,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Unit price
                                Text(
                                  "\$${item.product.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Bottom row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: const Icon(Icons.remove),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            item.qty.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\$${item.totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
