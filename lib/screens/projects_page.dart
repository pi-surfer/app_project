import 'package:app_project/models/projects.dart';
import 'package:app_project/models/widgetProject.dart';
import 'package:app_project/provider/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectsPage extends StatefulWidget {

  static const routename = 'Projectspage';

  const ProjectsPage({
    Key? key,  
  }):super(key: key);

  @override
  State createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  
  final IdProject id = IdProject();
  List<bool> light = [false,false,false,false,false];
  List<bool> selected = [false,false,false,false,false];
  int index = 1;
  final List<Projects> projects = getProject();
  

  @override
  Widget build(BuildContext context) {  
    print('${ProjectsPage.routename} built');
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 254, 251, 228),
      body: Center( 
        child: ListView.builder(
          itemCount: id.ids.length,
          itemBuilder: (context, index) {
            return ProjectItem(name: projects[index].name, address: projects[index].address, phrase: projects[index].phrase, imagePath: projects[index].imagePath);
          }
        )
      )
    );
  }
}
