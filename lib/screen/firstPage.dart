import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:that_day/DB/DBDao.dart';
import 'package:that_day/DB/DBHelper.dart';
import 'package:that_day/screen/addPage.dart';
import 'package:that_day/service/notificationHelper.dart';
import 'package:that_day/service/utilities.dart';
import 'modifyPage.dart';


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
        automaticallyImplyLeading: false,
        title: const Text('D-day(That Day)'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.restore_from_trash_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              NotificationHelper.cancelAllNoti();
              DBHelper table = DBHelper();
              await table.delete();
              setState(() {super.setState(() {
              helper = getDao();
              });});

              // do something
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(

        future: helper,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, Object?>>> data) {
          List<Widget> children = [];
          if (data.hasData) {
            if(data.data!.isEmpty){
              children.add(const Expanded(child: Center(child: Text('Add Event',style: TextStyle(fontSize: 24),))));
            }
            else{
              var myLiteror = data.data?.reversed.iterator;
              next_db_ID = int.parse(data.data!.last['id'].toString())+1;
              while (myLiteror!.moveNext()) {
                int id = int.parse(myLiteror.current['id'].toString());
                String title = myLiteror.current['title'].toString();
                String content = myLiteror.current['content'].toString();
                int year = int.parse(myLiteror.current['year'].toString());
                int month = int.parse(myLiteror.current['month'].toString());
                int day = int.parse(myLiteror.current['day'].toString());
                int backGround = int.parse(myLiteror.current['backGround'].toString());
                int alarm = int.parse(myLiteror.current['alarm'].toString());
                DBDao table = DBDao(year, day, month, title, content,backGround,alarm);
                String dDay = Utilities.getDDay(DateTime(year,month,day));
                children.add(
                    Card(
                      margin: const EdgeInsets.all(10),
                      shadowColor: Colors.white54,
                      //todo here we have backGroundColor
                      color: Color(backGround),
                      child: InkWell(
                        onTap: (){
                          Get.to(ModifyPage(id,table));
                        },
                        onLongPress: (){

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                dDay,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              }
            }

          }
          else if(data.hasError){
            children.add(const Expanded(child: Center(child: Text('Something Wrong\nTry Again',style: TextStyle(fontSize: 24),))));
          }
          else {
            children.add(const Expanded(child: Center(child: Text('Add Event',style: TextStyle(fontSize: 24),))));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddPage(next_db_ID));
        },
        tooltip: 'ADD',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();

  }
}
