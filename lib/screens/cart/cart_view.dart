import 'package:flutter/material.dart';
import 'package:grab_it/model/response.dart';
import 'package:grab_it/screens/utils/globals.dart' as globals;
import 'package:stacked/stacked.dart';

import 'cart_view_model.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key, required this.cartModel}) : super(key: key);
  final List<CategoryDishes> cartModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => CartViewModel(cartModel),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Order Summery",
            style: TextStyle(color: Colors.grey),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(children: [
          Expanded(
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff193f13),
                    ),
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        "${model.cartModel.length} Dishes - ${model.cartModel.length} Items",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: model.cartModel.length,
                    itemBuilder: (context, index) {
                      CategoryDishes cat = model.cartModel[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.square,
                              color: cat.dishType == 1 ? Colors.red : Colors.green,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.dishName ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "INR ${(cat.dishPrice ?? 0) * 22}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${(cat.dishCalories ?? 0)} Calories",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xff193f13),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  cat.qty == 0
                                      ? const SizedBox()
                                      : IconButton(
                                          onPressed: () {
                                            cat.qty == 1
                                                ? model.removeCart(cat)
                                                : model.updateCart(cat, --cat.qty);
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          )),
                                  Text(
                                    cat.qty.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        cat.qty == 0
                                            ? model.addToCart(cat)
                                            : model.updateCart(cat, ++cat.qty);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "INR ${(cat.qty * ((cat.dishPrice ?? 0) * 22))}",
                              style: TextStyle(
                                  color: Color(0xff193f13),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.grey,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "INR ${model.getTotal()}",
                          style: const TextStyle(
                              color: Color(0xff193f13), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              globals.orderPlaced = true;
              Future.delayed(const Duration(seconds: 1)).then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
              showPlaceOrderDialog(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xff193f13),
              ),
              width: double.infinity,
              height: 50,
              child: const Center(
                child: Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> showPlaceOrderDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            height: 100,
            child: const Center(
              child: Text(
                'Order Placed Successfully',
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
