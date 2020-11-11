import 'package:cloud_firestore/cloud_firestore.dart';

class PetData{

    String id;
    String nome;
    String sexo;
    String raca;
    String tamanho;


    PetData();

    PetData.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    nome = document.data["nome"];
    sexo = document.data["sexo"];
    raca = document.data["raca"];
    tamanho = document.data["tamanho"];
  }

Map<String, dynamic> toMap(){
      return {
        "nome": nome,
        "sexo" : sexo,
        "raca" : raca,
        "tamanho" : tamanho
      };

}
}