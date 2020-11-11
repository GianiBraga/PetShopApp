import 'package:flutter/material.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_fonts/google_fonts.dart';

class RecoverSreen extends StatefulWidget {
  @override
  _RecoverSreenState createState() => _RecoverSreenState();
}

class _RecoverSreenState extends State<RecoverSreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Recuperar senha',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Container(
          padding: EdgeInsets.only(
            top: 40,
            left: 40,
            right: 40,
          ),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/reset-password-icon.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Esqueceu sua senha?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Por favor, informe o seu e-mail para enviarmos uma nova senha.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: _formKey,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                validator: (text) {
                  if (text.isEmpty || text.contains("@"))
                    return "E-mail Inválido!";
                },
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
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
                    child: Text(
                      "Enviar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      model.recoverPass(emailController.text);
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Confira seu e-mail!"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
