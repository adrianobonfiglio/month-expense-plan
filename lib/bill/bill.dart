import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/bill/status.dart';

class Bill {
  String name;
  double amount;
  Category category;
  String dueDate;
  Status status;
  bool recurrent;
  double plannedAmount;

  Bill(this.name, this.amount, this.category, this.dueDate, this.status, this.recurrent, this.plannedAmount);

  static List<Bill> findAll() {
    return [
      Bill("Compras do Mês", 500.0,
          Category("Marcado", Color(0xffFF1744)), "15", Status.OPEN, false, 500.0),
      Bill("Água", 90.0, Category("Casa", Color(0xff00C853)), "25", Status.OPEN, false, 90.0),
      Bill("Luz", 90.0, Category("Casa", Color(0xff00C853)), "10", Status.OPEN, false, 90.0),
      Bill("Celular", 130.0, Category("Pessoal", Color(0xff0091EA)),
          "15", Status.OPEN, false, 130.0),
      Bill("Carro", 380.0, Category("Carro", Color(0xff6200ea)),
          "22", Status.OPEN, false, 380.0),
      Bill("Internet", 90.0, Category("Pessoal", Color(0xff0091EA)),
          "15", Status.OPEN, false, 90.0)
    ];
  }

  static List<Bill> findAllPayed() {
    return [
      Bill("Compras do Mês", 500.0,
          Category("Marcado", Color(0xffFF1744)), "15", Status.PAYED, false, null),
      Bill("Água", 90.0, Category("Casa", Color(0xff00C853)), "25", Status.PAYED, false, null)
    ];
  }
}
