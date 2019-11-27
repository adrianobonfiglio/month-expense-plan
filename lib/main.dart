import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:month_expense_plan/bill/bill.dart';
import 'package:month_expense_plan/bill/billform.dart';
import 'package:month_expense_plan/bill/card.dart';
import 'package:month_expense_plan/bill/status.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Month Expense Plan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const BARS_COLOR = Color(0xff00BFA5);
const FONT_FAMILY = "Helvetica Neue";

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  TabController controller;

  List<Bill> bills = new List();
  List<Bill> payedBills = new List();

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);

    print("Init state");

    Bill.findAll().forEach((b) {
      //bills.add(BillCard(b.name, b.dueDate, b.category, b.amount));
    });

    Bill.findAllPayed().forEach((b) {
      //payedBills.add(BillCard(b.name, b.dueDate, b.category, b.amount));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    print("closing");
    super.dispose();
  }

  _gotToFormAndWaitForUpdate(BuildContext context, int index, Status status) async {
    Bill bill;
    if(status == Status.OPEN) {
      bill = bills[index];
    }else {
      bill = payedBills[index];
    }
   final b = await Navigator.push(context, MaterialPageRoute(builder: (context)=> BillForm(),
        settings: RouteSettings(arguments: bill)));

    setState(() {
      if(b!= null && (bill.status == Status.OPEN && b.status != Status.OPEN)) {
        bills.removeAt(index);
        payedBills.insert(payedBills.length, b);
        controller.animateTo(1, duration: Duration(seconds: 2));
      }else if(b!= null && (bill.status == Status.PAYED && b.status != Status.PAYED)){
        payedBills.removeAt(index);
        bills.insert(bills.length, b);
        controller.animateTo(0, duration: Duration(seconds: 2));
      }else if(b != null && b.status == Status.OPEN) {
        bills.removeAt(index);
        bills.insert(index, b);
        controller.animateTo(0, duration: Duration(seconds: 2));
      }else {
        payedBills.removeAt(index);
        payedBills.insert(index, b);
        controller.animateTo(1, duration: Duration(seconds: 2));
      }
    });
  }


  _goToFormAndWaitForSaveResult(BuildContext context) async {
        final b = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => BillForm()));
        
        print("SAVED");

    setState(() {
      if(b != null && b.status == Status.OPEN) {
        controller.animateTo(0, duration: Duration(seconds: 2));
        bills = List.from(bills)..add(Bill(b.name, b.amount, b.category, b.dueDate, b.status, b.recurrent, b.amount));
      }else {
        controller.animateTo(1, duration: Duration(seconds: 2));
        payedBills = List.from(payedBills)..add(Bill(b.name, b.amount, b.category, b.dueDate, b.status, b.recurrent, b.amount));
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
                        onTap: (index){
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
                  ListView.builder(itemCount: bills.length ,itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        _gotToFormAndWaitForUpdate(context, index, Status.OPEN);
                      },
                      child: BillCard(bills[index]),
                    );
                  }),
                  ListView.builder(itemCount: payedBills.length,itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        _gotToFormAndWaitForUpdate(context, index, Status.PAYED);
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
        onPressed: (){
          _goToFormAndWaitForSaveResult(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }


}
