import 'package:flutter/material.dart';
import 'package:petshop_app/datas/pet_data.dart';
import 'package:petshop_app/model/pet_model.dart';
import 'package:petshop_app/model/user_model.dart';
import 'package:petshop_app/screens/home_screen.dart';


class PetScreen extends StatefulWidget {
  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();

  final List<String> tamanhos = [
    'Pequeno',
    'Medio',
    'Grande',
  ];

  final List<String> sexos = [
    'Macho',
    'Fêmea',
  ];

  final List<String> racas = [
    'Poodle',
    'Boxer',
  ];

  String _currentTamanhos;
  String _currentSexo;
  String _currentRaca;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro de Pets"),
        centerTitle: true,
      ),
      body: //ScopedModelDescendant<PetModel>(builder: (context, child, model) {
          //if(model.isLoading)
          // return Center(child: CircularProgressIndicator(),);
          // return
          Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.pets,
                    color: Colors.grey[300],
                    size: 80,
                  ),
                ]),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Nome",
              ),
              validator: (text) {
                if (text.isEmpty) return "Nome Inválido!";
              },
            ),
            DropdownButtonFormField(
              value: _currentRaca ?? 'Poodle',
              items: racas.map((raca) {
                return DropdownMenuItem(
                  value: raca,
                  child: Text('$raca'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _currentRaca = val),
            ),
            SizedBox(
              height: 20,
              child: Text(
                "Selecione a Raça",
                style: TextStyle(color: Colors.purple[800]),
              ),
            ),
            DropdownButtonFormField(
              value: _currentSexo ?? 'Macho',
              items: sexos.map((sexo) {
                return DropdownMenuItem(
                  value: sexo,
                  child: Text('$sexo'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _currentSexo = val),
            ),
            SizedBox(
              height: 20,
              child: Text(
                "Selecione o sexo",
                style: TextStyle(color: Colors.purple[800]),
              ),
            ),
            DropdownButtonFormField(
              value: _currentTamanhos ?? 'Pequeno',
              items: tamanhos.map((tamanho) {
                return DropdownMenuItem(
                  value: tamanho,
                  child: Text('$tamanho'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _currentTamanhos = val),
            ),
            SizedBox(
              height: 50,
              child: Text(
                "Selecione o Tamanho",
                style: TextStyle(color: Colors.purple[800]),
              ),
            ),
            RaisedButton(
                child: Text(
                  "Cadastrar",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (UserModel.of(context).isLoggedIn()) {
                    PetData petData = PetData();
                    petData.nome = _nameController.text;
                    petData.sexo = _currentSexo;
                    petData.raca = _currentRaca;
                    petData.tamanho = _currentTamanhos;
                    PetModel.of(context).addPet(petData);

                   
                     Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                  }

                }),
          ],
        ),
      ),
    );
    // }
    // )
    //);
  }
}
