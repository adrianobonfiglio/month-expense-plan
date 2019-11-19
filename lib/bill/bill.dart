import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/bill/status.dart';

class Bill {
  String name;
  String amount;
  Category category;
  String dueDate;
  Status status;

  Bill(this.name, this.amount, this.category, this.dueDate, this.status);

  static List<Bill> findAll() {
    return [
      Bill("Compras do Mês", "R\$ 500,00",
          Category("Marcado", Color(0xffFF1744)), "15", Status.OPEN),
      Bill("Água", "R\$ 90,00", Category("Casa", Color(0xff00C853)), "25", Status.OPEN),
      Bill("Luz", "R\$ 90,00", Category("Casa", Color(0xff00C853)), "10", Status.OPEN),
      Bill("Celular", "R\$ 130,00", Category("Pessoal", Color(0xff0091EA)),
          "15", Status.OPEN),
      Bill("Carro", "R\$ 380,00", Category("Carro", Color(0xff6200ea)),
          "22", Status.OPEN),
      Bill("Internet", "R\$ 99,00", Category("Pessoal", Color(0xff0091EA)),
          "15", Status.OPEN)
    ];
  }

  static List<Bill> findAllPayed() {
    return [
      Bill("Compras do Mês", "R\$ 500,00",
          Category("Marcado", Color(0xffFF1744)), "15", Status.PAYED),
      Bill("Água", "R\$ 90,00", Category("Casa", Color(0xff00C853)), "25", Status.PAYED)
    ];
  }
}
