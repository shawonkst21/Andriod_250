
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';



class MyHomePage extends StatelessWidget {
  final dropDownKey = GlobalKey<DropdownSearchState>();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('examples mode')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownSearch<String>(
                  key: dropDownKey,
                  selectedItem: "Menu",
                  items: (filter, infiniteScrollProps) =>
                      ["Menu", "Dialog", "Modal", "BottomSheet"],
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Examples for: ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                      fit: FlexFit.loose, constraints: BoxConstraints()),
                ),
              ),
             
            ],
          ),
        ],
      ),
    );
  }
}