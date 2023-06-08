import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Classes/product_list_class.dart';
import '../theme_data.dart';

class EditMenuWidget extends StatefulWidget {
  final Function(bool value) updateAddProduct;

  const EditMenuWidget({required this.updateAddProduct, Key? key})
      : super(key: key);

  @override
  State<EditMenuWidget> createState() => _EditMenuWidgetState();
}

class _EditMenuWidgetState extends State<EditMenuWidget> {
  ProductList productList = newObject();
  List<String> error = [];
  List<bool> edit = [];
  List<TextEditingController> nameController = [];
  List<TextEditingController> priceController = [];
  bool addProduct = false;

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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Editare Produse',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 20,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      widget.updateAddProduct(true);
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: MyTheme.buttonColor(context),
                    ))
              ],
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
              for (Product prod in productList.prod) {
                edit.add(false);
                error.add('');
                nameController.add(TextEditingController(text: prod.name));
                priceController.add(TextEditingController(text: prod.price));
              }
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
                        child: Column(children: [
                          if (edit[index] == false) ...[
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: MyTheme.buttonColor(context),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              edit[index] = true;
                                            });
                                          },
                                          child: Text(
                                            'Editare',
                                            style: TextStyle(
                                                color:
                                                    MyTheme.textColor(context)),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${productList.prod[index].price} lei',
                                    style: TextStyle(
                                      color: MyTheme.buttonColor(context),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        productList.prod[index].removeProduct('meniuColina');
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: MyTheme.buttonColor(context),
                                      ))
                                ]),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    controller: nameController[index],
                                    decoration: const InputDecoration(
                                      labelText: 'Nume produs',
                                    ),
                                    style: TextStyle(
                                      color: MyTheme.textColor(context),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: MyTheme.buttonColor(context),
                                      child: TextButton(
                                        onPressed: () {
                                          RegExp reg1 = RegExp(r'^\d+\.\d{2}$');
                                          RegExp reg2 =
                                              RegExp(r'^\d{2}\.\d{2}$');
                                          if (reg1.hasMatch(
                                                  priceController[index]
                                                      .text
                                                      .trim()) ||
                                              reg2.hasMatch(
                                                  priceController[index]
                                                      .text
                                                      .trim())) {
                                            productList.prod[index].name =
                                                nameController[index]
                                                    .text
                                                    .trim();
                                            productList.prod[index].price =
                                                priceController[index]
                                                    .text
                                                    .trim();
                                            productList.prod[index]
                                                .updateProduct('meniuColina')
                                                .then((value) {})
                                                .catchError((error) {
                                              print('eroare');
                                            });
                                            setState(() {
                                              edit[index] = false;
                                              error[index] = '';
                                            });
                                          } else {
                                            setState(() {
                                              error[index] =
                                                  'Formatul pretului este incorect! Va rugam introduceti o valoare cu formatul: 19.99';
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Salvare',
                                          style: TextStyle(
                                              color:
                                                  MyTheme.textColor(context)),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: priceController[index],
                                    decoration: const InputDecoration(
                                      labelText: 'Pret',
                                    ),
                                    style: TextStyle(
                                      color: MyTheme.textColor(context),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: Container())
                              ],
                            ),
                            Center(
                              child: Text(
                                error[index],
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 15),
                              ),
                            )
                          ]
                        ]),
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
