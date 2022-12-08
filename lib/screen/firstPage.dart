import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/addPage.dart';

import 'modifyPage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Future<List<Map<String, Object?>>> helper = DBHelper().getDao();


  @override
  void setState(VoidCallback fn) {
    super.setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuildig firstpage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('D-day(That Day)'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<List<Map<String, Object?>>>(
                future: helper,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, Object?>>> data) {
                  List<Widget> children = [];
                  if (data.hasData) {
                    var myLiteror = data.data?.reversed.iterator;
                    while (myLiteror!.moveNext()) {
                      int id = int.parse(myLiteror.current['id'].toString());
                      String title = myLiteror.current['title'].toString();
                      String content = myLiteror.current['content'].toString();
                      int year = int.parse(myLiteror.current['year'].toString());
                      int month = int.parse(myLiteror.current['month'].toString());
                      int day = int.parse(myLiteror.current['day'].toString());
                      DBDao table = DBDao(year, day, month, title, content);

                      children.add(
                          Card(
                        margin: const EdgeInsets.all(10),
                        shadowColor: Colors.grey,
                        child: InkWell(
                          onTap: (){

                            Get.to(ModifyPage(id,table));

                          },
                          onLongPress: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ));
                    }
                  }
                  else if(data.hasError){
                    children.add(const Center(child: Text('Something Wrong\nTry Again')));

                  }
                  else {
                    children.add(const Center(child: Text('Add Event')));
                  }

                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: children,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const AddPage());
        },
        tooltip: 'ADD',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
