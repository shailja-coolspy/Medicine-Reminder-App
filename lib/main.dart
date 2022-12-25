import 'package:flutter/material.dart';
import 'package:medrem/providers/addReminder.dart';
import 'package:medrem/screen/add_reminder.dart';
import 'package:medrem/screen/auth_screen.dart';
import 'package:medrem/screen/home_page.dart';
import 'package:medrem/screen/med_schedule.dart';
import 'package:medrem/widgets/alarm_widget.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, AddReminderMed>(
            update: (ctx, auth, prevoiusMed) => AddReminderMed(
                auth.token ?? '',
                auth.userId ?? '',
                prevoiusMed == null ? [] : prevoiusMed.items),
            create: (_) => AddReminderMed('', '', []),
          ),
      ],
       child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MedReminder',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? HomePage()
                : AuthScreen(),
              
      routes: {
        HomePage.routeName:(ctx)=>HomePage(),
        AddReminder.routeName:(ctx) =>AddReminder(),
        AlarmWideget.routeName:(ctx)=>AlarmWideget(),
        MedSchedule.routeName:(ctx)=>MedSchedule(),
        AuthScreen.routeName:(ctx)=>AuthScreen()
      },
       
       )));
  }
}

