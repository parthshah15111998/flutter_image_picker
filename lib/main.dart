import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Picker 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                buildImageFromGallery();
              },
              behavior: HitTestBehavior.opaque,
              child:  Container(
                  height: 50,
                  color: Colors.blue,
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Center(child: Text("Image From Galary"))),
            ),
            GestureDetector(
              onTap: () {
                buildImageFromCamera();
              },
              behavior: HitTestBehavior.opaque,
              child:  Container(
                  height: 50,
                  color: Colors.amber,
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Center(child: Text("Image From Camera"))),
            ),
            SizedBox(height: 20,),
            selectedFile != null
                ? Image.file(selectedFile!)
                : Center(child: Text("No Image Selected "))
          ],
        ),
      ),
    );
  }

  Future buildImageFromGallery() async{
    final ImagePicker picker = ImagePicker();

    if (await requestPermission(Permission.storage)) {
    XFile? returnImage = await picker.pickImage(source: ImageSource.gallery);
      if (returnImage != null) {
        setState(() {
          selectedFile = File(returnImage.path);
        });
      }else{
        ///TODO: set snackBar for this message.
        print("No capture Image.");
      }
    }
  }

 Future buildImageFromCamera() async{
   final ImagePicker picker = ImagePicker();

   if(await requestPermission(Permission.camera)){
     XFile? returnImage = await picker.pickImage(source: ImageSource.camera);
     if(returnImage != null){
       setState(() {
         selectedFile = File(returnImage.path);
       });
     }else{
       ///TODO: set snackBar for this message.
       print("No capture Image.");
     }
   }

 }

 Future<bool> requestPermission(Permission permission) async {
   final status = await permission.request();

   if (status.isGranted) {
     return true;
   } else if (status.isDenied) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Permission denied. Please grant permission.")),
     );
     return false;
   } else if (status.isPermanentlyDenied) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text("Permission permanently denied. Open settings to enable."),
         action: SnackBarAction(
           label: "Settings",
           onPressed: () {
             openAppSettings();
           },
         ),
       ),
     );
     return false;
   }
   return false;
 }

}
