import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_project/models/db.dart';
import 'package:app_project/utils/algorithm.dart';
import 'package:app_project/utils/shared_preferences.dart';
import 'package:app_project/services/impact.dart';

import '../models/projects.dart';

class HomeProvider extends ChangeNotifier {
   late List<HR> heartRates;
   late int aerobicTime;
   late List<Kalories> kalories;
   late double totalKalories;
   late List<Steps> steps;
   late int totalSteps;

   late List<Projects> projects;
   late int score = 0;
   //late List<Reward> reward;
   //late List<Missions> mission;
   //late List<Partner> partners; 

   late List<HR> _heartRatesDB;
   //late List<Times> _timesDB;
   late List<Kalories> _kaloriesDB;
   late List<Steps> _stepsDB; 

   // selected day of data to be shown
   DateTime showDate = DateTime.now().subtract(const Duration(days: 1));

   // data generators faking external services
   final FitbitGen fitbitGen = FitbitGen();
   final ImpactService impactService;
   final Random _random = Random();
   bool doneInit = false;

   HomeProvider(this.impactService) {
    _init();
  }

  Future<void> _init() async {
    await _fetchAndCalculate();
    getDataOfDay(showDate);
    doneInit = true;
    notifyListeners();
  }

   DateTime lastFetch = DateTime.now().subtract(Duration(days: 7));

  Future<void> _fetchAndCalculate() async {
    _heartRatesDB = await impactService.getHRFromDay(lastFetch);
    _stepsDB = await impactService.getStepFromDay(lastFetch);
    _kaloriesDB = await impactService.getKalFromDay(lastFetch);
    aerobicTime = getAerobicTime(_heartRatesDB);
    totalKalories = getTotalKalories(_kaloriesDB);
    totalSteps = getTotalSteps(_stepsDB);
    
    //_heartRatesDB = fitbitGen.fetchHR();
    //_timesDB = fitbitGen.fetchTimes();
    //_stepsDB = fitbitGen.fetchSteps();
    //_kaloriesDB = fitbitGen.fetchKalories();
    
  }

   void getDataOfDay(DateTime showDate) {
    this.showDate = showDate;
    heartRates = _heartRatesDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    steps = _stepsDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    kalories = _kaloriesDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList();
    aerobicTime = getAerobicTime(heartRates);
    totalSteps = getTotalSteps(steps);
    totalKalories = getTotalKalories(kalories);
    score = getDailyScore(totalKalories, totalSteps, aerobicTime);
    /*times = _timesDB
        .where((element) => element.timestamp.day == showDate.day)
        .toList()
        .reversed
        .toList(); */
    //fullexposure = exposure.map((e) => e.value).reduce(
      //    (value, element) => value + element,
      //  );
    // after selecting all data we notify all consumers to rebuild
    notifyListeners();
  }
}



