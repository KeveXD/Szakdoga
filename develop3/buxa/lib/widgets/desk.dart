import 'package:flutter/material.dart';
import 'package:buxa/data_model/custom_button_data_model.dart';

class Desk extends StatelessWidget {
  final List<CustomButtonModel> buttons;

  Desk({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons
                    .map((button) => GestureDetector(
                          onTap: button.function as void Function()?,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: button.color ??
                                  Color.fromARGB(255, 192, 246, 105),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  button.icon ?? Icons.error,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  button.title ?? 'No Title',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
