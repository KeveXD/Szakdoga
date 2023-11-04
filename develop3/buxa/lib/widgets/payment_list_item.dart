import 'package:flutter/material.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';

class PaymentListItem extends StatelessWidget {
  final PaymentDataModel payment;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback? onDetails;

  PaymentListItem({
    required this.payment,
    required this.onDelete,
    required this.onEdit,
    this.onDetails, // Opcionális paraméter
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = payment.type == PaymentType.Expense;
    final color = isExpense ? Colors.red : Colors.green;

    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Balra igazítás
        crossAxisAlignment: CrossAxisAlignment.center, // Középre igazítás
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.type == PaymentType.Expense ? 'Expense' : 'Income',
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                payment.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true, // Engedje a szöveg tördelését
              ),
            ],
          ),
          Spacer(), // Tartalom jobbra igazítása
          Column(
            children: [
              Text(
                "${payment.amount} ${payment.currency}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      PaymentRepository().deletePayment(payment.id!);
                      onDelete();
                    },
                    icon: Icon(Icons.delete),
                  ),
                  if (onDetails !=
                      null) // Ellenőrizze az onDetails callback létezését
                    IconButton(
                      onPressed: onDetails,
                      icon: Icon(Icons.info),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
