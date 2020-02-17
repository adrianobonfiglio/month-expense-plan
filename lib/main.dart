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
  }

  @override
  void dispose() {
    controller.dispose();
    print("closing");
    super.dispose();
  }

  _gotToFormAndWaitForUpdate(Bill bill) async {
    bill = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BillForm(),
            settings: RouteSettings(arguments: bill)));
    if(bill.status == Status.PAYED) {
      controller.animateTo(1, duration: Duration(seconds: 2));
    }else {
      controller.animateTo(0, duration: Duration(seconds: 2));
    }
  }

  _goToFormAndWaitForSaveResult(BuildContext context) async {
     await Navigator.push(
        context, MaterialPageRoute(builder: (context) => BillForm()));
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
            height: ((MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height) -
                115 -
                80),
            child: TabBarView(controller: controller, children: <Widget>[
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _gotToFormAndWaitForUpdate(snapshot.data[index]);
                            },
                            child: BillCard(snapshot.data[index]),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: Bill.findAllOpen(),
              ),
          FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _gotToFormAndWaitForUpdate(snapshot.data[index]);
                            },
                            child: BillCard(snapshot.data[index]),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: Bill.findAllPayed(),
              ),
            ]),
          ),
          BottomNavigationBar(backgroundColor: BARS_COLOR, items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart, color: Colors.white, size: 25),
                title: Title(
                    color: BARS_COLOR,
                    child: Text("Histórico",
                        style: TextStyle(color: Colors.white)))),
            BottomNavigationBarItem(
                icon: Icon(Icons.skip_next, color: Colors.white, size: 25),
                title: Title(
                    color: BARS_COLOR,
                    child: Text(
                      "Próximo mês",
                      style: TextStyle(color: Colors.white),
                    )))
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
