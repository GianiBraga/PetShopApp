import 'package:flutter/material.dart';
import 'package:petshop_app/datas/cart_service.dart';
import 'package:petshop_app/datas/service_data.dart';
import 'package:petshop_app/model/cart_model.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/cart_screen.dart';
import 'package:petshop_app/screens/login_screen.dart';

class ServiceScreen extends StatefulWidget {
  final ServiceData service;

  ServiceScreen(this.service);

  @override
  _ServiceScreenState createState() => _ServiceScreenState(service);
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceData service;
  String schedule;

  DateTime _dataInfo = DateTime.now();
  String data = '';

  _ServiceScreenState(this.service);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text(service.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                service.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
              ),
              Text(
                "R\$ ${service.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Selecione o Horário: ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 34.0,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5,
                  ),
                  //Mapeando o horario do firebase
                  children: service.schedules.map((s) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          schedule = s;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(
                            color:
                                s == schedule ? primaryColor : Colors.grey[500],
                            width: 3.0,
                          ),
                        ),
                        width: 50.0,
                        alignment: Alignment.center,
                        child: Text(
                          s,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Text(
                "Selecione a Data: ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              FlatButton(
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.date_range,
                      size: 30,
                    ),
                    SizedBox(
                      width: 35.0,
                    ),
                    //Colocar uma validação caso o  product.date for null mostrar pra selecionar a data,
                    //senão mostrar o texto que a data já foi selecionada.
                    Text(
                        "${_dataInfo.day}-${_dataInfo.month}-${_dataInfo.year}",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
                //Criar uma validação pra bloquear o botão quando for selecionado uma data
                onPressed: () async {
                  final dtPick = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (dtPick != null && dtPick != _dataInfo) {
                    setState(() {
                      _dataInfo = dtPick;
                      data = "${dtPick.day}-${dtPick.month}-${dtPick.year}";
                    });
                    service.date = data;
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: schedule != null
                      ? () {
                          //Se usuario estiver logado vai adicionar no agendamento
                          if (UserModel.of(context).isLoggedIn()) {
                            CartService cartService = CartService();
                            cartService.schedule = schedule;
                            cartService.quantity = 1;
                            cartService.sid = service.id;
                            cartService.category = service.category;
                            cartService.date = service.date;
                            cartService.serviceData = service;

                            CartModel.of(context).addCartItem(cartService);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CartScreen()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          }
                        }
                      : null,
                  child: Text(
                    UserModel.of(context).isLoggedIn()
                        ? "Adicionar ao Agendamento"
                        : "Entre para Adicionar",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                  ),
                  color: primaryColor,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Descrição:",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}
