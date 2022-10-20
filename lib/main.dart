import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_detector/BrainTumor.dart';
import 'package:medical_detector/Infectious.dart';
import 'package:medical_detector/SkinCancer.dart';
import 'package:medical_detector/TB.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(brightness: Brightness.light,
      primaryColor: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: GridLayout()));
}

class GridLayout extends StatelessWidget {

  List<String> events = [
    "BRAIN TUMOR",
    "SKIN CANCER",
    "TUBERCULOSIS",
    "INFECTIONS"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Text("fdf",style: GoogleFonts.roboto(fontSize: 50, fontWeight: FontWeight.bold),),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backg.png"),fit:BoxFit.cover),),child: Container(
            margin: const EdgeInsets.only(top: 120.0),
            child: GridView(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: events.map((title){
                return GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.all(20.0),
                    child: getCardByTitle((title)),
                  ),
                  onTap: (){
                    // Fluttertoast.showToast(
                    //   msg: title + "click",
                    //   toastLength: Toast.LENGTH_SHORT,
                    //   gravity: ToastGravity.CENTER,
                    //   backgroundColor: Colors.red,
                    //   textColor: Colors.white,
                    //   fontSize: 16.0
                    // );
                    if(title == "BRAIN TUMOR") {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>
                          BrainTumor(),),);
                    }
                    else if(title == "SKIN CANCER") {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>
                          SkinCancer(),),);
                    }
                    else if(title == "TUBERCULOSIS") {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>
                          TB(),),);
                    }
                    else if(title == "INFECTIONS") {
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context)=>
                          Infectious(),),);
                    }
                  },);
              }).toList(),
            ),
          ),
          )
        ],

      ),
    );
  }

  Column getCardByTitle(String title) {
    String img = "";
    if(title == "BRAIN TUMOR")
      img = "assets/braintrumor_img.png";
    else if(title == "SKIN CANCER")
      img = "assets/skincancer_img.webp";
    else if(title == "TUBERCULOSIS")
      img = "assets/Tb_img.webp";
    else if(title == "INFECTIONS")
      img = "assets/infection.png";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: Container(
            child: new Stack(children: <Widget>[
              new Image.asset(img,width: 200.0,height: 120,),
            ],),
          ),
        ),
        Text(title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        )
      ],
    );
  }
}
