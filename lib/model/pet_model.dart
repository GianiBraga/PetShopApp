import 'package:flutter/material.dart';
import 'package:petshop_app/datas/pet_data.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel extends Model {
  UserModel user;

  List<PetData> pet = [];
  bool isLoading = false;

  PetModel(this.user) {
    if (user.isLoggedIn()) loadPets();
  }

  static PetModel of(BuildContext context) => ScopedModel.of<PetModel>(context);

  //Adicionando um novo pet no firebase
  void addPet(PetData petData) {
    pet.add(petData);

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("pets")
        .add(petData.toMap())
        .then((doc) {
      petData.id = doc.documentID;
    });

    notifyListeners();
  }

  // removendo o pet do usuario
  void removePet(PetData petData) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("pets")
        .document(petData.id)
        .delete();

    //metodo com problema, verificar
    pet.remove(pet);

    notifyListeners();
  }

  // Carregando os pets do usuario
  void loadPets() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("pets")
        .getDocuments();

    pet = query.documents.map((doc) => PetData.fromDocument(doc)).toList();

    notifyListeners();
  }
}
