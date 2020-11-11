import 'package:flutter/material.dart';

class PetCard extends StatefulWidget {

 

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _sel = true;
  


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Selecionar Pet",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: <Widget>[
          CheckboxListTile(
            title: Text("Jairo"),
            activeColor: Colors.purple,
            secondary: const Icon(Icons.pets,color: Colors.grey,),
            onChanged: (bool resp){
                setState((){
                  _sel = resp;
                });
            },
            value: _sel,
          ) 
        ],
        leading: Icon(Icons.pets),
        trailing: Icon(Icons.add),
      ),
    );
  }
}
