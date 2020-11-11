import 'package:flutter/material.dart';
import 'package:petshop_app/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:petshop_app/model/pet_model.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/tiles/pet_tile.dart';

class PetsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ScopedModelDescendant<PetModel>(
        builder: (context, child, model) {
          //Se está carregando e está logado
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(Colors.purple)),
            );
            //Se o usuario não está logado, vai retornar a mensagem para fazer login
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.pets,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Faça Login para adicionar pets!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            );
            //Se a lista de serviços for nula ou nenhum serviço adicionado.
          } else if (model.pet == null || model.pet.length == 0) {
            return Center(
              child: Text(
                "Nenhum Pet adicionado!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
            
            //Condição se tiver serviços adicionados
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  //Mapeando os serviços, transformando cada um dos serviços em um CartTile.
                    children: model.pet.map((pet) {
                  return PetTile(pet);
                }).toList()
                ),
                
              ],
            );
          }
        },
      ),
    );
  }
}