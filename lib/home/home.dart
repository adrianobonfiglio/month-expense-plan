import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/bill.dart';
import 'package:month_expense_plan/bill/billform.dart';
import 'package:month_expense_plan/bill/card.dart';
import 'package:month_expense_plan/bill/status.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  TabController controller;

  List<Bill> bills = new List();
  List<Bill> payedBills = new List();

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _gotToFormAndWaitForUpdate(BuildContext context, int index,
      Status status) async {
    Bill bill;
    if (status == Status.OPEN) {
      bill = bills[index];
    } else {
      bill = payedBills[index];
    }
    final b = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => BillForm(),
        settings: RouteSettings(arguments: bill)));

    setState(() {
      if (b != null &&
          (bill.status == Status.OPEN && b.status != Status.OPEN)) {
        bills.removeAt(index);
        _addToPayedBillsAndShowTab(b, null);
      } else if (b != null &&
          (bill.status == Status.PAYED && b.status != Status.PAYED)) {
        payedBills.removeAt(index);
        _addToOpenBillsAndShowTab(b, null);
      } else if (b != null && b.status == Status.OPEN) {
        bills.removeAt(index);
        _addToOpenBillsAndShowTab(b, index);
      } else {
        payedBills.removeAt(index);
        _addToPayedBillsAndShowTab(b, index);
      }
    });
  }

  _addToOpenBillsAndShowTab(Bill bill, int index) {
    int i = bills.length;
    if (index != null) {
      i = index;
    }
    bills.insert(i, bill);
    controller.animateTo(0, duration: Duration(seconds: 2));
  }

  _addToPayedBillsAndShowTab(Bill bill, int index) {
    int i = payedBills.length;
    if (index != null) {
      i = index;
    }
    payedBills.insert(i, bill);
    controller.animateTo(1, duration: Duration(seconds: 2));
  }


  _goToFormAndWaitForSaveResult(BuildContext context) async {
    final b = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => BillForm()));

    setState(() {
      if (b != null && b.status == Status.OPEN) {
        _addToOpenBillsAndShowTab(b, null);
      } else {
        _addToPayedBillsAndShowTab(b, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novembro", style: TextStyle(color: Colors.white)),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: BARS_COLOR,
        actions: <Widget>[
          Icon(Icons.settings)
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              color: BARS_COLOR,
              height: 115,
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("Estimados",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontFamily: FONT_FAMILY,
                                  fontWeight: FontWeight.bold)),
                          Text("R\$ 3.000,00",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: FONT_FAMILY,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30, left: 30),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Gasto",
                            style: TextStyle(
                                color: Colors.amber,
                                fontFamily: FONT_FAMILY,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("R\$ 1.000,00",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: FONT_FAMILY,
                                  fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: TabBar(
                      controller: controller,
                      onTap: (index) {
                        print(index);
                      },
                      indicator: UnderlineTabIndicator(
                          insets: EdgeInsets.all(5),
                          borderSide:
                          BorderSide(width: 5, color: Colors.amber)),
                      tabs: [
                        Text("Abertas",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: FONT_FAMILY,
                                fontWeight: FontWeight.bold)),
                        Text("Pagas",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: FONT_FAMILY,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              )),
          Container(
            height: ((MediaQuery
                .of(context)
                .size
                .height - AppBar().preferredSize.height) - 115 - 80),
            child:
            TabBarView(
                controller: controller,
                children: <Widget>[
                  ListView.builder(
                      itemCount: bills.length, itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _gotToFormAndWaitForUpdate(context, index, Status.OPEN);
                      },
                      child: BillCard(bills[index]),
                    );
                  }),
                  ListView.builder(itemCount: payedBills.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _gotToFormAndWaitForUpdate(
                                context, index, Status.PAYED);
                          },
                          child: BillCard(payedBills[index]),
                        );
                      })
                ]),
          ),
          BottomNavigationBar(
              backgroundColor: BARS_COLOR,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.insert_chart, color: Colors.white, size: 25),
                    title: Title(color: BARS_COLOR, child:
                    Text("Histórico", style: TextStyle(color: Colors.white)
                    ))
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 25),
                    title: Title(color: BARS_COLOR,
                        child: Text("Próximo mês",
                          style: TextStyle(color: Colors.white),)))
              ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xffFFC400),
        onPressed: () {
          _goToFormAndWaitForSaveResult(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}