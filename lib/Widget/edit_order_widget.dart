import 'package:c_delivery/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Classes/order_class.dart';

class EditOrderWidget extends StatefulWidget {
  final MyOrder currentOrder;
  final Function(bool) updateEdittingStatus;
  final Function(bool) showProducts;

  const EditOrderWidget(
      {super.key, required this.currentOrder,
      required this.updateEdittingStatus,
      required this.showProducts});

  @override
  State<EditOrderWidget> createState() => _EditOrderWidgetState();
}

class _EditOrderWidgetState extends State<EditOrderWidget> {
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
                    widget.currentOrder.productList.removeProduct(
                        widget.currentOrder.productList.prod[index]);
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
                    widget.showProducts(true);
                    widget.updateEdittingStatus(true);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Adauga un produs',
                        style: TextStyle(color: MyTheme.textColor(context)),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Padding(
            //Save OrderDetails Button
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: MyTheme.buttonColor(context),
              child: TextButton(
                  onPressed: () {
                    widget.currentOrder.subtotal =
                        widget.currentOrder.productList.subtotal();
                    widget.currentOrder.total = widget.currentOrder.subtotal +
                        widget.currentOrder.deliveryFee;
                    FutureBuilder(
                      future: widget.currentOrder.uploadOrder('orders'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError) {
                            return Text('A apărut o eroare: ${snapshot.error}');
                          }
                          return const Text('');
                        }
                      },
                    );

                    setState(() {
                      widget.showProducts(false);
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
