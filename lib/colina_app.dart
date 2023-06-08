import 'dart:js_util';

import 'package:c_delivery/Classes/adress_class.dart';
import 'package:c_delivery/Widget/add_product_widget.dart';
import 'package:c_delivery/Widget/app_menu_widget.dart';
import 'package:c_delivery/Widget/edit_menu_widget.dart';
import 'package:c_delivery/Widget/order_details_widget.dart';
import 'package:c_delivery/Classes/product_list_class.dart';
import 'package:c_delivery/Widget/product_widget.dart';
import 'package:c_delivery/theme_data.dart';
import 'package:c_delivery/Classes/user_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Classes/order_class.dart';
import 'Widget/edit_product_status_widget.dart';
import 'Widget/order_widget.dart';

class Colina extends StatefulWidget {
  final MyUser currentUser;

  const Colina({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<Colina> createState() => _ColinaState();
}

class _ColinaState extends State<Colina> {
  MyOrder currentOrder = MyOrder.late();
  int menuSelector = 0;
  List<MyOrder> orderList = [];
  bool showProducts = false;
  bool editingMode = false;
  bool addProduct = false;
  ProductList productList = newObject();

  Stream<List<Product>> streamProducts() {
    return FirebaseFirestore.instance
        .collection('meniuColina')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
              (doc) => Product(
                id: doc.id,
                name: doc['name'],
                price: doc['price'],
                active: doc['active'],
                qty: 1,
              ),
            )
            .toList());
  }

  Stream<List<MyOrder>> streamOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => MyOrder(
                  id: doc.id,
                  orderAddress: Address.fromMap(doc['Address:']),
                  startDate: doc['Date & Time'].toDate(),
                  user: MyUser.fromMap(doc['User Details:']),
                  deliveryFee: doc['Delivery Fee'],
                  subtotal: doc['Subtotal'],
                  total: doc['Total'],
                  status: doc['Status'],
                  productList: ProductList.fromMapList(doc['Products:']),
                ))
            .toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate)));
  }

  void productAdded(ProductList list) {
    setState(() {
      currentOrder.productList = list;
    });
  }

  void updateOrderList(List<MyOrder> newList) {
    setState(() {
      orderList = newList;
    });
  }

  void updateCurrentOrder(MyOrder selectedOrder) {
    currentOrder = selectedOrder;
  }

  void updateMenuOption(int menuOption) {
    setState(() {
      menuSelector = menuOption;
    });
  }
  void updateAddProduct(bool value){
    setState(() {
      addProduct=value;
    });
  }
  void updateShowProducts(bool value) {
    if (value == false) {
      setState(() {
        showProducts = value;
        editingMode = false;
      });
    } else {
      setState(() {
        showProducts = value;
        editingMode = true;
      });
    }
  }

  void updateEdittingMode(bool value) {
    setState(() {
      editingMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      title: 'Colina Unitbv',
      home: Scaffold(
        appBar: AppBar(
          //AppBar
          title: Text(
            'Cantina Colina',
            style: TextStyle(color: MyTheme.textColor(context)),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout_sharp))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  //bine ai venit
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Bine ai venit, ${widget.currentUser.firstName}!',
                    style: TextStyle(
                      color: MyTheme.textColor(context),
                      fontSize: 20,
                    ),
                  ),
                ), //bine ai venit
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          //Menu
                          flex: 2,
                          child: AppMenu(
                            updateMenuSelector: updateMenuOption,
                            showProducts: updateShowProducts,
                            edittingMode: updateEdittingMode,
                          )), //Menu
                      const SizedBox(
                        width: 10,
                      ),
                      if (menuSelector == 1) ...[
                        Expanded(
                          //Lista de comenzi in asteptare
                          flex: 2,
                          child: Container(
                            decoration: MyTheme.customDecoration(context),
                            height: MediaQuery.of(context).size.height - 200,
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Comenzi in asteptare: ${orderList.length}',
                                    style: TextStyle(
                                      color: MyTheme.textColor(context),
                                      fontSize: 20,
                                    ),
                                  ),
                                  StreamBuilder<List<MyOrder>>(
                                    stream: streamOrders(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        orderList = snapshot.data!;
                                        return Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: ListView.builder(
                                            itemCount: orderList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final order = orderList[index];
                                              if (order.status ==
                                                  'In procesare') {
                                                return GestureDetector(
                                                  child: OrderWidget(
                                                    order: order,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      currentOrder = order;
                                                    });
                                                  },
                                                );
                                              }
                                              return null;
                                            },
                                          ),
                                        );
                                      } else if (snapshot.hasData == false) {
                                        return Text(
                                          'Nu sunt comenzi in asteptare!',
                                          style: TextStyle(
                                            color: MyTheme.textColor(context),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ), //Lista de comenzi in asteptare
                        const SizedBox(
                          width: 10,
                        ),
                        if (currentOrder.id == '') ...[
                          Expanded(flex: 7, child: Container())
                        ] else ...[
                          Expanded(
                            //Detalii comanda
                            flex: 3,
                            child: Container(
                              decoration: MyTheme.customDecoration(context),
                              height: MediaQuery.of(context).size.height - 200,
                              child: OrderDetails(
                                currentOrder: currentOrder,
                                orderList: orderList,
                                updateOrderList: updateOrderList,
                                showProducts: updateShowProducts,
                                editingMode: editingMode,
                              ),
                            ),
                          ), //Detalii comanda
                          const SizedBox(
                            width: 10,
                          ),
                          if (showProducts == true) ...[
                            Expanded(
                              //Add Product to Order Menu
                              flex: 3,
                              child: Container(
                                decoration: MyTheme.customDecoration(context),
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: StreamBuilder<List<Product>>(
                                  stream: streamProducts(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                        child: Text('A apărut o eroare.'),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final productSnapshot = snapshot.data!;

                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: ListView.builder(
                                        itemCount: productSnapshot.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final product =
                                              productSnapshot[index];
                                          return ProductWidget(
                                            currentProduct: product,
                                            productList:
                                                currentOrder.productList,
                                            productAdded: productAdded,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ), //Add Product to Order Menu
                          ] else ...[
                            Expanded(flex: 3, child: Container())
                          ],
                          const Expanded(flex: 2, child: SizedBox()),
                        ]
                      ] else if (menuSelector == 2) ...[
                        Expanded(
                            flex: 4,
                            child: Container(
                                decoration: MyTheme.customDecoration(context),
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: EditProductStatusWidget())),
                        Expanded(flex: 5, child: Container())
                      ] else if (menuSelector == 3)
                        ...[
                          Expanded(
                              flex: 4,
                              child: Container(
                                  decoration: MyTheme.customDecoration(context),
                                  height:
                                  MediaQuery.of(context).size.height - 200,
                                  child: EditMenuWidget(updateAddProduct: updateAddProduct,))),
                          if(addProduct==true)...[
                            const SizedBox(width: 10,),
                            Expanded(
                                flex: 4,
                                child: Container(
                                    decoration: MyTheme.customDecoration(context),
                                    height:
                                    MediaQuery.of(context).size.height - 200,
                                    child: AddProductWidget(updateAddProduct: updateAddProduct,))),
                          ]else...[
                            Expanded(flex: 5, child: Container())
                          ],
                          Expanded(flex: 1, child: Container())
                        ]else ...[
                        Expanded(flex: 9, child: Container())
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
