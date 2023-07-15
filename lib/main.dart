import 'package:app_project/database/db.dart';
import 'package:app_project/models/projects.dart';
import 'package:app_project/screens/login_page.dart';
import 'package:app_project/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_project/screens/splash.dart';
import 'package:app_project/services/impact.dart';
import 'package:app_project/models/missions.dart';
import 'package:app_project/utils/shared_preferences.dart';
import 'package:app_project/repository/DataBaseRepository.dart';

// VERSION 1.2

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorDatabaseFit.databaseBuilder('database_fit.db').build();
  final databaseRepository = DataBaseRepository(database: database);
  
    runApp(ChangeNotifierProvider<DataBaseRepository>(
      create: (context) => databaseRepository,
      child: MyApp()));
} // main

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (context) => Preferences()..init(),
            lazy: false,
          ),
          Provider(
              create: (context) => ImpactService(
                    Provider.of<Preferences>(context, listen: false),
                  )),
          
          /*ChangeNotifierProvider<HomeProvider>(
              create: (context) => HomeProvider(
                  Provider.of<ImpactService>(context, listen: false),
                  )),*/
          
          ChangeNotifierProvider<Missions>(
              child: MyApp(), create: (_) => Missions()),
          ChangeNotifierProvider<SelectedProject>(
              child: MyApp(), create: (_) => SelectedProject()),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Poppins'),
          home: const Splash(),
        ));
  } // build
} // MyApp 
