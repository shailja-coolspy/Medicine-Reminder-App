import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medrem/providers/addReminder.dart';
import 'package:medrem/providers/medicine.dart';
import 'package:medrem/widgets/alarm_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class AddReminder extends StatefulWidget {
  // const AddReminder({Key? key}) : super(key: key);

  static const routeName = '/add-reminder';

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  //focus node to description::
  final _medTypeFocusNode = FocusNode();
  final _doseFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();
  final _scheduleFocusNode = FocusNode();
  final _alarmFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedMed = Medicine(
      id: null,
      medicineName: '',
      medType: '',
      dose: 0,
      startDate: '',
      endDate: '',
      schedule: '',
      alarm: '');
  //we use string bcz we get value back as string::::
  var _initValues = {
    'medicineName': '',
    'medType': '',
    'dose': '',
    'startDate': '',
    'endDate': '',
    'schedule': '',
    'alarm': '',
  };

  var _isInit = true;

  //loading::
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //we get the id from the route::::
      final medId = ModalRoute.of(context)!.settings.arguments as String;

      if (medId != 'newMed') {
        _editedMed =
            Provider.of<AddReminderMed>(context, listen: false).findById(medId);
        //inititaize the form with this data:::
        _initValues = {
          'medicineName': _editedMed.medicineName,
          'medType': _editedMed.medType,
          'dose': _editedMed.dose.toString(),
          'startDate': _editedMed.startDate,
          'endDate': _editedMed.endDate,
          'schedule': _editedMed.schedule,
          'alarm': _editedMed.alarm,
        };
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  //we need to dispose focus node when state is cleared to avoid memory leak::
  @override
  void dispose() {
    _alarmFocusNode.dispose();
    _doseFocusNode.dispose();
    _medTypeFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    _scheduleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedMed.id != null) {
      await Provider.of<AddReminderMed>(context, listen: false)
          .updateMed(_editedMed.id as String, _editedMed);
    } else {
      //errorr by try and catch::
      try {
        await Provider.of<AddReminderMed>(context, listen: false)
            .addMed(_editedMed);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong.'),
                  actions: [
                    //closing dialog box:::
                    FlatButton(
                        onPressed: (() {
                          Navigator.of(ctx).pop();
                        }),
                        child: Text('Okay'))
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  TextEditingController dateCtl = TextEditingController();
  TextEditingController end_dateCtl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Reminder"),
          actions: [
            //save button::::
            IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      //medicine name:::
                      TextFormField(
                          initialValue: _initValues['medicineName'],
                          decoration:
                              InputDecoration(labelText: 'Medicine Name'),
                          //textinputaction is enum:::
                          textInputAction: TextInputAction.next,
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_medTypeFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a name.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: value as String,
                              medType: _editedMed.medType,
                              dose: _editedMed.dose,
                              startDate: _editedMed.startDate,
                              endDate: _editedMed.endDate,
                              schedule: _editedMed.schedule,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //medicine type:::
                      TextFormField(
                          initialValue: _initValues['medType'],
                          decoration:
                              InputDecoration(labelText: 'Medicine Type'),
                          //textinputaction is enum:::
                          textInputAction: TextInputAction.next,
                          focusNode: _medTypeFocusNode,
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_doseFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a type of medicine.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: value as String,
                              dose: _editedMed.dose,
                              startDate: _editedMed.startDate,
                              endDate: _editedMed.endDate,
                              schedule: _editedMed.schedule,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //dose:::
                      TextFormField(
                          initialValue: _initValues['dose'],
                          decoration: InputDecoration(labelText: 'Dose'),
                          //textinputaction is enum:::
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _doseFocusNode,
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_startDateFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a valid dose.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: _editedMed.medType,
                              dose: int.parse(value as String),
                              startDate: _editedMed.startDate,
                              endDate: _editedMed.endDate,
                              schedule: _editedMed.schedule,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //startDate:::
                      TextFormField(
                          controller: dateCtl,
                          //initialValue: _initValues['startDate'],
                          decoration: InputDecoration(labelText: 'Start Date'),
                          //textinputaction is enum:::
                          //textInputAction:sd,
                          focusNode: _startDateFocusNode,
                          onTap: () async {
                            DateTime? date;
                            FocusScope.of(context).requestFocus(new FocusNode());

                              date = await showDatePicker(
                                            context: context, 
                                            initialDate:DateTime.now(),
                                            firstDate:DateTime(1900),
                                            lastDate: DateTime(2100));

                              dateCtl.text = DateFormat("dd-MM-yyyy").format(date!);
                              
                          },
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_endDateFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a Start Date.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: _editedMed.medType,
                              dose: _editedMed.dose,
                              startDate: value as String,
                              endDate: _editedMed.endDate,
                              schedule: _editedMed.schedule,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //end date:::
                      TextFormField(
                          //initialValue: _initValues['endDate'],
                          decoration: InputDecoration(labelText: 'End Date'),
                          //textinputaction is enum:::
                          //textInputAction: TextInputAction.next,
                          focusNode: _endDateFocusNode,
                          controller: end_dateCtl,
                          onTap: () async {
                            DateTime? date;
                            FocusScope.of(context).requestFocus(new FocusNode());

                              date = await showDatePicker(
                                            context: context, 
                                            initialDate:DateTime.now(),
                                            firstDate:DateTime(1900),
                                            lastDate: DateTime(2100));

                              end_dateCtl.text = DateFormat("dd-MM-yyyy").format(date!);
                              
                          },
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_scheduleFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a End Date.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: _editedMed.medType,
                              dose: _editedMed.dose,
                              startDate: _editedMed.startDate,
                              endDate: value as String,
                              schedule: _editedMed.schedule,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //schedule:::
                      TextFormField(
                          initialValue: _initValues['schedule'],
                          decoration: InputDecoration(labelText: 'Schedule'),
                          //textinputaction is enum:::
                          textInputAction: TextInputAction.next,
                          focusNode: _scheduleFocusNode,
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a Schedule.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: _editedMed.medType,
                              dose: _editedMed.dose,
                              startDate: _editedMed.startDate,
                              endDate: _editedMed.endDate,
                              schedule: value as String,
                              alarm: _editedMed.alarm,
                              id: _editedMed.id,
                            );
                          }),

                      //time:::
                      TextFormField(
                          initialValue: _initValues['alarm'],
                          decoration: InputDecoration(labelText: 'Time'),
                          //textinputaction is enum:::
                          textInputAction: TextInputAction.next,
                          focusNode: _alarmFocusNode,
                          //we tell flutter when next button is pressed then go to _priceFocusNode::::
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide time.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedMed = Medicine(
                              medicineName: _editedMed.medicineName,
                              medType: _editedMed.medType,
                              dose: _editedMed.dose,
                              startDate: _editedMed.startDate,
                              endDate: _editedMed.endDate,
                              schedule: _editedMed.schedule,
                              alarm: value as String,
                              id: _editedMed.id,
                            );
                          }),

                        SizedBox(
                          height: 30,
                        ),
                      //ALARM::::::::::::::
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pushNamed(AlarmWideget.routeName,arguments: 'setAlarm');
                          },
                          child: Text("Set Alarm"),
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            textStyle: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
