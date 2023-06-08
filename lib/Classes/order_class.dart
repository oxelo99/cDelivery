import 'dart:js_util';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adress_class.dart';
import 'product_list_class.dart';
import 'user_class.dart';

class MyOrder extends ChangeNotifier{
  String id = '';
  Address orderAddress = Address.late();
  DateTime startDate = DateTime.now();
  MyUser user = MyUser.late();
  double deliveryFee = 0;
  double subtotal = 0;
  double total = 0;
  String status = '';
  ProductList productList= newObject();

  MyOrder({
    required this.id,
    required this.orderAddress,
    required this.startDate,
    required this.user,
    required this.deliveryFee,
    required this.subtotal,
    required this.total,
    required this.status,
    required this.productList,
  });

  MyOrder.late();

  Future<void> uploadOrder(String collection) async {
      FirebaseFirestore.instance.collection(collection).doc(id).set({
        'Products:': productList.prod
            .map((Product product) => product.toMap())
            .toList(),
        'User Details:': user.toMap(),
        'Address:': orderAddress.toMap(),
        'Status': status,
        'Subtotal': subtotal,
        'Delivery Fee': deliveryFee,
        'Total': total,
        'Date & Time': startDate,
        'Order id': id,
      });
    }
}