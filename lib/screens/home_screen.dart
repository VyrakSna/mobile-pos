import 'package:first_start/repositories/product_repository.dart';
import 'package:first_start/screens/favorite_screen.dart';
import 'package:first_start/screens/history.dart';
import 'package:first_start/screens/new_sale_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 20),
                  Text("Favorite"),
                ],
              ),
            ),
          ],
        ),
      ),
      key: _drawerKey,
      appBar: AppBar(
        title: Text('POS System'),
        leading: IconButton(
          onPressed: () {
            //test
            _drawerKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //Total Sales
          _buildStatisicCard(
            colors: [Color(0xFF00C950), Color(0xFF00A63E)],
            title: 'Total Sales (Today)',
            value: '\$0.00',
            icon: Icons.attach_money_outlined,
          ),
          SizedBox(height: 16),
          //Total Orders
          _buildStatisicCard(
            colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
            title: 'Total Orders',
            value: '0',
            icon: Icons.shopping_bag_outlined,
          ),
          SizedBox(height: 16),
          //Top_Sell
          _buildStatisicCard(
            colors: [Color(0xFFF0B100), Color(0xFFD08700)],
            title: 'Top-Selling Item',
            value: 'No sale  yet',
            icon: Icons.show_chart,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 0.65,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Action', style: TextStyle(fontSize: 16)),
                SizedBox(height: 24),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  padding: EdgeInsets.zero,
                  children: [
                    //New Sale
                    TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewSaleScreen(),
                          ),
                        );
                        if (result != null) {
                          setState(() {});
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'New Sale',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    //Add product
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        // backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.65,
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.cube, color: Colors.black),
                          SizedBox(height: 8),
                          Text(
                            'Add Products',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    //history
                    TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => History()),
                        );
                        if (result != null) {
                          setState(() {});
                        }
                      },
                      style: TextButton.styleFrom(
                        // backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.65,
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: Colors.black),
                          SizedBox(height: 8),
                          Text(
                            'History',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    //Print Last
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        // backgroundColor: Color(0xFF00A63E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.65,
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.money_dollar_circle,
                            color: Colors.black,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Print Last',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                width: 0.65,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text('Recent Sales', style: TextStyle(fontSize: 16)),
            //     ),
            //     SizedBox(height: 60),
            //     ProductRepository.recentTransactions.isEmpty
            //         ? Center(
            //             child: Column(
            //               children: [
            //                 Lottie.asset('lotties/empty_transaction.json'),
            //                 Text(
            //                   'No transaction yet. Start a new sale!',
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     color: Color(0xFF6A7282),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           )
            //         : SizedBox(
            //             height: 200,
            //             child: ListView(
            //               shrinkWrap: true,
            //               // physics: NeverScrollableScrollPhysics(),
            //               children: ProductRepository.recentTransactions.map((
            //                 trx,
            //               ) {
            //                 return Container(
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(trx.code),
            //                           Text(trx.totalPrice.toStringAsFixed(2)),
            //                         ],
            //                       ),
            //                       Text(
            //                         DateFormat(
            //                           'yyyy-MM-dd hh:mm a',
            //                         ).format(trx.orderDate),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               }).toList(),
            //             ),
            //           ),
            //     SizedBox(height: 30),
            //   ],
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Sales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                ProductRepository.recentTransactions.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Lottie.asset(
                              'assets/lotties/empty_transaction.json',
                              height: 160,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No transaction yet. Start a new sale!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6A7282),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 220,
                        child: ListView(
                          shrinkWrap: true,
                          children: ProductRepository.recentTransactions.map((
                            trx,
                          ) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row: code + total
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trx.code,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "\$${trx.totalPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  // Date
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd hh:mm a',
                                    ).format(trx.orderDate),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container _buildStatisicCard({
  String? title,
  String? value,
  IconData? icon,
  required List<Color> colors,
}) {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(colors: colors),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Icon(icon, size: 20, color: Colors.white),
          ],
        ),
        SizedBox(height: 40),
        Text(value ?? '', style: TextStyle(color: Colors.white, fontSize: 30)),
      ],
    ),
  );
}
