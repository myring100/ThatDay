import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

DateTime _selectedDate = DateTime.now();

class Scroll_date extends StatefulWidget {
  const Scroll_date(this.seletedDate,{Key? key}) : super(key: key);
  final Function(DateTime) seletedDate;
  @override
  State<Scroll_date> createState() => _Scroll_dateState();
}

class _Scroll_dateState extends State<Scroll_date> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
          style: const TextStyle(color: Colors.black,fontSize: 20),

        ),
        SizedBox(
          height: 250,
          child: ScrollDatePicker(
            selectedDate: _selectedDate,
            locale: const Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
                widget.seletedDate(value);
              });
            },
          ),
        ),
      ],
    );
  }
}
