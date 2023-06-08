import 'package:c_delivery/Classes/product_list_class.dart';
import 'package:c_delivery/theme_data.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  final Product currentProduct;
  final ProductList productList;
  final Function(ProductList productList) productAdded;
  const ProductWidget({required this.currentProduct, required this.productList, required this.productAdded, Key? key}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    widget.currentProduct.name,
                    style: TextStyle(
                      color: MyTheme.textColor(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(onPressed: () {
                    widget.productList.prod.add(widget.currentProduct);
                    widget.productAdded(widget.productList);
                  }, icon: Icon(Icons.add_circle, color: MyTheme.buttonColor(context),),),)
              ],
            ),
            Row(children: [
              Text(
                '${widget.currentProduct.price} lei',
                style: TextStyle(
                  color: MyTheme.buttonColor(context),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}