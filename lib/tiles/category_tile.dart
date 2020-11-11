import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petshop_app/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  //Buscando os documentos no firebase e passando pro categorytile com os dados
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (contex) => CategoryScreen(snapshot)));
      },
      child: Card(
        elevation: 50.0,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(
                snapshot.data["icon"],
                fit: BoxFit.cover,
                height: 80.0,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.data["title"],
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
