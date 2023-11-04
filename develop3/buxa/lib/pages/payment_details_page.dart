import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/pocket_repository.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';
import 'package:buxa/widgets/desk.dart';
import 'package:buxa/pages/edit_payment_page.dart';
import 'package:buxa/widgets/new_payment_dialog.dart';

class PaymentDetailsPage extends StatelessWidget {
  final PaymentDataModel payment;

  PaymentDetailsPage({required this.payment});

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
                        '${payment.date.toLocal()}',
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
                        payment.title,
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
                        payment.comment,
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
                        payment.type == PaymentType.Income
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
                        '${payment.amount} ${payment.currency}',
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
                        future: getPocketNameById(payment.pocketId),
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
                        payment.isDebt ? 'Igen' : 'Nem',
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
                  Navigator.pop(context);
                },
              ),
              CustomButtonModel(
                color: Color.fromARGB(255, 158, 202, 62),
                icon: Icons.edit,
                title: 'Szerkesztés',
                function: () {
                  // Itt hozzuk létre és jelenítjük meg az új fizetés szerkesztő dialógust.
                  _showEditPaymentDialog(context, payment);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditPaymentDialog(BuildContext context, PaymentDataModel payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPaymentPage(
          onAddNewPayment: () {
            // Itt tudsz valamit tenni, ha a dialógus bezárásakor frissíteni kell az adatokat.
          },
          initialPayment: payment,
        );
      },
    );
  }

  Future<String> getPocketNameById(int id) async {
    final pocketRepo = PocketRepository();
    final pocket = await pocketRepo.getPocketById(id);
    return pocket?.name ?? 'No Pocket Found';
  }
}
