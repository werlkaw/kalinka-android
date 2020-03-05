import 'package:firebase_database/firebase_database.dart';
import 'order_item.dart';

class Order {
  String key;
  String userId;
  String userName;
  bool completed;
  int expiration;
  List<OrderItem> items;

  Order(this.userId, this.userName, this.completed, this.expiration,
      this.items);

  Order.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        userName = snapshot.value["userName"],
        completed = snapshot.value["completed"],
        expiration = snapshot.value["expiration"],
        items = OrderItem.castFromDynamicList(snapshot.value["items"]);

  Order.fromMap(dynamic key, Map<dynamic, dynamic> orderMap) :
        this.key = key,
        userId = orderMap['userId'],
        userName = orderMap["userName"],
        completed = orderMap['completed'],
        expiration = orderMap['expiration'],
        items = OrderItem.castFromDynamicList(orderMap['items']);

  toJson() {
    return {
      "userId": userId,
      "completed": completed,
      "expiration": expiration,
      "items": items
    };
  }
}