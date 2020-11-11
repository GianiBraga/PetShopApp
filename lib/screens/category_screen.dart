import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petshop_app/datas/service_data.dart';
import 'package:petshop_app/tiles/service_title.dart';

class CategoryScreen extends StatelessWidget {
  //Buscando o docuemto da categoria.
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          snapshot.data["title"],
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      //Obetendo os dados do firebase e passando no ListView
      body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("services")
              .document(snapshot.documentID)
              .collection("items")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple)));
            else {
              return ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    ServiceData data = ServiceData.fromDocument(
                        snapshot.data.documents[index]);
                    data.category = this.snapshot.documentID;
                    return ServiceTitle(data);
                  });
            }
          }),
    );
  }
}
