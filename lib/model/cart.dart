class CartModel {
  String? dishId;
  String? dishName;
  int? dishPrice;
  int? dishCalories;
  int? dishType;
  int? qty;

  CartModel(
      {this.dishId, this.dishName, this.dishPrice, this.dishCalories, this.dishType, this.qty});

  CartModel.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishCalories = json['dish_calories'];
    dishType = json['dish_Type'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dish_id'] = dishId;
    data['dish_name'] = dishName;
    data['dish_price'] = dishPrice;
    data['dish_calories'] = dishCalories;
    data['dish_Type'] = dishType;
    data['qty'] = qty;
    return data;
  }
}
