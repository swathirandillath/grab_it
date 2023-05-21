import 'package:grab_it/model/response.dart';
import 'package:stacked/stacked.dart';

class CartViewModel extends BaseViewModel {
  List<CategoryDishes> cartModel;
  CartViewModel(this.cartModel);

  addToCart(CategoryDishes cat) {
    cat.qty = 1;
    cartModel.add(cat);
    //cartCount = cartModel.length;
    notifyListeners();
  }

  removeCart(CategoryDishes cat) {
    cat.qty = 0;
    int i = 0;
    for (var cart in cartModel) {
      if (cart.dishId == cat.dishId) {
        cartModel.removeAt(i);
        break;
      }
      i++;
    }
    notifyListeners();
  }

  updateCart(
    CategoryDishes cat,
    int qty,
  ) {
    for (var cart in cartModel) {
      if (cart.dishId == cat.dishId) {
        cart.qty = qty;
        break;
      }
    }
    notifyListeners();
  }

  getTotal() {
    num total = 0;
    for (var cart in cartModel) {
      total = total + (((cart.dishPrice ?? 0) * 22) * cart.qty);
    }
    return total;
  }
}
