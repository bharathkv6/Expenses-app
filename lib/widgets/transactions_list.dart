import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function _deleteTransaction;

  TransactionsList(this.userTransactions, this._deleteTransaction);

  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 450,
        child: userTransactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No transactions added',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        ))
                  ],
                );
              })
            : ListView.builder(
                itemBuilder: (bctx, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text(
                              userTransactions[index].amount.toStringAsFixed(2),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        userTransactions[index].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(userTransactions[index].date),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        ),
                        onPressed: () =>
                            _deleteTransaction(userTransactions[index].id),
                      ),
                    ),
                  );
                },
                itemCount: userTransactions.length,
              ));
  }
}
