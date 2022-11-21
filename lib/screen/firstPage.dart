import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/dDayList/dDayList.dart';
import 'package:that_day/screen/addPage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage();
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Add That Day',
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(const AddPage());
        },
        tooltip: 'ADD',
        child: const Icon(Icons.add,size: 30,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
