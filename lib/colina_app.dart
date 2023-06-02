import 'package:c_delivery/adress_class.dart';
import 'package:c_delivery/order_details.dart';
import 'package:c_delivery/product.dart';
import 'package:c_delivery/theme_data.dart';
import 'package:c_delivery/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order_class.dart';
import 'order_widget.dart';

class Colina extends StatefulWidget {
  final MyUser currentUser;

  Colina({required this.currentUser, Key? key}) : super(key: key);

  @override
  State<Colina> createState() => _ColinaState();
}

class _ColinaState extends State<Colina> {
  MyOrder currentOrder = MyOrder.late();

  List<MyOrder> orderList = [];
  
  void updateOrderList(List<MyOrder> newList)
  {
    setState(() {
      orderList=newList;
    });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      title: 'Colina Unitbv',
      home: Scaffold(
        appBar: AppBar(           //AppBar
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
                Padding(                              //bine ai venit
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Bine ai venit, ${widget.currentUser.firstName}!',
                    style: TextStyle(
                      color: MyTheme.textColor(context),
                      fontSize: 20,
                    ),
                  ),
                ),      //bine ai venit
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(           //Lista de comenzi in asteptare
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyTheme.backgroundColor(context),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),
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
                                        height:
                                            MediaQuery.of(context).size.height,
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
                      ),      //Lista de comenzi in asteptare
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(           //Detalii comanda
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(          //Stilizarea Containerului
                              color: MyTheme.backgroundColor(context),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ]),   //Stilizarea Containerului
                          height: MediaQuery.of(context).size.height - 200,
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          child: OrderDetails(currentOrder: currentOrder, orderList: orderList, updateOrderList: updateOrderList, ),
                        ),
                      ),        //Detalii comanda
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(             //Meniu Produse
                        flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyTheme.backgroundColor(context),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ]),
                            height: MediaQuery.of(context).size.height - 200,),),       //Meniu Produse
                    ],
                  ),
                )  //Lista de comenzi in asteptare
              ],
            ),
          ),
        ),
      ),
    );
  }
}
