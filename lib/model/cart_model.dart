import 'package:flutter/cupertino.dart';
import 'package:petshop_app/datas/cart_service.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends Model {
  //Carregando a model do usuario
  UserModel user;

  //listando todos serviços do agendamento
  List<CartService> service = [];

  String cuponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //Carregando os agendamentos do usuario atual
  CartModel(this.user) {
    // Só vai carregar os itens do carrinho se tiver logado.
    if (user.isLoggedIn()) _loadCartItems();
  }

//Deifindo um metodo statico para poder utilizar o Model em outras telas
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  //Adicionando novo serviço no agendamento
  void addCartItem(CartService cartService) {
    service.add(cartService);
    //Adicionando no Firebase
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartService.toMap())
        .then((doc) {
      //Depois de adicionado pegado a referencia do Id que foi criado e adicionado ao cid
      cartService.cid = doc.documentID;
    });

    notifyListeners();
  }

  //Removendo serviço do agendamento
  void removeCartItem(CartService cartService) {
    //Removendo no firebase
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartService.cid)
        .delete();

    //pegando a lista de produtos e removendo
    service.remove(cartService);

    notifyListeners();
  }

//Função para atualizar os preços
  void updatePrices() {
    notifyListeners();
  }

  //Função para adicionar descontos.
  void setCoupon(String couponCode, int discountPercentage) {
    //Salvar o codigo do cupom
    this.cuponCode = couponCode;
    //salvando a porcentagem de desconto
    this.discountPercentage = discountPercentage;
  }

  //Função para somar os itens do carrinho
  double getProductPrice() {
    //Começando o preço em 0
    double price = 0.0;
    for (CartService c in service) {
      if (c.serviceData != null) {
        price += c.quantity * c.serviceData.price;
      }
    }
    return price;
  }

  //Função de desconto
  double getDiscount() {
    return getProductPrice() * discountPercentage / 100;
  }

  //Função para finalizar o agendamento
  Future<String> finishOrder() async {
    //Verificando se está vazio
    if (service.length == 0) return null;

    //Esta carregando e notificando os listeners
    isLoading = true;
    notifyListeners();

    //Pegando os preços.
    double servicesPrice = getProductPrice();
    double discount = getDiscount();

    //Criando a ordem de agendamento no firebase e obtendo a referencia refOrder
    DocumentReference refOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "services": service.map((cartProduct) => cartProduct.toMap()).toList(),
      "servicesPrice": servicesPrice,
      "discount": discount,
      "totalPrice": servicesPrice - discount,
      "status": 1
    });

    //Salvando a ordem no documento do usuario
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderID": refOrder.documentID});

    //Pegando referencia do agendamento para poder deletar em seguida
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    //Para cada documento será excluido
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    //Limpando todos campos
    service.clear();

    discountPercentage = 0;
    cuponCode = null;

    //Não está mais carregando e notificado os listners
    isLoading = false;
    notifyListeners();

    //Retornando o codigo do agendamento, para mostrar na tela.
    return refOrder.documentID;
  }

  //Função para carregar todos os itens do agendamento
  void _loadCartItems() async {
    //Buscando todos documentos do agendamento
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    //Transformando cada documento que obtiver no firebase em um CartService
    service =
        query.documents.map((doc) => CartService.fromDocument(doc)).toList();

    notifyListeners();
  }
}
