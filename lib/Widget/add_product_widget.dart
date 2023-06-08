import 'package:c_delivery/Classes/product_list_class.dart';
import 'package:flutter/material.dart';

import '../theme_data.dart';

class AddProductWidget extends StatefulWidget {
  final Function(bool value) updateAddProduct;

  const AddProductWidget({required this.updateAddProduct, Key? key})
      : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  Product product = Product(id: '', name: '', price: '', active: true, qty: 1);
  String error = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  'Adaugare produs nou',
                  style:
                      TextStyle(color: MyTheme.textColor(context), fontSize: 20),
                )),
            Expanded(flex: 4,child: Container()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: MyTheme.buttonColor(context),
                  child: TextButton(
                    onPressed: () {
                      RegExp reg1 = RegExp(r'^\d+\.\d{2}$');
                      RegExp reg2 = RegExp(r'^\d{2}\.\d{2}$');
                      if (reg1.hasMatch(priceController.text.trim()) ||
                          reg2.hasMatch(priceController.text.trim())) {
                        product.name = nameController.text.trim();
                        product.price = priceController.text.trim();
                        product
                            .addProduct('meniuColina')
                            .then((value) {})
                            .catchError((error) {
                          print('eroare');
                        });
                        setState(() {
                          widget.updateAddProduct(false);
                          error = '';
                        });
                      } else {
                        setState(() {
                          error =
                          'Formatul pretului este incorect! Va rugam introduceti o valoare cu formatul: 19.99';
                        });
                      }
                    },
                    child: Text(
                      'Adaugare',
                      style: TextStyle(color: MyTheme.textColor(context)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nume produs',
                ),
                style: TextStyle(
                  color: MyTheme.textColor(context),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: 2,
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Pret',
                ),
                style: TextStyle(
                  color: MyTheme.textColor(context),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 15),
          ),
        )
      ]),
    );
  }
}
