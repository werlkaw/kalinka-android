import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'models/order.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalinka',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Kalinka Orders'),
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

class OrderWidget extends StatefulWidget {

  final Order order;

  OrderWidget(this.order);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  double _height = 0;
  String dropdownValue = "Responder";

  Row orderNameAndItems() {
    StringBuffer itemsText = StringBuffer();
    widget.order.items.forEach((orderItem) {
      itemsText.writeln(orderItem.quantity.toString() +
          ' ' +
          orderItem.menuItem);
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ListTile(
              title: Text(widget.order.userName + " (" + widget.order.userId + ")"),
              subtitle: Padding(
                  child: Text(itemsText.toString()),
                  padding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
//          Container(
//            width: 100,
//            child: DropdownButton<String>(
//              value: dropdownValue,
//              icon: Icon(Icons.arrow_downward),
//              iconSize: 24,
//              elevation: 16,
//              style: TextStyle(
//                  color: Colors.deepPurple
//              ),
//              underline: Container(
//                height: 2,
//                color: Colors.deepPurpleAccent,
//              ),
//              onChanged: (String newValue) {
//                setState(() {
//                  dropdownValue = newValue;
//                });
//              },
//              items: <String>[
//                'Responder',
//                'Su orden ya está lista!',
//                'Su orden estará lista a las 2pm',
//                'Su orden estará lista a las 11am mañana']
//                  .map<DropdownMenuItem<String>>((String value) {
//                return DropdownMenuItem<String>(
//                  value: value,
//                  child: Text(value),
//                );
//              })
//                  .toList(),
//            )
//          ),
        ]);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: orderNameAndItems(),
      color: Colors.amberAccent,
      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
      margin: EdgeInsets.only(bottom: 1)
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Widget> orders = [];

  _MyHomePageState() {
    _updateList();
    var updateListFunc = (Event event) {
      developer.log(event.toString());
      _updateList();
    };
    DatabaseReference orders =
        FirebaseDatabase.instance.reference().child('orders');
    orders.onChildChanged.listen(updateListFunc);
    orders.onChildAdded.listen(updateListFunc);
    orders.onChildMoved.listen(updateListFunc);
    orders.onChildRemoved.listen(updateListFunc);

  }

  void _updateList() {
    FirebaseDatabase.instance
        .reference()
        .child('orders')
        .once()
        .then((snapshot) {
          developer.log(snapshot.value.toString());
          List<OrderWidget> tmpOrders = [];
          snapshot.value.keys.forEach((key) {
            Order currentOrder = Order.fromMap(key, snapshot.value[key]);
            if (currentOrder.completed) {
              OrderWidget orderWidget = OrderWidget(currentOrder);
              tmpOrders.add(orderWidget);
            }
          });
          setState(() {
            orders = tmpOrders;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView(
          children: orders,
        ),
        color: Colors.black12
      )
    );
  }
}
