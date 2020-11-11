import 'package:flutter/material.dart';
import 'package:petshop_app/model/cart_model.dart';
import 'package:petshop_app/model/pet_model.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:petshop_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Trazendo o Model para a main, assim é possivel acessar o model de usuario de qualquer lugar do app.
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        //Colocando o Model do agendamento para ter acesso nos usuarios.
        return ScopedModel<CartModel>(
            model: CartModel(model),
            child: ScopedModel<PetModel>(
              model: PetModel(model),
              child: MaterialApp(
                title: 'Petshop',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Colors.purple,
                  cursorColor: Colors.purple,
                ),
                debugShowCheckedModeBanner: false,
                home: LoginScreen(),
              ),
            ));
      }),
    );
  }
}
