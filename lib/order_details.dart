import 'package:c_delivery/product.dart';
import 'package:c_delivery/theme_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_class.dart';

class OrderDetails extends StatefulWidget {
  bool editingMode = false;
  MyOrder currentOrder;
  List<MyOrder> orderList;
  final Function(List<MyOrder>) updateOrderList;

  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .delete();
      print('Documentul a fost șters cu succes!');
    } catch (e) {
      print('A apărut o eroare la ștergerea documentului: $e');
    }
  }

  OrderDetails(
      {required this.currentOrder,
      required this.orderList,
      required this.updateOrderList,
      Key? key})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<String> status = ['In procesare', 'Pregatit de livrare', 'Anulata'];
  String errorMessage = '';

  void updateEditingMode() {
    setState(() {
      widget.editingMode = !widget.editingMode;
    });
  }

  void updateCurrentOrder(MyOrder updatedOrder) {
    setState(() {
      widget.currentOrder = updatedOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.currentOrder.id == '') ...[
              Text('Selecteaza o comanda!',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 20,
                  )),
            ] else ...[
              Text('Detalii Comanda: ${widget.currentOrder.id}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 6,
              ),
              Text('Data: ${widget.currentOrder.startDate}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )), //Display Order Date&Time
              const SizedBox(
                height: 6,
              ),
              Text('Nume: ${widget.currentOrder.user.firstName}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )), //Next 3 TextWidget for userDetails
              Text('Prenume: ${widget.currentOrder.user.lastName}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )),
              Text('Numar de telefon: ${widget.currentOrder.user.phoneNumber}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )),
              const SizedBox(
                height: 10,
              ),
              Text(
                  'Adresa de livrare: ${widget.currentOrder.orderAddress.complex}, Caminul: ${widget.currentOrder.orderAddress.buildingNumber}, Etajul: ${widget.currentOrder.orderAddress.floor}, Camera: ${widget.currentOrder.orderAddress.room}',
                  style: TextStyle(
                    color: MyTheme.textColor(context),
                    fontSize: 15,
                  )), //DeliveryAddress
              const SizedBox(
                height: 10,
              ),
              Text(
                'Produse:',
                style: TextStyle(
                  color: MyTheme.textColor(context),
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.editingMode == false) ...[
                Column(children: [
                  //Order ProductList
                  for (int index = 0;
                      index < widget.currentOrder.productList.prod.length;
                      index++)
                    ProductWidget(
                        currentProduct:
                            widget.currentOrder.productList.prod[index]),
                ]), //Order ProductList
                Row(
                  //Subtotal Row
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal:',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        )),
                    Text(
                        '${widget.currentOrder.subtotal.toStringAsFixed(2)} Lei',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        ))
                  ],
                ), //Subtotal Row
                Row(
                  //DeliveryFee Row
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Taxa de livrare:',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        )),
                    Text(
                        '${widget.currentOrder.deliveryFee.toStringAsFixed(2)} Lei',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        ))
                  ],
                ), //DeliveryFee Row
                Row(
                  //Order Total Row
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        )),
                    Text('${widget.currentOrder.total.toStringAsFixed(2)} Lei',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        ))
                  ],
                ), //Order Total Row
                Row(
                  //Status dropdown row
                  children: [
                    Text('Status: ',
                        style: TextStyle(
                          color: MyTheme.textColor(context),
                          fontSize: 15,
                        )),
                    DropdownButton(
                      value: widget.currentOrder.status,
                      items: status.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(color: MyTheme.textColor(context)),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          widget.currentOrder.status = val!;
                        });
                      },
                    ),
                  ],
                ), //Status dropdown row
                Padding(
                  //Buton Editare comanda
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: MyTheme.buttonColor(context),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.editingMode = true;
                          });
                        },
                        child: Text(
                          'Editare comanda',
                          style: TextStyle(color: MyTheme.textColor(context)),
                        )),
                  ),
                ), //Buton Editare comanda
                Padding(
                  //Buton Finalizare comanda
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: MyTheme.buttonColor(context),
                    child: TextButton(
                        //Buton Finalizare comanda
                        onPressed: () {
                          setState(() async {
                            if (widget.currentOrder.status ==
                                'Pregatit de livrare') {
                              widget.orderList.remove(widget.currentOrder);
                              widget.updateOrderList(widget.orderList);
                              FutureBuilder(
                                future: widget.currentOrder
                                    .uploadOrder('readytodeliveryColinaOrders'),
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
                              FutureBuilder(
                                future: widget.deleteDocument(
                                    'orders', widget.currentOrder.id),
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
                              widget.currentOrder.id = '';
                            } else if (widget.currentOrder.status ==
                                'In procesare') {
                              setState(() {
                                errorMessage =
                                    'Pentru a finaliza comanda trebuie sa schimbi statusul!';
                              });
                            } else {
                              FutureBuilder(
                                future: widget.currentOrder
                                    .uploadOrder('cancelledColinaOrders'),
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
                              FutureBuilder(
                                future: widget.deleteDocument(
                                    'orders', widget.currentOrder.id),
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
                              widget.orderList.remove(widget.currentOrder);
                              widget.updateOrderList(widget.orderList);
                              widget.currentOrder.id = '';
                              setState(() {

                              });
                            }
                          });
                        },
                        child: Text(
                          'Finalizeaza comanda',
                          style: TextStyle(color: MyTheme.textColor(context)),
                        )), //Buton Finalizare comanda
                  ),
                ), //Buton Finalizare comanda
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 15),
                )
              ] else ...[
                EditProductList(
                  updateCurrentOrder: updateCurrentOrder,
                  currentOrder: widget.currentOrder,
                  editingMode: widget.editingMode,
                  updateEdittingStatus: updateEditingMode,
                ),
              ]
            ]
          ],
        ),
      ),
    );
  }
}
