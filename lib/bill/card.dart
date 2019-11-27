import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/bill.dart';
import 'package:month_expense_plan/bill/billform.dart';
import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/main.dart';

const FONT_FAMILY = "Helvetica Neue";

class BillCard extends StatelessWidget {
  final Bill bill;

  BillCard(this.bill);

  getWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 8, top: 8),
      child: SizedBox(
        height: 90,
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              child: Container(
                color: bill.category.color,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      bill.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: FONT_FAMILY,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "Venc. dia " + bill.dueDate,
                      style: TextStyle(
                          fontFamily: FONT_FAMILY,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "R\$ ${bill.amount}",
                      style: TextStyle(
                          fontFamily: FONT_FAMILY,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: bill.category.color),
                      child: Text(bill.category.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white)),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
