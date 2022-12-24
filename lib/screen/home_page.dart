import 'dart:ffi';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:medrem/screen/add_reminder.dart';
import 'package:medrem/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home-page';

  @override
  Widget build(BuildContext context) {

    // //is the id
    // final productId = ModalRoute.of(context)!.settings.arguments as String;

    // //product data for that id::
    // final loadedProduct =
    //     Provider.of<Products>(context, listen: false).findById(productId);


    return Scaffold(
      appBar: AppBar(
        title: Text("MedReminder"),
      ),
      backgroundColor: Color(0xFFf4c4e4),
      body: Center(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child:Text("Dashboard",
              style:TextStyle(
                  color: Colors.white,
                  fontSize: 50
                ),),),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text("Medicine Schedule"),
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      textStyle: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AddReminder.routeName,arguments:'newMed');
                    },
                    child: Text("Add Reminder"),
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      textStyle: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                
          ],
        ),
      ),
    );
  }
}
