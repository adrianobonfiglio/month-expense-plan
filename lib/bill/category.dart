import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Category {
  String name;
  Color color;

  Category(this.name, this.color);

  static List<Category> allCategories () {
    return <Category>[
      Category("Celular", Colors.deepOrange),
      Category("Internet", Colors.deepPurpleAccent),
      Category("Carro", Colors.brown),
      Category("Casa", Colors.blue),
      Category("Escola", Colors.lightGreen),
      Category("Alimentação", Colors.pink),
      Category("Entretenimento", Colors.blueGrey),
    ];
  }

  static Category getCategory(String categoryName) {
    return allCategories().firstWhere((cat) => cat.name == categoryName);
  }
}
