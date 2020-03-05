class OrderItem {
  String menuItem;
  int quantity;

  OrderItem(this.menuItem, this.quantity);

  factory OrderItem.fromJson(dynamic jsonInput) {
    return OrderItem(jsonInput['menuItem'], jsonInput['quantity']);
  }

  static List<OrderItem> castFromDynamicList(List<dynamic> input) {
    List<OrderItem> out = [];
    input.forEach((elem) {
      out.add(OrderItem.fromJson(elem));
    });
    return out;
  }
}