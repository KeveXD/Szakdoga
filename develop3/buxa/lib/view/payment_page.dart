import 'package:flutter/material.dart';
import 'package:buxa/widgets/new_payment_dialog.dart';
import 'package:buxa/widgets/payment_list_item.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/viewmodel/payment_viewmodel.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/view/payment_details_page.dart';
import 'package:buxa/data_model/pocket_data_model.dart';

class PaymentPage extends StatefulWidget {
  final PocketDataModel pocket;

  PaymentPage({required this.pocket});

  @override
  _PaymentPageState createState() => _PaymentPageState(pocket: pocket);
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentViewModel viewModel;
  final PocketDataModel pocket;
  late Future<List<PaymentDataModel>> _paymentsFuture;
  List<PaymentDataModel> payments = [];

  _PaymentPageState({required this.pocket});

  void _showPaymentDetails(PaymentDataModel payment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentDetailsPage(payment: payment),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel = PaymentViewModel(context);
    viewModel.loadPayments(context, pocket);
    _paymentsFuture = viewModel.paymentsFuture;
  }

  void _refreshPayments() {
    setState(() {
      viewModel.loadPayments(context, pocket);
      _paymentsFuture = viewModel.paymentsFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C4787),
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
        title: Text('Befizetések és kiadások'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<PaymentDataModel>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hiba történt: ${snapshot.error}'));
                } else {
                  payments = snapshot.data ?? [];
                  if (payments.isEmpty) {
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
                          // Szerkesztés logika
                        },
                        onDetails: () {
                          _showPaymentDetails(payment);
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
                icon: Icons.wallet,
                title: 'Zsebek',
                function: () {
                  Navigator.pop(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.add,
                title: 'Új',
                function: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NewPaymentDialog(
                        onAddNewPayment: () {
                          _refreshPayments();
                          //Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
