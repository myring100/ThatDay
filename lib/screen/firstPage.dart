import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/addPage.dart';
import 'package:that_day/service/notificationHelper.dart';
import 'package:that_day/service/utilities.dart';
import 'modifyPage.dart';
import 'package:that_day/kStyle.dart';


int next_db_ID = 1;
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late Future<List<Map<String, Object?>>> helper;


  Future<List<Map<String,Object?>>> getDao() async{
    return await DBHelper().getDao();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuildig firstpage');
    helper = getDao();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('D-day(That Day)',style: kMainTitle,),
        actions: <Widget>[
          IconButton(
            icon: kTrashIcon,
            onPressed: () async {
              NotificationHelper.cancelAllNoti();
              DBHelper table = DBHelper();
              await table.delete();
              setState(() {
                super.setState(() {
                  helper = getDao();
                });
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: LayoutBuilder(
          builder: (context, constraint )=>
              FutureBuilder<List<Map<String, Object?>>>(
                  future: helper,
                  builder:
                      (context, AsyncSnapshot<List<Map<String, Object?>>> data) {
                    if (data.hasData) {
                      if (data.data!.isEmpty) {
                        return customText('Add Event');
                      }
                      else {
                        next_db_ID = int.parse(data.data!.last['id'].toString()) + 1;
                        return ListView.builder(
                          shrinkWrap: true,
                            itemCount: data.data!.length,
                            itemBuilder: (context, index){
                              var singleData = data.data!.reversed.elementAt(index);
                              int id = int.parse(singleData['id'].toString());
                              String title = singleData['title'].toString();
                              String content = singleData['content'].toString();
                              int year = int.parse(singleData['year'].toString());
                              int month = int.parse(singleData['month'].toString());
                              int day = int.parse(singleData['day'].toString());
                              int backGround = int.parse(singleData['backGround'].toString());
                              int alarm = int.parse(singleData['alarm'].toString());
                              DBDao table = DBDao(year, day, month, title, content, backGround, alarm);
                              String dDay = Utilities.getDDay(DateTime(year, month, day));
                              return Card(
                                shape: kCardShape,
                                margin: const EdgeInsets.fromLTRB(7, 15, 7,0),
                                shadowColor: Colors.grey,
                                color: Color(backGround),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ListTile(
                                    onTap: ()=>Get.to(ModifyPage(id, table)),
                                    title: Text(title,style: kListMainText,textAlign: TextAlign.center,),
                                    subtitle: Text(dDay,textAlign: TextAlign.right,style: kListSubTitle,),
                                  ),
                                ),
                              );
                          });
                      }
                    }
                    else if (data.hasError) {
                      return customText('Something Wrong\nTry Again');
                    }
                    else {
                     return customText('Add Event');
                    }
                    },
              ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: true,
        child: SizedBox(
          height: 60,
          width: 60,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Get.to(() => AddPage(next_db_ID));
              },
              tooltip: 'ADD',
              child: kAddIcon,
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget customText(String text){
    return  Center(
        child: Text(
          text,
          style: kCustomText,
        ));
  }
}
