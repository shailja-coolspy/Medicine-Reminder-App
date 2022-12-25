import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medrem/providers/medicine.dart';

import '../models/http_exception.dart';

class AddReminderMed with ChangeNotifier{
  List<Medicine> _meds=[];

   

  //Auth Token::::::::::::::::::::::
  final String authToken;
  final String userId;

  AddReminderMed(this.authToken,this.userId,this._meds);

  List<Medicine> get items {
    return [..._meds];
  }

  Medicine findById(String id){
    return _meds.firstWhere((med) => med.id==id);
  }

  //Fetch/get medicine from firebase::
  Future<void> fetchAndSetMed([bool filterByUser=false]) async {
    var _params;
    if (filterByUser) {
      _params = <String, String>{
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }
    if (filterByUser == false) {
      _params = <String, String>{
        'auth': authToken,
      };
    }
    var url = Uri.https(
        'medreminder-f7ae8-default-rtdb.firebaseio.com','/medicine.json',_params);
    //response that contain data:::
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
     // print(extractedData);
      final List<Medicine> loadedMed = [];

      if(extractedData==null){
        return;
      }

     
      extractedData.forEach((medId, medData) {
        loadedMed.add(Medicine(
            id: medId,
            medicineName: medData['medicineName'],
            medType: medData['medType'],
            dose: medData['dose'],
            startDate: medData['startDate'],
            endDate: medData['endDate'],
            schedule: medData['schedule'],
            alarm: medData['alarm']
            ));
      });
      _meds=loadedMed;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  //add product:::
  //asyncronous ..async will automatically wrap it into future::
  Future<void> addMed(Medicine medicine) async {
    //url to which we send request::
    final url = Uri.https(
        'medreminder-f7ae8-default-rtdb.firebaseio.com', '/medicine.json',{'auth':'$authToken'});
   
    try {
      final response = await http.post(url,
          body: json.encode({
            'medicineName': medicine.medicineName,
            'medType': medicine.medType,
            'dose': medicine.dose,
            'startDate': medicine.startDate,
            'endDate': medicine.endDate,
            'schedule':medicine.schedule,
            'alarm':medicine.alarm,
            'creatorId':userId
          }));
      //print(json.decode(response.body));
      final newProduct = Medicine(
          id: json.decode(response.body)['name'],
          medicineName: medicine.medicineName,
          medType: medicine.medType,
          dose: medicine.dose,
          startDate: medicine.startDate,
          endDate:medicine.endDate,
          schedule: medicine.schedule,
          alarm: medicine.alarm);
      _meds.add(newProduct);
      //print(newProduct.id);
      notifyListeners();
    } catch (error) {
      //print(error);
      throw error;
    }
   
  }


//update product::::
  Future<void> updateMed(String id, Medicine newMeds) async{
    final medIndex = _meds.indexWhere((med) => med.id == id);
    if (medIndex >= 0) {
      final url = Uri.https(
        'medreminder-f7ae8-default-rtdb.firebaseio.com', '/medicine/$id.json',{'auth':'$authToken'});
      await http.patch(url,body: json.encode({
        'medicineName':newMeds.medicineName,
            'medType': newMeds.medType,
            'dose': newMeds.dose,
            'startDate': newMeds.startDate,
            'endDate': newMeds.endDate,
            'schedule':newMeds.schedule,
            'alarm':newMeds.alarm,  
      }));
      _meds[medIndex] = newMeds;
      notifyListeners();
    } else {
      print('...');
    }
  }


//delete product::::
  Future<void> deleteMed(String id) async{
    final url = Uri.https(
        'medreminder-f7ae8-default-rtdb.firebaseio.com', '/medicine/$id.json',{'auth':'$authToken'});
    final existingProductIndex=_meds.indexWhere((med) =>med.id == id);
    var existingProduct=_meds[existingProductIndex];
    _meds.removeAt(existingProductIndex);
    notifyListeners();
   final response=await http.delete(url);
      if(response.statusCode>=400){
         _meds.insert(existingProductIndex, existingProduct);
          notifyListeners();
        throw HttpException('Could not delete product.');
      }
      //existingProduct=null;
    
  }

}