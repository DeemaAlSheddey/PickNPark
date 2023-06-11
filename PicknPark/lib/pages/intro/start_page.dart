
import 'package:flutter/material.dart';

import 'login.dart';
import 'sign_up.dart';

class startPage extends StatefulWidget{
 const startPage({ super.key });
 //DropdownButton(items: items[], onChanged: (){})
  @override
  _startPageState createState() => _startPageState();}
  
  class _startPageState extends State<startPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: 
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
          
          image: DecorationImage(image: AssetImage("Assets/Untitled.png"),fit:BoxFit.cover)
        ),
        child:Column(
          
          children: [
             Container( 
                 width: 350,
                 height: 40,
                margin: EdgeInsets.only(left: 20 , right : 10 ,top: 300),
                 child:  ElevatedButton(  
                 child: Text(' تسجيل الدخول',
                 style: TextStyle(
                  fontFamily: 'Tajawal',
                 fontSize:20 , color: Color.fromARGB(255, 86, 51, 116))),
                           onPressed: () {
           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogIn()),
            );
          }
          ,style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                    backgroundColor: Color.fromARGB(255, 193, 213, 244),),)
               ),
            Container( 
                 width: 350,
                 height: 40,
                margin: EdgeInsets.only(left: 20 , right : 10 ,top: 35),
                 child:  ElevatedButton(  
                 child: Text('تسجيل ',
                 style: TextStyle(
                  fontFamily: 'Tajawal',
                  
                 fontSize:20 , color: Color.fromARGB(255, 86, 51, 116))),
                           onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUp()),
            );
          }
          ,style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                    backgroundColor: Color.fromARGB(255, 193, 213, 244),),)
               ),
            Container( 
                 width: 350,
                 height: 40,
                margin: EdgeInsets.only(top: 190),
          child:TextButton(
    onPressed: () {
     /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ()),
            );*/
    },
    child:Text('AR | EN',style:TextStyle(
      fontFamily: 'Tajawal',
    decoration: TextDecoration.underline, color:Colors.black),
   ),
),
               ) 
          ],
        )))
        
                    
    

    ) ;
  }
}