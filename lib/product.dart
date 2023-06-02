import 'package:c_delivery/order_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_data.dart';

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

class ProductWidget extends StatelessWidget {
  Product currentProduct;

  ProductWidget({required this.currentProduct, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${currentProduct.name} x${currentProduct.qty}',
            style: TextStyle(
              color: MyTheme.textColor(context),
              fontSize: 15,
            )),
        Text('${currentProduct.price} Lei',
            style: TextStyle(
              color: MyTheme.textColor(context),
              fontSize: 15,
            )),
      ],
    );
  }
}

class EditProductList extends StatefulWidget {
  MyOrder currentOrder;
  bool editingMode;
  final Function(MyOrder) updateCurrentOrder;
  final Function() updateEdittingStatus;
  EditProductList({required this.currentOrder, required this.updateCurrentOrder, required this.editingMode, required this.updateEdittingStatus});

  @override
  State<EditProductList> createState() => _EditProductListState();
}

class _EditProductListState extends State<EditProductList> {
  List<double> qty = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyOrder>.value(
      value: widget.currentOrder,
      child: Consumer<MyOrder>(builder: (context, data, child) {
        return Column(children: [
          for (int index = 0;
              index < widget.currentOrder.productList.prod.length;
              index++) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.currentOrder.productList.prod[index].name,
                style:
                    TextStyle(color: MyTheme.textColor(context), fontSize: 15),
              ),
              DropdownButton(
                value: widget.currentOrder.productList.prod[index].qty,
                items: qty.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      '$e',
                      style: TextStyle(color: MyTheme.textColor(context)),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    widget.currentOrder.productList.prod[index].qty = val!;
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    widget.currentOrder.productList
                        .removeProduct(widget.currentOrder.productList.prod[index]);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.remove_circle_rounded,
                    color: MyTheme.buttonColor(context),
                  )),
            ]),
          ],
          Padding(
            //Save OrderDetails Button
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: MyTheme.buttonColor(context),
              child: TextButton(
                  onPressed: () {
                    widget.currentOrder.subtotal=widget.currentOrder.productList.subtotal();
                    widget.currentOrder.total=widget.currentOrder.subtotal + widget.currentOrder.deliveryFee;
                    FutureBuilder(
                      future: widget.currentOrder
                          .uploadOrder('orders'),
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
                    setState(() {
                      widget.updateEdittingStatus;
                      widget.currentOrder.id='';
                    });
                  },
                  child: Text(
                    'Salveaza detaliile',
                    style: TextStyle(color: MyTheme.textColor(context)),
                  )),
            ),
          ),
        ]);
      }),
    );
  }
}
