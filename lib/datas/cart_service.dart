import 'package:petshop_app/datas/service_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  String cid;
  String category;
  String sid;
  String date;

  int quantity;
  String schedule;

  //Os dados do serviço no agendamento
  ServiceData serviceData;

  CartService();
  //Construtor recebendo os serviços do firebase
  CartService.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    sid = document.data["sid"];
    quantity = document.data["quantity"];
    schedule = document.data["schedule"];
    date = document.data["date"];
  }

  //Adicionando no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "sid": sid,
      "quantity": quantity,
      "schedule": schedule,
      "date": date,
      "products": serviceData.toResumedMap()
    };
  }
}
