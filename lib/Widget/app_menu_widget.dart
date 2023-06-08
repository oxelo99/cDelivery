import 'package:c_delivery/theme_data.dart';
import 'package:flutter/material.dart';

class AppMenu extends StatelessWidget {
  int menuSelector = 0;
  final Function(int value) updateMenuSelector;
  final Function(bool value) showProducts;
  final Function(bool value) edittingMode;
  AppMenu({required this.updateMenuSelector, required this.showProducts, required this.edittingMode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyTheme.customDecoration(context),
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Meniu',
            style: TextStyle(
              color: MyTheme.textColor(context),
              fontSize: 20,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            decoration: MyTheme.customDecoration(context),
            child: TextButton(
                onPressed: () {
                  menuSelector = 1;
                  updateMenuSelector(menuSelector);
                },
                child: Text('Lista comenzi', style: TextStyle(color: MyTheme.textColor(context)),)),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            decoration: MyTheme.customDecoration(context),
            child: TextButton(
                onPressed: () {
                  menuSelector = 2;
                  updateMenuSelector(menuSelector);
                  showProducts(false);
                  edittingMode(false);
                },
                child: Text('Status Produse', style: TextStyle(color: MyTheme.textColor(context)),)),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            decoration: MyTheme.customDecoration(context),
            child: TextButton(
                onPressed: () {
                  menuSelector = 3;
                  updateMenuSelector(menuSelector);
                  showProducts(false);
                  edittingMode(false);
                },
                child: Text('Editare Produse', style: TextStyle(color: MyTheme.textColor(context)),)),
          )
        ],
      ),
    );
  }
}
