import './widgets/transactions_list.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() async{
  runApp(new ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense App",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            button: TextStyle(
              color: Colors.white,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      home: ExpensesAppHomePage(),
    );
  }
}

class ExpensesAppHomePage extends StatefulWidget {
  ExpensesAppHomePage({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  ExpensesAppHomePageState createState() {
    return ExpensesAppHomePageState();
  }
}

class ExpensesAppHomePageState extends State<ExpensesAppHomePage> {
  final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      date: DateTime.now(),
      amount: 69.99,
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      date: DateTime.now(),
      amount: 16.53,
    ),
  ];

  List<Transaction> get recentTransactions {
    DateTime limitDate = DateTime.now().subtract(Duration(days: 7));
    List<Transaction> recentTxns = [];

    for (Transaction txn in transactions) {
      if (txn.date.isAfter(limitDate)) {
        recentTxns.add(txn);
      }
    }
    return recentTxns;
  }

  void addNewTransaction(String title, double amount, DateTime selectedDate) {
    final Transaction newTxn = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
      date: selectedDate,
    );
    setState(() {
      transactions.add(newTxn);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((txn) {
        return txn.id == id;
      });
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => GestureDetector(
        onTap: () {},
        child: NewTransaction(addNewTransaction),
        behavior: HitTestBehavior.opaque,
      ),
    );
  }

  Widget build(BuildContext ctx) {
    final mediaQuery = MediaQuery.of(ctx);
    final AppBar appBar = AppBar(
        title: Text('Expenses App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => startAddNewTransaction(ctx),
          )
        ],
      );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
            child: Chart(recentTransactions),
          ),
          Container(
            height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
            child: TransactionsList(transactions, _deleteTransaction),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(ctx),
      ),
    );
  }
}
