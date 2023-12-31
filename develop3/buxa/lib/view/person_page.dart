import 'package:flutter/material.dart';
import 'package:buxa/viewmodel/person_viewmodel.dart';
import 'package:buxa/widgets/person_list_item.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/widgets/new_person_dialog.dart';
import 'package:buxa/data_model/person_data_model.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late Future<List<PersonDataModel>> _personFuture;
  late PersonViewModel viewModel;

  @override
  void initState() {
    super.initState();
    //_personFuture = viewModel.peopleFuture();
    //_refreshPockets();
    viewModel = PersonViewModel(context);
    viewModel.loadPeople(context);
  }

  void _refreshPeople() {
    setState(() {
      //viewModel.refreshPeople(context);
      viewModel.loadPeople(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C4787),
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
        title: Text('Személyek'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PersonDataModel>>(
              future: viewModel.peopleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final people = snapshot.data;

                  if (people == null || people.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }

                  return ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final person = people[index];
                      return PersonListItem(
                        person: person,
                        onDelete: () {
                          _refreshPeople();
                        },
                        onEdit: () {
                          // Handle edit action here
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Desk(
            buttons: [
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.menu,
                title: 'Menü',
                function: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.arrow_back,
                title: 'Tartozások',
                function: () {
                  Navigator.pop(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.add,
                title: 'Új Név',
                function: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NewPersonDialog(
                        onAddNewPerson: () {
                          _refreshPeople();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );

                  //itt nem újulnak meg a listItemek
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PersonPage(),
  ));
}
