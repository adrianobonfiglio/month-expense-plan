import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/Bill.dart';
import 'package:month_expense_plan/bill/category.dart';

const FONT_FAMILY = "Helvetica Neue";

class BillCard extends StatelessWidget {

  final String name;
  final String dueDate;
  final Category category;
  final String amount;

  BillCard(this.name, this.dueDate, this.category, this.amount);

  getWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, bottom: 8, top: 8),
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 90,
                  width: getWidth(context, 0.020),
                  color: this.category.color,
                ),
              ],
            ),
            Container(
              width: getWidth(context, 0.5),
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(this.name, style:
                      TextStyle(fontFamily: FONT_FAMILY, fontWeight:FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(bottom: 10, left: 5),
                    child: Text("Venc. dia " + this.dueDate, style:
                      TextStyle(fontFamily: FONT_FAMILY, fontWeight:FontWeight.bold, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: getWidth(context, 0.4),
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: Text("R\$ ${this.amount}", style:
                      TextStyle(fontFamily: FONT_FAMILY, fontWeight:FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 10, right: 10),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: this.category.color
                      ),
                      child: Text(this.category.name, style:
                        TextStyle(fontWeight:FontWeight.bold, fontSize: 14, color: Colors.white)
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
