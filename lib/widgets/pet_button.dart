import 'package:flutter/material.dart';
import 'package:petshop_app/screens/pet_screen.dart';

class PetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.pets, color: Colors.white),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>PetScreen())
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
      
    );
  }
}