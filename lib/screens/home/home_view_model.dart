import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';

import '../../model/response.dart';
import '../../services/api_service.dart';

class HomeViewModel extends BaseViewModel {
  List<Items> responseData = [];

  List menu = [];
  List<TableMenuList> menuList = [];
  List<CategoryDishes> categoryDish = [];

  TabController? tabController;

  final GoogleSignIn _googleSignIn = GoogleSignIn();


  List<CategoryDishes> cartModel = [];

  int cartCount = 0;

  getItem() async {

    categoryDish.clear();
    menuList.clear();
    cartModel.clear();
    cartCount = 0;

    ApiService api = ApiService();
    responseData = await runBusyFuture(
      api.getResponse(),
    );
    for (var res in responseData) {
      menuList.addAll(res.tableMenuList as Iterable<TableMenuList>);
    }
    getCatDish(0);
  }

  getCatDish(int index) {
    categoryDish.addAll(menuList[index].categoryDishes as Iterable<CategoryDishes>);
    notifyListeners();
  }

  addToCart(CategoryDishes cat) {
    cat.qty = 1;
    cartModel.add(cat);
    cartCount = cartModel.length;
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
    cartCount = cartModel.length;
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
  void signOutGoogle() async{
    await _googleSignIn.signOut();
    print("User Sign Out");
  }
}
