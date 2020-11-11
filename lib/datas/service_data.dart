import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceData {
  String category;
  String id;
  String description;
  String title;
  String date;

  double price;

  List images;
  List schedules;

  //Construtor recebendo o documento e armazenando nas variaveis declaradas acima.
  ServiceData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    images = snapshot.data["images"];
    schedules = snapshot.data["schedules"];
    date = snapshot.data["date"];
  }

  //Resumo do que será mostrado no acompanhamento dos meus agendamentos
  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "schedules": schedules,
      "date": date,
    };
  }
}
