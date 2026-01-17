import 'package:first_start/database/db_helper.dart';
import 'package:first_start/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final data = await DbHelper.instance.getFavoriteProducts();
    products = data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: EdgeInsets.all(16),
        childAspectRatio: 0.625,
        children: products
            .map(
              (product) => TextButton(
                onPressed: () {},
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    CupertinoIcons.cube,
                                    size: 48,
                                    color: Color(0xFF99A1AF),
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(product.name, style: TextStyle(fontSize: 14)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          await DbHelper.instance.removeProductFromFavorite(
                            product.id,
                          );
                          products.remove(product);
                          setState(() {});
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
    );
  }
}
