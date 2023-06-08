import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String name = '';
  String price = '';
  bool active = true;
  String id = '';
  double qty = 1;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.active,
    required this.qty,
  });

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    qty = map['qty'];
    active = true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'qty': qty,
    };
  }
  Future<void> updateProduct(String collection) async {
    FirebaseFirestore.instance.collection(collection).doc(id).update({
      'active': active,
      'name': name,
      'price': price,
    });
  }
  Future<void> addProduct(String collection) async {
    FirebaseFirestore.instance.collection(collection).add({
      'active': active,
      'name': name,
      'price': price,
    });
  }
  Future<void> removeProduct(String collection) async {
    await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
      DocumentReference docRef = FirebaseFirestore.instance.collection(collection).doc(id);
      myTransaction.delete(docRef);
    });
  }

  Future<void> updateProductStatus(String collection) async {
    FirebaseFirestore.instance.collection(collection).doc(id).update({
      'active': active,
    });
  }
}

class ProductList extends ChangeNotifier {
  List<Product> prod = [];

  void addProduct(Product product) {
    prod.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    prod.remove(product);
    notifyListeners();
  }

  double subtotal() {
    double subtotal = 0;
    for (int index = 0; index < prod.length; index++) {
      subtotal += double.parse(prod[index].price) * prod[index].qty;
    }
    return subtotal;
  }

  ProductList.fromMapList(List<dynamic> mapList) {
    for (int index = 0; index < mapList.length; index++) {
      prod.add(Product.fromMap(mapList[index]));
    }
  }
}