import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:medrem/providers/addReminder.dart';
import 'package:medrem/screen/add_reminder.dart';
import 'package:provider/provider.dart';

import '../widgets/userMedItem.dart';


class MedSchedule extends StatelessWidget {
  //const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/med-schedule';

  Future<void> _refreshMed(BuildContext context) async {
    await Provider.of<AddReminderMed>(context, listen: false)
        .fetchAndSetMed(true);
  }

  @override
  Widget build(BuildContext context) {
    final medData = Provider.of<AddReminderMed>(context);
    print('rebuilding.....');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yours Medicine'),
        actions: [
          //add new product
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddReminder.routeName,
                    arguments: 'newMed');
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      //PULL TO REFRESH:::::::::::::::::::::::::::::::::::::::
      body: FutureBuilder(
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshMed(context),
                    child: Consumer<AddReminderMed>(
                      builder:(ctx,medData,_)=> Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: medData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserMedItem(
                                  medData.items[i].id as String,
                                  medData.items[i].medicineName,
                                  medData.items[i].startDate,
                                  medData.items[i].endDate,
                                  medData.items[i].schedule,
                                  medData.items[i].alarm,
                                  //medData.items[i].dose 
                                  ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}