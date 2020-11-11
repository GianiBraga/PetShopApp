import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petshop_app/datas/pet_data.dart';
import 'package:petshop_app/model/pet_model.dart';
import 'package:petshop_app/model/user_model.dart';

class PetTile extends StatelessWidget {
  UserModel user;
  FirebaseUser firebaseUser;

  final petData;

  PetTile(this.petData);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
              
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    petData.nome,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  Text(
                    "Raça: ${petData.raca}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Sexo: ${petData.sexo}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Tamanho: ${petData.tamanho}",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  FlatButton(
                    child: Text("Remover"),
                    textColor: Colors.grey[500],
                    onPressed: () {
                      PetModel.of(context).removePet(petData);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: petData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("users")
                    .document(user.firebaseUser.uid)
                    .collection("pets")
                    .document(petData.id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    petData.petData = PetData.fromDocument(snapshot.data);
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
