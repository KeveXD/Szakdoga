import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/model/query_service.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:flutter/material.dart';
import 'package:buxa/widgets/payment_list_item.dart';
import 'package:buxa/data_model/payment_data_model.dart';

class QueryDetailsPage extends StatefulWidget {
  final QueryService queryService;

  QueryDetailsPage({required this.queryService});

  @override
  _QueryDetailsPageState createState() => _QueryDetailsPageState();
}

class _QueryDetailsPageState extends State<QueryDetailsPage> {
  late Future<List<PaymentDataModel>> _debtsFuture;

  @override
  void initState() {
    super.initState();
    _debtsFuture = widget.queryService.calculatePayments();
  }

  void _refreshPayments() {
    setState(() {
      _debtsFuture = widget.queryService.calculatePayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C4787),
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
        title: Text('Szűrt bevételek/kiadások'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List<PaymentDataModel>>(
                  future: _debtsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Hiba történt: ${snapshot.error}'));
                    } else {
                      final payments = snapshot.data;

                      if (payments == null || payments.isEmpty) {
                        return Center(child: Text('Nincsenek adatok.'));
                      }

                      return ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return PaymentListItem(
                            payment: payment,
                            onDelete: () {
                              _refreshPayments();
                            },
                            onEdit: () {
                              // Ezt ide helyezd el, hogy mit csinál a szerkesztés gomb.
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Desk(
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
                  title: 'Vissza',
                  function: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  final QueryService _queryService = QueryService();

  runApp(MaterialApp(
    home: QueryDetailsPage(queryService: _queryService),
  ));
}
