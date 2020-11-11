import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/login_screen.dart';
import 'package:petshop_app/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          key: Key('drawer'),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 73, 8, 59),
                Color.fromARGB(255, 205, 100, 182),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(65)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.74,
        child: Drawer(
          child: Stack(
            children: <Widget>[
              _buildDrawerBack(),
              ListView(
                padding: EdgeInsets.only(left: 32.0, top: 16.0),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                    height: 170.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Text(
                            "Portal \nPetshop",
                            style: TextStyle(
                                fontSize: 34.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          //COlodado dentro do scoppedModel para poder verificar se o usuario está logado ou não.
                          child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      !model.isLoggedIn()
                                          ? "Entre ou cadastre-se "
                                          : "Sair",
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    key: Key('login'),
                                    onTap: () {
                                      if (!model.isLoggedIn())
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      else
                                        model.signOut();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  //Cada vez que clica em cima de um dos itens do Drawer, recebe as informações do Drwaer title
                  DrawerTile(Icons.home, "Inicio", pageController, 0),
                  DrawerTile(Icons.list, "Serviços", pageController, 1),
                  DrawerTile(Icons.pets, "Meus Pets", pageController, 2),
                  DrawerTile(Icons.playlist_add_check, "Meus Agendamentos",
                      pageController, 3),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
