import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class UploadYourPhotos extends StatefulWidget {
  const UploadYourPhotos({super.key});

  @override
  State<UploadYourPhotos> createState() => UploadYourPhotosState();
}

class UploadYourPhotosState extends State<UploadYourPhotos> {
  void pickFiles() async {
    var pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.media, withReadStream: true);
    uploadPhotosRequest(pickedFiles!.files);
  }

  uploadPhotosRequest(List<PlatformFile> files) async {
    var postUri = Uri.parse('http://192.168.68.50:8080/photo/upload');
    var request = http.MultipartRequest('POST', postUri);

    for (var element in files) {
      request.files.add(http.MultipartFile(
          'images', element.readStream!.asBroadcastStream(), element.size,
          filename: element.name));
    }
    print(request.contentLength);
    request.send().then((response) {
      switch (response.statusCode) {
        case HttpStatus.ok:
          {
            print('Media uploaded successfully!');
            break;
          }
        default:
          {
            print('Media was not uploaded!');
            break;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: .9,
                  image: AssetImage('assets/images/background.JPG'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 100,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.cookie().fontFamily,
                          fontSize: 20,
                          color: Color.fromARGB(255, 101, 101, 101)),
                      'Thank you for joining our special day. We would love to see all the beautiful moments you have captured!'),
                ),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.all(60),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(.85),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 101, 101, 101)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                    onPressed: () => pickFiles(),
                    child: Container(
                      child: Text(
                        'upload',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.cookie().fontFamily,
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 150)
            ],
          )),
    );
  }

  // void uploadPhotosRequest() {
  //   Webservices.webServices.uploadPhotosRequest(pickedFiles);
  //   print('step sent');
  // }
}
