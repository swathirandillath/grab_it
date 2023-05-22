import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:grab_it/screens/cart/cart_view.dart';
import 'package:grab_it/screens/splash/splash_view.dart';
import 'package:grab_it/screens/utils/globals.dart' as globals;
import 'package:stacked/stacked.dart';

import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List menuList = [];
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.getItem(),
      builder: (context, model, child) {
        List<Tab> tabs = <Tab>[];
        for (int i = 0; i < model.menuList.length; i++) {
          tabs.add(Tab(
            child: Text(
              model.menuList[i].menuCategory.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ));
        }
        return DefaultTabController(
          length: model.menuList.length,
          child: Builder(builder: (context) {
            /*model.tabController = DefaultTabController.of(context)!;
            model.tabController?.addListener(() {
              if (!(model.tabController?.indexIsChanging ?? false)) {
                print('TAB INDEX: ${model.tabController?.index}');
                //model.getCatDish(model.tabController?.index ?? 0);
              }
            });*/
            return Scaffold(
              key: _key,
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                ),
                backgroundColor: Colors.white,
                actions: [
                  InkWell(
                    onTap: () {
                      if (model.cartModel.isNotEmpty) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    CartView(cartModel: model.cartModel)))
                            .then((completion) {
                          print('Order Place : ${globals.orderPlaced}');
                          if (globals.orderPlaced) {
                            globals.orderPlaced = false;
                            model.getItem();
                          }
                        });
                      } else {
                        const snackBar = SnackBar(
                          content: Text('No items in cart'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: badges.Badge(
                        badgeContent: Text(
                          model.cartCount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
                bottom: TabBar(
                  //controller: model.tabController,
                  isScrollable: true,
                  tabs: tabs,
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
              body: TabBarView(
                children: model.menuList
                    .map((e) => ListView.separated(
                          itemCount: e.categoryDishes?.length ?? 0,
                          itemBuilder: (context, index) {
                            var cat = e.categoryDishes![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: cat.dishType == 1
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(cat.dishName ?? ''),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "INR ${(cat.dishPrice ?? 0) * 22}"),
                                            Text(
                                                "${(cat.dishCalories ?? 0)} Calories")
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(cat.dishDescription ?? ''),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              cat.qty == 0
                                                  ? const SizedBox()
                                                  : IconButton(
                                                      onPressed: () {
                                                        cat.qty == 1
                                                            ? model
                                                                .removeCart(cat)
                                                            : model.updateCart(
                                                                cat, --cat.qty);
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      )),
                                              Text(
                                                cat.qty.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    cat.qty == 0
                                                        ? model.addToCart(cat)
                                                        : model.updateCart(
                                                            cat, ++cat.qty);
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        cat.addonCat?.isNotEmpty ?? false
                                            ? const Text(
                                                "Customization available",
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  LimitedBox(
                                    maxHeight: 80,
                                    maxWidth: 80,
                                    child: Image.network(cat.dishImage ?? '',
                                        color: Colors.grey,
                                        width: 80,
                                        height: 80,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                      return const CircularProgressIndicator();
                                    }),
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
                        ))
                    .toList(),
              ),
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.brown.shade800,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: globals.displayName.isEmpty
                                    ? const Text("XX")
                                    : Image.network(globals.displayName)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(globals.userMobile ?? ''),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('ID : ${globals.uid ?? ''}'),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        model.signOutGoogle();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashView()),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
