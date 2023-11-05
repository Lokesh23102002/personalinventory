import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'database_helper.dart';
import 'item_model.dart';

class Cash extends StatefulWidget {
  @override
  _CashState createState() => _CashState();
}

class _CashState extends State<Cash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cash'),
      ),
      body: Money(),
      //floatting button to add more items
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          fixedColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Cash",
              icon: Icon(Icons.savings),
            ),
          ],
          onTap: (int indexOfItem) {
            if (indexOfItem == 0) {
              Navigator.pop(context);
            }
          }),
    );
  }
}

class Money extends StatefulWidget {
  Money({super.key});
  List selected = ["1", "1"];

  @override
  State<Money> createState() => _MoneyState();
}

class _MoneyState extends State<Money> {
  List item_cash = [
    "500",
    "200",
    "100",
    "50",
    "20",
    "10",
    "5",
    "2000",
    "2",
    "1",
  ];
  ValueNotifier<bool> _notifier = ValueNotifier(true);
  double total = 0;
  Future data() async {
    total = 0;
    for (int i = 0; i < item_cash.length; i++) {
      var x = await DatabaseHelper.retrieveMoney(item_cash[i]);
      total += x.quantity * x.amount;
    }
    _notifier.value = !_notifier.value;
  }

  @override
  initState() {
    print("initState Called");
    data();
  }

  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thumbVisibility: true,
        controller: _firstController,
        child: SingleChildScrollView(
          child: Column(children: [
            Card(
              elevation: 0.0,
              clipBehavior: Clip.antiAlias,
              child: AnimatedContainer(
                  height: widget.selected[0] == "0" ? 400 : 95,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            if (widget.selected[0] == "0")
                              widget.selected[0] = "1";
                            else
                              widget.selected[0] = "0";
                            setState(() {});
                          },
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.money),
                              title: Text('Cash'),
                              subtitle: ValueListenableBuilder(
                                  valueListenable: _notifier,
                                  builder: (BuildContext context, bool val,
                                      Widget? child) {
                                    return Text(total.toString());
                                  }),
                              trailing: widget.selected[0] == "1"
                                  ? Icon(Icons.arrow_forward_ios)
                                  : Icon(Icons.arrow_downward),
                            ),
                          )),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              // Create an instance of the ScrollBar class
                              // Use the instance to access the 'v' variable

                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return FutureBuilder(
                                    future: DatabaseHelper.retrieveMoney(
                                        item_cash[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return _buildGuestsQuanitySelector(
                                            context,
                                            item_cash[index],
                                            snapshot.data!.quantity,
                                            snapshot.data!.amount, () {
                                          setState(() {
                                            if (snapshot.data!.quantity <= 0) {
                                              return;
                                            }
                                            MoneyItem toupdate = MoneyItem(
                                                id: snapshot.data!.id,
                                                name: snapshot.data!.name,
                                                quantity:
                                                    snapshot.data!.quantity - 1,
                                                amount: snapshot.data!.amount);
                                            print(toupdate.amount);
                                            DatabaseHelper.updateMoney(
                                                toupdate);
                                            data();
                                          });
                                        }, () {
                                          setState(() {
                                            MoneyItem toupdate = MoneyItem(
                                                id: snapshot.data!.id,
                                                name: snapshot.data!.name,
                                                quantity:
                                                    snapshot.data!.quantity + 1,
                                                amount: snapshot.data!.amount);
                                            DatabaseHelper.updateMoney(
                                                toupdate);
                                            data();
                                          });
                                        });
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    });
                              });
                            },
                            itemCount: item_cash.length),
                      )
                    ],
                  )),
            ),
            Card(
              elevation: 0.0,
              clipBehavior: Clip.antiAlias,
              child: AnimatedContainer(
                  height: widget.selected[1] == "0" ? 460 : 95,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: Column(children: [
                    InkWell(
                        onTap: () {
                          if (widget.selected[1] == "0")
                            widget.selected[1] = "1";
                          else
                            widget.selected[1] = "0";

                          setState(() {});
                        },
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.money),
                            title: Text('Online'),
                            subtitle: Text('Online'),
                            trailing: widget.selected[1] == "1"
                                ? Icon(Icons.arrow_forward_ios)
                                : Icon(Icons.arrow_downward),
                          ),
                        )),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return FutureBuilder(
                              future: DatabaseHelper.retrieveMoney("paytm"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return _buildonline(
                                      "PAYTM",
                                      snapshot.data!.quantity,
                                      snapshot.data!.amount, () {
                                    setState(() {});
                                  }, snapshot.data!);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              });
                        }),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return FutureBuilder(
                              future: DatabaseHelper.retrieveMoney("uco"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return _buildonline(
                                      "UCO",
                                      snapshot.data!.quantity,
                                      snapshot.data!.amount, () {
                                    setState(() {});
                                  }, snapshot.data!);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              });
                        }),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return FutureBuilder(
                              future: DatabaseHelper.retrieveMoney("sbi"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return _buildonline(
                                      "SBI",
                                      snapshot.data!.quantity,
                                      snapshot.data!.amount, () {
                                    setState(() {});
                                  }, snapshot.data!);
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              });
                        }),
                      ],
                    )
                  ])),
            ),
          ]),
        ));
  }

  Container _buildonline(String title, int quantity, double amount,
      VoidCallback refresh, MoneyItem Recieved) {
    final item = TextEditingController();
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          border: BorderDirectional(bottom: BorderSide(), top: BorderSide())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(title, style: textTheme.bodyLarge),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 50,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            amount.toString(),
                            style: textTheme.bodyLarge,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 130,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(title + " "),
                                        content: const Text("Add Amount"),
                                        actions: [
                                          TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Amount',
                                              label: Text("Amount"),
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            controller: item,
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    MoneyItem toupdate =
                                                        MoneyItem(
                                                            id: Recieved.id,
                                                            name: Recieved.name,
                                                            quantity: Recieved
                                                                .quantity,
                                                            amount: Recieved
                                                                    .amount +
                                                                double.parse(
                                                                    item.text));
                                                    DatabaseHelper.updateMoney(
                                                        toupdate);
                                                    Navigator.pop(context);
                                                    refresh();
                                                  },
                                                  child: const Text("Add")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Close"))
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.add_circle_outline),
                              label: Text("ADD")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 130,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(title + " "),
                                        content: const Text("Spent Amount"),
                                        actions: [
                                          TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Amount',
                                              label: Text("Amount"),
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            controller: item,
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    MoneyItem toupdate =
                                                        MoneyItem(
                                                            id: Recieved.id,
                                                            name: Recieved.name,
                                                            quantity: Recieved
                                                                .quantity,
                                                            amount: Recieved
                                                                    .amount -
                                                                double.parse(
                                                                    item.text));
                                                    DatabaseHelper.updateMoney(
                                                        toupdate);
                                                    Navigator.pop(context);
                                                    refresh();
                                                  },
                                                  child: const Text("Spent")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Close"))
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.remove_circle_outline_sharp),
                              label: Text("REMOVE")),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildGuestsQuanitySelector(
    BuildContext context,
    String title,
    int quantity,
    double amount,
    VoidCallback onDecrement,
    VoidCallback onIncrement,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.bodyLarge),
              Text((amount * quantity).toString(), style: textTheme.bodySmall),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove),
              ),
              Text(
                quantity.toString(),
                style:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  onIncrement();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
