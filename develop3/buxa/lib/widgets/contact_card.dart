import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String email;
  final bool hasDebt;
  final String imagePath;

  ContactCard({
    required this.name,
    required this.email,
    required this.hasDebt,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            title: Text(name),
            subtitle: Text(email),
            trailing: IconButton(
              icon: Icon(
                Icons.settings, // Beállítás ikon
                color: Colors.grey,
              ),
              onPressed: () {
                // Ezt ide helyezd el, hogy mit csinál a beállítások gomb.
              },
            ),
          ),
        ],
      ),
    );
  }
}
