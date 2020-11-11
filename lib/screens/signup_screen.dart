import 'package:flutter/material.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Cadastre-se",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      //Toda parte que está abaixo do Scopedmodel será reconstruida, de acordo com o usuario.
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.purple),
            ),
          );
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Colors.grey[300],
                      size: 160,
                    ),
                  ]),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nome Completo",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Nome Inválido!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty) return "E-mail Inválido!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty || text.length < 6) return "Senha Inválida!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                      };

                      model.signUp(
                        userData: userData,
                        pass: _passController.text,
                        onSuccess: _onSucess,
                        onFail: _onFail,
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário cadastrado com Sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao cadastrar Usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
