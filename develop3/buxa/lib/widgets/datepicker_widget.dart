import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final String label;
  final DateTime? date;
  final TextEditingController controller;
  final Function(DateTime?) onDateSelected;

  DatePickerWidget({
    required this.label,
    required this.date,
    required this.controller,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
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
            ).then((pickedDate) {
              if (pickedDate != null) {
                onDateSelected(pickedDate);
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
                formatDate(date) ?? 'Válassz dátumot',
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

  String? formatDate(DateTime? date) {
    return date?.toLocal().toString().split(' ')[0];
  }
}
