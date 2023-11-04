import 'package:flutter/material.dart';
import 'package:buxa/widgets/pocket_list_item.dart';
import 'package:buxa/widgets/new_pocket_dialog.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PocketPage extends StatefulWidget {
  @override
  _PocketPageState createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  // List to hold the pockets
  List<PocketDataModel> pockets = [];

  @override
  void initState() {
    super.initState();
    // Load pockets initially
    loadPockets();
  }

  Future<void> loadPockets() async {
    final pocketRepo = PocketRepository();
    final pocketList = await pocketRepo.getPocketList();
    setState(() {
      pockets = pocketList;
      pockets.add(PocketDataModel(name: 'Összes', special: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zsebek'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: pockets.length,
        itemBuilder: (context, index) {
          return PocketListItem(
            pocket: pockets[index],
            onDelete: () {
              deletePocket(pockets[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return NewPocketDialog(
                onAddNewPocket: () {
                  loadPockets();
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> deletePocket(PocketDataModel pocket) async {
    final pocketRepo = PocketRepository();
    await pocketRepo.deletePocket(pocket.id!);
    loadPockets();
  }
}

void main() {
  runApp(MaterialApp(
    home: PocketPage(),
  ));
}
