
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/bill.dart';
import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/bill/status.dart';
import 'package:month_expense_plan/main.dart';

const BARS_COLOR = Color(0xff00BFA5);

class BillForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BillFormState();
  }

}

class BillFormState extends State<BillForm> {

  final _formKey = GlobalKey<FormState>();
  int _amountValue = 0;
  Category dropdownValue;
  bool isPayed = false;
  bool isRecurrent = false;

  List<DropdownMenuItem<Category>> categories = List();

  TextEditingController nameFieldController = TextEditingController();
  TextEditingController amountFieldController = TextEditingController();
  TextEditingController dueDateFieldController = TextEditingController();

  @override
  void initState() {
    dueDateFieldController.text = DateTime.now().day.toString();
    super.initState();
  }

  @override
  void didChangeDependencies() {
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: BARS_COLOR,
          title: Text("Add new"),
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
                  Bill bill = Bill(nameFieldController.text, amountFieldController.text,
                      dropdownValue, dueDateFieldController.text, isPayed ? Status.PAYED : Status.OPEN, isRecurrent);
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
                TextField(
                  controller: amountFieldController,
                  decoration: InputDecoration(labelText: "Valor", prefix: Text("R\$ ")),
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
                        value: dropdownValue,
                        hint: Text("Categoria"),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (Category category) {
                          setState(() {
                            dropdownValue = category;
                          });
                        },
                        items: categories
                    ) ,
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text("Pago?"),
                          Switch(value: isPayed, onChanged: (value) {
                            setState(() {
                              isPayed = value;
                            });
                          } )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Recorrente?"),
                    Switch(value: isRecurrent, onChanged: (value) {
                      setState(() {
                        isRecurrent = value;
                      });
                    } )
                  ],
                ),
              ],
            ),
          )
        )
    );
  }

}