import 'package:flutter/material.dart';
import 'package:petshop_app/tabs/home_tab.dart';
import 'package:petshop_app/tabs/orders_tab.dart';
import 'package:petshop_app/tabs/pets_tab.dart';
import 'package:petshop_app/tabs/products_tab.dart';
import 'package:petshop_app/widgets/cart_button.dart';
import 'package:petshop_app/widgets/custom_drawer.dart';
import 'package:petshop_app/widgets/pet_button.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Serviços"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Pets"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: PetButton(),
          body: PetsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Agendamentos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
