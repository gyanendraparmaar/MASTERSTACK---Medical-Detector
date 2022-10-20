import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Infectious extends StatefulWidget {
  const Infectious({Key? key}) : super(key: key);

  @override
  State<Infectious> createState() => _InfectiousState();
}

class _InfectiousState extends State<Infectious> {
  bool _loading = true;
  late File _image;
  final imagepicker = ImagePicker();
  List _predictions = [];

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  loadmodel()async{
    await Tflite.loadModel(model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  detect_image(File image) async{
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState((){
      _loading = false;
      _predictions = prediction!;
    });

  }


  @override
  void dispose() {
    super.dispose();
  }

  _loadimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if(image == null){
      return null;
    }
    else {
      _image = File(image.path);
    }
    detect_image(_image);
  }

  _loadimage_camara() async{
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if(image == null){
      return null;
    }
    else {
      _image = File(image.path);
    }
    detect_image(_image);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: Text('ML Classifier', style: GoogleFonts.roboto(),),
      // ),
      floatingActionButton: SpeedDial(

        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera_alt_sharp),
              label: 'Camera',
              onTap: () {
                _loadimage_camara();
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: 'Gallery',
              onTap: () {
                _loadimage_gallery();
              }
          ),
        ],
        // backgroundColor: Colors.green,
        // child: const Icon(Icons.camera_alt_rounded),
      ),

      body: Stack(
          alignment: Alignment.topCenter,
          children: [
            buildCoverImage(),
            ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                SizedBox(
                  height: h,
                  width: w,
                  //color: Colors.red,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(10),

                          color: Colors.blue,
                          child: Image.asset('assets/infection.png'),),
                        Container(child: Text(
                          'Infectious',
                          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ),
                        SizedBox(height: 10,),
                        // Container(
                        //   width: double.infinity,
                        //   height: 70,
                        //   padding: EdgeInsets.all(10),
                        //   color: Colors.teal,
                        //   child: RaisedButton(onPressed: (){
                        //     _loadimage_camara();
                        //   },
                        //     child: Text('Camara', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),),
                        // ),
                        // SizedBox(height: 10,),
                        // Container(
                        //   width: double.infinity,
                        //   height: 70,
                        //   padding: EdgeInsets.all(10),
                        //   color: Colors.teal,
                        //   child: RaisedButton(onPressed: (){
                        //     _loadimage_gallery();
                        //   },
                        //     child: Text('Gallery', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10) ),),
                        // ),
                        _loading == false ? Container(
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                width: 250,
                                child: Image.file(_image),
                              ),
                              // Text(_predictions[0].toString()),
                              Text(''+_predictions[0]['label'].toString().substring(2),),
                              Text('Confidence: '+_predictions[0]['confidence'].toString())
                            ],
                          ),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            )

          ]
      ),
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Image.asset("assets/backg.png",
      width: double.infinity,
      height: 280,
      fit: BoxFit.cover,
    ),
  );
}