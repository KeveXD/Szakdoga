import 'package:flutter/material.dart';
import 'package:buxa/data_model/person_data_model.dart';
import 'package:buxa/viewmodel/person_list_item_viewmodel.dart';

class PersonListItem extends StatelessWidget {
  final PersonDataModel person;
  final PersonListItemViewModel viewModel = PersonListItemViewModel();
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  PersonListItem({
    required this.person,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            // Bal felső sarok: Profilkép vagy helyettesítő szöveg
            Container(
              width: 48, // Állítsd be a megfelelő méretre
              height: 48, // Állítsd be a megfelelő méretre
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: person.profileImage != null
                      ? AssetImage(person.profileImage)
                      : AssetImage('assets/revolut.png'), // Helyettesítő kép
                ),
              ),
            ),
            SizedBox(width: 8), // Szükséges tér az elemek között
            // Bal oldali oszlop
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Név:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  person.name,
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  person.email,
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Spacer(),
            // Jobb oldali oszlop
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: person.hasRevolut ? Colors.green : Colors.red,
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    viewModel
                        .deletePerson(person.id ?? -1, person.name)
                        .then((result) {
                      onDelete();
                    });
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
