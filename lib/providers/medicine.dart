import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';






class Medicine with ChangeNotifier{
  final String? id;
  final String medicineName;
  final int dose;
  final String medType;
  final String startDate;
  final String endDate;
  final String schedule;
  final String alarm;

  Medicine({
    required this.id,
    required this.medicineName,
    required this.dose,
    required this.medType,
    required this.startDate,
    required this.endDate,
    required this.alarm,
    required this.schedule,

  });

}