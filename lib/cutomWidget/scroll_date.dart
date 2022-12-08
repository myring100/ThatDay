import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';


class Scroll_date extends StatefulWidget {
  Scroll_date(this._selectedDate,this.seletedDateFunction,{Key? key}) : super(key: key);
  DateTime _selectedDate;
  final Function(DateTime) seletedDateFunction;
  @override
  State<Scroll_date> createState() => _Scroll_dateState();
}

class _Scroll_dateState extends State<Scroll_date> {
  @override
  Widget build(BuildContext context) {
    print("seletected day is = ${widget._selectedDate.day}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget._selectedDate.year}-${widget._selectedDate.month}-${widget._selectedDate.day}",
          style: const TextStyle(color: Colors.black,fontSize: 20),

        ),
        SizedBox(
          height: 250,
          child: ScrollDatePicker(
            selectedDate: widget._selectedDate,
            locale: const Locale('en'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                widget._selectedDate = value;
                widget.seletedDateFunction(value);
              });
            },
          ),
        ),
      ],
    );
  }
}
