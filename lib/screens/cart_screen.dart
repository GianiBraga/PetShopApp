import 'package:flutter/material.dart';
import 'package:petshop_app/model/cart_model.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/login_screen.dart';
import 'package:petshop_app/screens/order_sreen.dart';
import 'package:petshop_app/tiles/cart_tile.dart';
import 'package:petshop_app/widgets/cart_price.dart';
import 'package:petshop_app/widgets/discount_card.dart';
import 'package:petshop_app/widgets/pet_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalizar serviços"),
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          //Se está carregando e está logado
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.purple)),
            );
            //Se o usuario não está logado, vai retornar a mensagem para fazer login
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Faça Login para adicionar serviços!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            );
            //Se a lista de serviços for nula ou nenhum serviço adicionado.
          } else if (model.service == null || model.service.length == 0) {
            return Center(
              child: Text(
                "Nenhum serviço adicionado!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
            //Condição se tiver serviços adicionados
          } else {
            return ListView(
              children: <Widget>[
                Column(
                    //Mapeando os serviços, transformando cada um dos serviços em um CartTile.
                    children: model.service.map((service) {
                  return CartTile(service);
                }).toList()),
                DiscountCard(),
                PetCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();

                  if (orderId != null)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => OrderScreen(orderId)),
                    );

                  // Verificar uma maneira de voltar para a tela HomeScreen
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
