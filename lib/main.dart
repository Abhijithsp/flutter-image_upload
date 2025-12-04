import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


import 'Utils/Utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Uplaod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Image Uplaod Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isimage_selected = false;
  bool image_show_containervisible = false;
  File? _imageFile;

  //initialize Progressbar
  late ProgressDialog pr;

  final mobile = TextEditingController();
  final name = TextEditingController();
  final place = TextEditingController();
  final age = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //initialize Progressbar design & style
    pr = new ProgressDialog(context, showLogs: true);

    //in this you can your Progressbar message to anything like loading,waiting..etc.
    pr.style(message: 'Please wait...');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: Image.asset('assets/images/bg.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.fitWidth),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: name,
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_pin),
                            hintText: 'Name',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: mobile,
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            hintText: 'Mobile',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "User Information",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: place,
                          autofocus: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.place),
                            hintText: 'Place',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: age,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: 'Age',
                            prefixIcon: Icon(Icons.image_aspect_ratio),
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: height,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: 'Address',
                            prefixIcon: Icon(Icons.view_headline),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: weight,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: 'Pincode',
                            prefixIcon: Icon(Icons.border_color),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 33),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.deepOrange,
                      child: Center(
                          child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  onTap: () {
                    if (isimage_selected == false) {
                      final snackBar =
                          SnackBar(content: Text("Select or Capture Image"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else if(name.text.length == 0)
                      {
                        final snackBar =
                        SnackBar(content: Text("Enter your name"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    else if(mobile.text.length == 0)
                    {
                      final snackBar =
                      SnackBar(content: Text("Enter your mobile number"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else if(place.text.length == 0)
                    {
                      final snackBar =
                      SnackBar(content: Text("Enter your place"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else {
                      register(
                          _imageFile!,
                          name.text,
                          mobile.text,
                          place.text,
                          age.text,
                          height.text,
                          weight.text);
                    }
                  },
                ),
              ],
            ),

            //Image

            GestureDetector(
              onTap: () {
                openImagePickerModal(context);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 90, left: 20),
                child: _imageFile == null
                    ? CircleAvatar(
                        backgroundImage: AssetImage("assets/images/user.jpg"),
                        radius: 55.0)
                    : CircleAvatar(
                        backgroundImage: FileImage(_imageFile!), radius: 55.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register(File image, String name, String mobile, String place, String age, String height, String weight,) async {
    //show progressbar
    await pr.show();

    final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
    if (mimeTypeData == null) {
      // Handle the case where the MIME type could not be determined
      await pr.hide();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not determine file type')));
      return;
    }
    final request = new http.MultipartRequest("POST", Uri.parse(Urls.ImageInsert));
    final file = await http.MultipartFile.fromPath('Photo', image.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    request.fields['Full_Name'] = name;
    request.fields['Mobile_Number'] = mobile;
    request.fields['Age'] = age;
    request.fields['Location'] = place;
    request.fields['Height'] = height;
    request.fields['Weight'] = weight;
    request.files.add(file);

    StreamedResponse response = await request.send();

    //waiting for response
    response.stream.transform(utf8.decoder).listen((value) async {
      //Response can be pass with map object to alertbox
      Map<String, dynamic> map = jsonDecode(value);
      try {
        // hide progrssbar
        await pr.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert"),
              //here we show response message from api
              content: Text(map['message']),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    //Do Something here
                  },
                )
              ],
            );
          },
        );
      } catch (e) {
        e.toString();
      }
    });
  }

  //Image Picker For Pick image from gallery or Camera

  void Pickimage(BuildContext context, ImageSource source) async {
      final image = await ImagePicker().pickImage(
          source: source, imageQuality: 50, maxHeight: 500, maxWidth: 500);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          isimage_selected = true;
          image_show_containervisible = true;
        });
      }
    Navigator.pop(context);
  }

  //Image Picker Model,For Select Images or Capture Image

  void openImagePickerModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 180.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pick An Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextButton(
                  child: Text(
                    'Use Camera',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    Pickimage(context, ImageSource.camera);
                  },
                ),
                TextButton(
                  child: Text(
                    'Use Gallery',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    Pickimage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }
}
