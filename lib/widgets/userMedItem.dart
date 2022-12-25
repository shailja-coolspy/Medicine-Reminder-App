import 'package:flutter/material.dart';
import 'package:medrem/providers/addReminder.dart';
import 'package:medrem/screen/add_reminder.dart';
import 'package:provider/provider.dart';

class UserMedItem extends StatelessWidget {
  //const UserProductItem({Key? key}) : super(key: key);
  final String id;
  final String medicineName;
  final String startDate;
  final String endDate;
  final String schedule;
  final String alarm;
  //final int dose;
  UserMedItem(
    this.id,
    this.medicineName,
    this.startDate,
    this.endDate,
    this.schedule,
    this.alarm,
    //this.dose
    );

  @override
  Widget build(BuildContext context) {
    final scaffold= Scaffold.of(context);
    return ListTile(
      title: Text(medicineName+" ("+schedule+")"),
      subtitle: Text(startDate+" to "+endDate),
      trailing: Container(
        width: 100,
        child: Row(children: [
          //edit button:::
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddReminder.routeName,arguments: id);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          //delete button:::
          IconButton(
            onPressed: () async{
                try{
                await Provider.of<AddReminderMed>(context,listen: false).deleteMed(id);
                }
                catch(error){
                 scaffold.showSnackBar(SnackBar(content: Text('Deleting failed!',textAlign: TextAlign.center,)));
                }
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
          
        ]),
      ),
    );
  }
}