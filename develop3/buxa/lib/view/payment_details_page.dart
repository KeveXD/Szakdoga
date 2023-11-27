import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/viewmodel/payment_details_viewmodel.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';

class PaymentDetailsPage extends StatelessWidget {
  final PaymentDetailsPageViewModel viewModel;

  PaymentDetailsPage({required PaymentDataModel payment})
      : viewModel = PaymentDetailsPageViewModel(payment: payment);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Részletes nézet'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Dátum:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${viewModel.payment.date.toLocal()}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Cím:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        viewModel.payment.title,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Megjegyzés:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        viewModel.payment.comment,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Típus:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        viewModel.payment.type == PaymentType.Income
                            ? 'Bevétel'
                            : 'Kiadás',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Összeg:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${viewModel.payment.amount} ${viewModel.payment.currency}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Zseb:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: FutureBuilder<String>(
                        future: viewModel
                            .getPocketNameById(viewModel.payment.pocketId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // A keresés folyamatban van
                            return Text('Loading...');
                          } else if (snapshot.hasError) {
                            // Hiba történt
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Sikeres keresés esetén az eredmény megjelenítése
                            return Text(
                              snapshot.data ?? 'No Pocket Found',
                              style: TextStyle(fontSize: 16),
                            );
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Tartozik-e:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        viewModel.payment.isDebt ? 'Igen' : 'Nem',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Desk(
            buttons: [
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.menu,
                title: 'Vissza',
                function: () {
                  viewModel.navigateBack(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.edit,
                title: 'Szerkesztés',
                function: () {
                  viewModel.showEditPaymentDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
