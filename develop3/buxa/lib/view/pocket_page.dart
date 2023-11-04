import 'package:flutter/material.dart';
import 'package:buxa/widgets/pocket_list_item.dart';
import 'package:buxa/widgets/new_pocket_dialog.dart';
import 'package:buxa/viewmodel/pocket_viewmodel.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

//fokusz nem jo

class PocketPage extends StatefulWidget {
  @override
  _PocketPageState createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  late Future<List<PocketDataModel>> _pocketsFuture;
  final PocketPageViewModel _viewModel;
  final FocusNode _scaffoldFocus = FocusNode();

  _PocketPageState() : _viewModel = PocketPageViewModel();

  @override
  void initState() {
    super.initState();
    _pocketsFuture = _viewModel.loadPockets();
    _refreshPockets();
  }

  void _refreshPockets() async {
    await _viewModel.loadPockets();
    setState(() {
      _scaffoldFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zsebek'),
        centerTitle: true,
      ),
      body: Focus(
        focusNode: _scaffoldFocus,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _viewModel.pockets.length,
          itemBuilder: (context, index) {
            return PocketListItem(
              pocket: _viewModel.pockets[index],
              onDelete: () {
                _viewModel.deletePocket(_viewModel.pockets[index]);
                _refreshPockets();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return NewPocketDialog(
                onAddNewPocket: () {
                  _viewModel.loadPockets();
                  _refreshPockets();
                  _scaffoldFocus.requestFocus();
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PocketPage(),
  ));
}
