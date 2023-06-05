// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// TODO: SEE FIRST CONTAINER, IT'S NOT CENTERED ANYMORE WHY???
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routename = 'Profilepage';

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? bmi;
  String errorText = '';
  String status = '';

  void calculateBMI() {
    final double? height = double.tryParse(_heightController.value.text);
    final double? weight = double.tryParse(_weightController.value.text);

    if (height == null || weight == null) {
      setState(() {
        errorText = "Please enter your Height and Weight";
      });
      return;
    }

    if (height <= 0 || weight <= 0) {
      setState(() {
        errorText = "Your Height and Weight must be positive numbers";
      });
      return;
    }

    setState(() {
      bmi = weight / pow((height / 100), 2);
      if (bmi! < 18.5) {
        status = "Underweight";
      } else if (bmi! > 18.5 && bmi! < 25) {
        status = 'Normal weight';
      } else if (bmi! > 25 && bmi! < 30) {
        status = 'Pre-Obesity';
      } else if (bmi! > 30 && bmi! < 35) {
        status = 'Obesity class 1';
      } else if (bmi! > 35 && bmi! < 40) {
        status = 'Obesity class 2';
      } else {
        status = 'Obesity class 3';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    print('${ProfilePage.routename} built');
    TextEditingController names = TextEditingController();
    TextEditingController username = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 251, 228),
      appBar: AppBar(
        leadingWidth: 50,
        title: Text('Hello Bob!', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: Icon(Icons.account_circle),
        actions: [
            const Icon(Icons.access_time)
      ],
        automaticallyImplyLeading: false, // per tornare indietro con la navigazione
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(255, 1, 97, 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top:20),
                    child: Stack(
                      children:[ 
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top:80),
                          //width: 400,
                          height: 475,
                          width: MediaQuery.of(context).size.width*0.8,
                          //height: MediaQuery.of(context).size.width*0.6,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 254, 251, 228),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft:Radius.circular(40),
                              bottomRight:Radius.circular(40) 
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [    
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextField(
                                      controller: names,
                                      decoration: InputDecoration(
                                        labelText: 'Names',
                                        prefixIcon: Icon(Icons.person),
                                        border: myInputBorder(),
                                        enabledBorder: myInputBorder(),
                                        focusedBorder: myFocusBorder()
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    TextField(
                                      controller: username,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        prefixIcon: Icon(Icons.people),
                                        border: myInputBorder(),
                                        enabledBorder: myInputBorder(),
                                        focusedBorder: myFocusBorder()
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    TextField(
                                      controller: email,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: myInputBorder(),
                                        enabledBorder: myInputBorder(),
                                        focusedBorder: myFocusBorder()
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    TextField(
                                      controller: password,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.password),
                                        border: myInputBorder(),
                                        enabledBorder: myInputBorder(),
                                        focusedBorder: myFocusBorder()
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ElevatedButton(onPressed: () {}, 
                                    child: Text('Update'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 50, 165, 19),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 20),
                                        textStyle: TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.bold)
                                    ),
                                    ),
                                    
                              
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.asset('assets/images/avatar_Carciofo.jpg', width: 150, height: 150, fit: BoxFit.cover)
                              ),
                            Positioned(
                              bottom: 5,
                              right: 15.5,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.edit, size: 30),
                              ),
                            )
                          ],
                        ),
                      ),
                      ]
                    ),
                  ),
            ),

                // pensavo di rimandare alla pagina progetti o di mettere un expansion tile ma non riesco a farlo
                SizedBox(height: 30),
                ElevatedButton(onPressed: () {},
                  child: Text('Stai sostenendo: ... '),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 50, 165, 19),
                    padding: EdgeInsets.symmetric(
                      horizontal: 25, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)
                  )
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 254, 251, 228),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft:Radius.circular(40),
                        bottomRight:Radius.circular(40) 
                      )
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _heightController,
                          keyboardType:TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          suffixText: 'centimeters'
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          suffixText: 'kilograms',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                       ),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: calculateBMI,
                            child: const Text('Calculate'),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 50, 165, 19),
                              padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 20),
                            textStyle: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        errorText,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                          color: Colors.grey.shade400,
                         )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                            const SizedBox(
                              height: 50,
                           ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text(
                                bmi == null ? '00.00' : bmi!.toStringAsFixed(2),
                                style: TextStyle(
                                fontSize: 60,
                                color:
                                status == 'Underweight' ? Colors.blue
                                    : status == 'Normal weight' ? Colors.green
                                    : status == 'Pre-Obesity' ? Colors.yellow.shade700
                                    : status == 'Obesity class 1' ? Colors.orange
                                    : status == 'Obesity class 2' ? Colors.deepOrangeAccent
                                    : status == 'Obesity class 3' ? Colors.red
                                    : null
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(status,
                                  style: TextStyle(
                                    color:
                                      status == 'Underweight' ? Colors.blue
                                    : status == 'Normal weight' ? Colors.green
                                    : status == 'Pre-Obesity' ? Colors.yellow.shade700
                                    : status == 'Obesity class 1' ? Colors.orange
                                    : status == 'Obesity class 2' ? Colors.deepOrangeAccent
                                    : status == 'Obesity class 3' ? Colors.red
                                    : null
                                  ),
                                ),
                                const Text('BMI',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black45,
                                  ),
                                 ),
                                ],
                              ),
                              ],
                            ),

                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 15.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    5.0, // Move to right 5  horizontally
                                    5.0, // Move to bottom 5 Vertically
                                 ),
                                )
                              ],
                             ),
                            ),

                            const SizedBox(height: 30,),
                            const Text('Nutritional Status',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(15)
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: const Center(child: Text('Underweight', style: TextStyle( fontSize: 8, color: Colors.white))),

                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    color: Colors.green,
                                    child: const Center(child: Text('Normal \nweight', style: TextStyle(fontSize: 8, color: Colors.white))),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    color: Colors.yellow.shade700,
                                    child: const Center(child: Text('Pre-Obesity', style: TextStyle(fontSize: 8, color: Colors.white))),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    color: Colors.orange,
                                    child: const Center(child: Text('Obesity \nclass 1', style: TextStyle(fontSize: 8, color: Colors.white))),
                                  ),
                               ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    color: Colors.deepOrangeAccent,
                                    child: const Center(child: Text('Obesity \nclass 2', style: TextStyle(fontSize: 8, color: Colors.white))),

                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(15)
                                      ),
                                      color: Colors.red,
                                   ),
                                    child: const Center(child: Text('Obesity \nclass 3', style: TextStyle(fontSize: 8, color: Colors.white))),
                                 ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('00', style: TextStyle(color: Colors.transparent,)),
                                Text('18.5'),
                                Text('25.0'),
                                Text('30.0'),
                                Text('35.0'),
                                Text('40.0'),
                                Text('00', style: TextStyle(color: Colors.transparent,)),
                              ],
                            ),

                          ],
                        ),
                     ),
                    )
                      ]
                    ),

                  ),
                ),
                SizedBox(
                  height: 30
                )
          ],
        ),
            
      ), 
    );
  }
  OutlineInputBorder myInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 3,
      )
      );
  }
  OutlineInputBorder myFocusBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 3,
      )
      );
  }
}