
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/bill.dart';
import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/bill/status.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

const BARS_COLOR = Color(0xff00BFA5);

class BillForm extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return BillFormState();
  }

}

class BillFormState extends State<BillForm> {

  final _formKey = GlobalKey<FormState>();

  String screenTitle = "Add new";
  int _amountValue = 0;
  Category categoryDropDownValue;
  bool isPayed = false;
  bool isRecurrent = false;

  List<DropdownMenuItem<Category>> categories = List();

  TextEditingController nameFieldController = TextEditingController();
  TextEditingController amountFieldController = TextEditingController();
  TextEditingController dueDateFieldController = TextEditingController();
  TextEditingController plannedAmount = TextEditingController();

  @override
  void initState() {
    dueDateFieldController.text = DateTime.now().day.toString();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("form dependencies change");
    for(Category category in Category.allCategories()) {
      categories.add(
          DropdownMenuItem<Category>(
              value: category,
              child: Container(
                child: Text(category.name, style: TextStyle(color: category.color)),
              )
          )
      );

    }
    setState(() {
      Bill bill = ModalRoute.of(context).settings.arguments;
      if(bill != null) {
        screenTitle = "Edit Bill";
        nameFieldController.text = bill.name;
        amountFieldController.text = bill.amount.toString();
        dueDateFieldController.text = bill.dueDate;
        isPayed = bill.status == Status.PAYED ? true : false;
        isRecurrent = bill.recurrent;
        categoryDropDownValue = categories.where((cat) => cat.value.name == bill.category.name).toList()[0].value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: BARS_COLOR,
          title: Text(screenTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context, false);
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save, size: 30, color: Colors.white),
                onPressed: () {
                  FlutterMoneyFormatter flutterMoneyFormatter = FlutterMoneyFormatter(
                      amount: double.parse(amountFieldController.text),
                      settings: MoneyFormatterSettings(symbol: "R\$", decimalSeparator: ",", fractionDigits: 2)
                  );


                  Bill bill = Bill(nameFieldController.text, double.tryParse(amountFieldController.text),
                      categoryDropDownValue, dueDateFieldController.text, isPayed ? Status.PAYED : Status.OPEN,
                      isRecurrent, double.tryParse(plannedAmount.text));
                  Navigator.pop(context, bill);
                }
            )
          ],
        ),
        body: Form(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameFieldController,
                  decoration: InputDecoration(labelText: "Nome"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Text("Recorrente?"),
                      Switch(value: isRecurrent, onChanged: (value) {
                        setState(() {
                          isRecurrent = value;
                        });
                      } ),
                      Text("Pago?"),
                      Switch(value: isPayed, onChanged: (value) {
                        setState(() {
                          isPayed = value;
                        });
                      } )
                    ],
                  ),
                ),
                TextField(
                    enabled: isRecurrent,
                    controller: amountFieldController,
                    decoration: InputDecoration(labelText: "Valor Planejado", prefix: Text("R\$ "))
                ),
                TextField(
                  enabled: isPayed,
                  controller: amountFieldController,
                  decoration: InputDecoration(labelText: "Valor Pago", prefix: Text("R\$ "))
                ),
                TextField(
                  controller: dueDateFieldController,
                  maxLength: 2,
                  decoration: InputDecoration(labelText: "Dia do Vencimento"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton(
                        value: categoryDropDownValue,
                        hint: Text("Categoria"),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (Category category) {
                          setState(() {
                            categoryDropDownValue = category;
                          });
                        },
                        items: categories
                    )
                  ],
                ),
              ],
            ),
          )
        )
    );
  }

}