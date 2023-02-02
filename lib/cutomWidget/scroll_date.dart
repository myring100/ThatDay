import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${widget._selectedDate.month}-${widget._selectedDate.day}-${widget._selectedDate.year}",
          style: const TextStyle(color: Colors.black,fontSize: 20),

        ),
        SizedBox(
          height: 150,
          child: ScrollDatePicker(
            maximumDate: DateTime.now().add(const Duration(days: 365*100)),
            minimumDate: DateTime.now().subtract(const Duration(days: 365*100)),
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
