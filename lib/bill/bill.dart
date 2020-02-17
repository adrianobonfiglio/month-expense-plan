import 'package:month_expense_plan/bill/category.dart';
import 'package:month_expense_plan/bill/status.dart';
import 'package:month_expense_plan/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Bill {
  int id;
  String name;
  double amount;
  Category category;
  String dueDate;
  Status status;
  bool recurrent;
  double plannedAmount;

  Bill(this.id, this.name, this.amount, this.category, this.dueDate,
      this.status, this.recurrent, this.plannedAmount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'planned_amount': plannedAmount,
      'category': category.name,
      'status': status.toString().split('.').last,
      'dueDate': dueDate,
      'recurrent': recurrent,
    };
  }

  static Future<List<Bill>> findAllOpen() async {
    final Database db = await DatabaseConnection().getDatabaseConnection();

    final List<Map<String, dynamic>> maps = await db.query('Bill', where: "status == ?", whereArgs: [Status.OPEN.toString().split('.').last]);

    return List.generate(maps.length, (i) {
      return Bill(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['amount'],
          Category.getCategory(maps[i]['category']),
          maps[i]['dueDate'],
          Status
              .OPEN, //Status.values.singleWhere((s) => s == maps[i]['status']),
          maps[i]['recurrent'] == 0 ? false : true,
          maps[i]['planned_amount']);
    });
  }

    static Future<List<Bill>> findAllPayed() async {
    final Database db = await DatabaseConnection().getDatabaseConnection();

    final List<Map<String, dynamic>> maps = await db.query('Bill', where: "status == ?", whereArgs: [Status.PAYED.toString().split('.').last]);

    return List.generate(maps.length, (i) {
      return Bill(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['amount'],
          Category.getCategory(maps[i]['category']),
          maps[i]['dueDate'],
          Status
              .PAYED, //Status.values.singleWhere((s) => s == maps[i]['status']),
          maps[i]['recurrent'] == 0 ? false : true,
          maps[i]['planned_amount']);
    });
  }

  static Bill findOne(int id) {
    return null;
  }

  static Future<Bill> save(Bill bill) async {
    final Database db = await DatabaseConnection().getDatabaseConnection();
    if (bill.id != null) {
      await db.update('Bill', bill.toMap());
    } else {
      await db.insert('Bill', bill.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return null;
  }

  static void delete(int id) {}
}
