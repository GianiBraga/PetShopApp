import 'package:flutter/material.dart';
import 'package:petshop_app/datas/cart_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petshop_app/datas/service_data.dart';
import 'package:petshop_app/model/cart_model.dart';

class CartTile extends StatelessWidget {
  //Construtor vai receber um cartProduct
  final CartService cartService;

  CartTile(this.cartService);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartService.serviceData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartService.serviceData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Horario: ${cartService.schedule}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Data: ${cartService.date}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "R\$ ${cartService.serviceData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FlatButton(
                    child: Text("Remover"),
                    textColor: Colors.grey[500],
                    onPressed: () {
                      CartModel.of(context).removeCartItem(cartService);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    //Se ainda não tem esses dados armazenados no productData, busca no firebase e salva eles no productData
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartService.serviceData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("services")
                    .document(cartService.category)
                    .collection("items")
                    .document(cartService.sid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartService.serviceData =
                        ServiceData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
