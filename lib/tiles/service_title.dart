import 'package:flutter/material.dart';
import 'package:petshop_app/datas/service_data.dart';
import 'package:petshop_app/screens/service_screen.dart';

class ServiceTitle extends StatelessWidget {
  final ServiceData service;

  ServiceTitle(this.service);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (contex) => ServiceScreen(service)));
      },
      child: Card(
        elevation: 50.0,
        child: Row(
          children: <Widget>[
            //Flexibel para definir a divisão da linha
            Flexible(
              flex: 1,
              child: Image.network(
                service.images[0],
                fit: BoxFit.cover,
                height: 80.0,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      service.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "R\$ ${service.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
