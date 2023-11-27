import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final String label;
  final DateTime date;
  final TextEditingController controller;
  final ValueChanged<DateTime?> onDateSelected;

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
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (picked != null) {
              onDateSelected(picked);
              controller.text = picked.toLocal().toString().split(' ')[0];
            }
          },
          child: IgnorePointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Dátum',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
