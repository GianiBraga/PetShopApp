import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petshop_app/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      //Obtendo os dados do Firebase
      future: Firestore.instance.collection("services").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple)),
          );
        else {
          //Troca os documentos recebidos em um categoryTile e após transforma em uma lista.
          //Colocado dentro de um dividedTiles para poder ficar dividida as informações.
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((doc) {
                    return CategoryTile(doc);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
