import 'package:flutter/material.dart';
import 'package:buxa/view/payment_page.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PocketListItem extends StatelessWidget {
  final PocketDataModel pocket;
  final Function() onDelete;

  PocketListItem({
    required this.pocket,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: pocket.special
                ? Container() // Ha special true, akkor nem jelenít meg gombot
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Zseb törlése'),
                            content: Text(
                                'Biztosan törölni szeretnéd a(z) ${pocket.name} zsebet?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Mégsem'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Törlés'),
                                onPressed: () {
                                  onDelete();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(pocket: pocket),
                    ),
                  );
                },
                child: Image.asset('assets/pocket.png', width: 80, height: 80),
              ),
              Text(
                pocket.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: pocket.special ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
