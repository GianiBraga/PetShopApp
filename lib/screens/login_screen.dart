import 'package:flutter/material.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/home_screen.dart';
import 'package:petshop_app/screens/recover_screen.dart';
import 'package:petshop_app/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Entrar",
          ),
          centerTitle: true,
          // Criar um Action para voltar a pagina anterior.
        ),
        //Toda parte que está abaixo do Scopedmodel será reconstruida, de acordo com o usuario.
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.purple)),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: Image.asset("assets/logo.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: Key('enterEmail'),
                    controller: _emailController,
                    validator: (text) {
                      if (text.isEmpty || text.contains("@"))
                        return "E-mail Inválido!";
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "E-mail",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: Key('enterSenha'),
                    controller: _passController,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha Inválida!";
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        )),
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                        child: Text(
                          "Recuperar Senha",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecoverSreen(),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 1],
                        colors: [
                          Color.fromARGB(255, 135, 27, 112),
                          Color.fromARGB(255, 205, 100, 182)
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              child: SizedBox(
                                child: Image.asset("assets/bone.png"),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ],
                        ),
                        key: Key('login'),
                        onPressed: () => {
                          if (_formKey.currentState.validate())
                            {}
                          else
                            {
                              model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSucess,
                                onFail: _onFail,
                              )
                            }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 1],
                        colors: [
                          Color.fromARGB(255, 135, 27, 112),
                          Color.fromARGB(255, 205, 100, 182)
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Login com Facebook",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              child: SizedBox(
                                child: Image.asset("assets/fb-icon.png"),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          model.sigInFacebook();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: FlatButton(
                      child: Text(
                        "Cadastre-se",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSucess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          "Falha ao Acessar!",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
