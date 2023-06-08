import 'dart:js_util';
import 'package:c_delivery/Classes/product_list_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme_data.dart';

class EditProductStatusWidget extends StatefulWidget {
  EditProductStatusWidget({Key? key}) : super(key: key);

  @override
  State<EditProductStatusWidget> createState() => _EditProductStatusWidgetState();
}

class _EditProductStatusWidgetState extends State<EditProductStatusWidget> {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Schimbare status produse',
            style: TextStyle(
              color: MyTheme.textColor(context),
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<List<Product>>(
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
              productList.prod = snapshot.data!;
              return Column(
                children: [
                  for (int index = 0;
                      index < productList.prod.length;
                      index++) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                        decoration: MyTheme.customDecoration(context),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    productList.prod[index].name,
                                    style: TextStyle(
                                      color: MyTheme.textColor(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Switch(
                                      onChanged: (bool newValue) {
                                        productList.prod[index].active=!productList.prod[index].active;
                                        FutureBuilder(
                                          future: productList.prod[index].updateProductStatus('meniuColina'),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'A apărut o eroare: ${snapshot.error}');
                                              }
                                              return const Text('');
                                            }
                                          },
                                        );
                                      },
                                      value: productList.prod[index].active,
                                    )),
                              ],
                            ),
                            Row(children: [
                              Text(
                                '${productList.prod[index].price} lei',
                                style: TextStyle(
                                  color: MyTheme.buttonColor(context),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
