import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';

class AlarmWideget extends StatefulWidget {
  const AlarmWideget({Key? key}) : super(key: key);

    static const routeName = '/set-alarm';


  @override
  State<AlarmWideget> createState() => _AlarmWidegetState();
}

class _AlarmWidegetState extends State<AlarmWideget> {

  late String formattedTime;
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  TextEditingController timeinput = TextEditingController(); 
  //text editing controller for text field
  
  @override
  void initState() {
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: AppBar(
          title: const Text("Set Alarm"),
          
        ),
          body:Center(
          child: Column(children: <Widget>[
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(15),
          height:150,
          child:Center( 
             child:TextField(
                controller: timeinput, //editing controller of this TextField
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer), //icon of text field
                   labelText: "Enter Time" //label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  
                  if(pickedTime != null ){
                      print(pickedTime.format(context));   //output 10:51 PM
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      //converting to DateTime so that we can further format on different pattern.
                      print(parsedTime); //output 1970-01-01 22:53:00.000
                      formattedTime = DateFormat('HH:mm').format(parsedTime);
                      print(formattedTime); //output 14:59:00
                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                      setState(() {
                        timeinput.text = formattedTime; //set the value of text field. 
                      });
                  }else{
                      print("Time is not selected");
                  }
                },
             )
          )
          ),
        Container(
          margin: const EdgeInsets.all(25),
          child: TextButton(
            child: const Text(
              'Create alarm',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String sthour="";
              String stminutes="";
              int hour;
              int minutes;
              for(int i=0;i<2;i++){
                sthour=sthour+formattedTime[i];
              }
              for(int i=3;i<5;i++){
                stminutes=stminutes+formattedTime[i];
              }
              hour = int.parse(sthour);
              minutes = int.parse(stminutes);
              FlutterAlarmClock.createAlarm(hour,minutes);
            },
          ),
        ),
        ]
        ),
          )
    );
    
  }
}