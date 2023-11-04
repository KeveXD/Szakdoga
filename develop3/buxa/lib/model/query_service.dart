import 'package:flutter/material.dart';
import 'package:buxa/widgets/payment_list_item.dart';
import 'package:buxa/data_model/payment_data_model.dart';
import 'package:buxa/database/payment_repository.dart';
import 'package:buxa/database/pocket_repository.dart';

class QueryService {
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;
  String? pocket;
  bool? isExpense;
  bool? isIncome;
  String? title;
  String? comment;

  Widget buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required TextEditingController controller,
    required Function(DateTime?) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            ).then((date) {
              if (date != null) {
                onDateSelected(date);
              }
            });
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(label),
              ),
              Spacer(),
              Text(
                _formatDate(date) ?? 'Válassz dátumot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildToggleButton({
    required String text,
    required bool isSelected,
    required Function(bool) onToggle,
  }) {
    return TextButton(
      onPressed: () {
        onToggle(!isSelected);
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  String? _formatDate(DateTime? date) {
    return date?.toLocal().toString().split(' ')[0];
  }

  //ide írhatod a függvényeket

  Future<List<PaymentDataModel>> loadFromDatabase() async {
    final repository = PaymentRepository();
    return repository.getPaymentList();
  }

  Future<List<PaymentDataModel>> calculatePayments() async {
    final payments = await loadFromDatabase();

    final pocketRepo = PocketRepository();
    final pocketLocal =
        pocket != null ? await pocketRepo.getPocketByName(pocket!) : null;

    final filteredPayments = payments.where((payment) {
      if (startDate != null && payment.date.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && payment.date.isAfter(endDate!)) {
        return false;
      }

      if (minAmount != null && payment.amount < minAmount!) {
        return false;
      }
      if (maxAmount != null && payment.amount > maxAmount!) {
        return false;
      }

      if (title != null && title!.isNotEmpty) {
        if (!payment.title.toLowerCase().contains(title!.toLowerCase())) {
          return false;
        }
      }

      if (comment != null && comment!.isNotEmpty) {
        if (!payment.comment.toLowerCase().contains(comment!.toLowerCase())) {
          return false;
        }
      }

      if (pocket != null && pocketLocal != null) {
        if (payment.pocketId != pocketLocal.id) {
          return false;
        }
      }

      if (isExpense != null &&
          isExpense != (payment.type == PaymentType.Expense)) {
        return false;
      }

      if (isIncome != null &&
          isIncome != (payment.type == PaymentType.Income)) {
        return false;
      }

      return true;
    }).toList();

    return filteredPayments;
  }
}
