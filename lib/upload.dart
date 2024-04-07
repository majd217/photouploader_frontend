import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class UploadYourPhotos extends StatefulWidget {
  const UploadYourPhotos({super.key});

  @override
  State<UploadYourPhotos> createState() => UploadYourPhotosState();
}

class UploadYourPhotosState extends State<UploadYourPhotos> {
  bool isUploading = false;

  void pickFiles() async {
    var pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.media, withReadStream: true);
    if (pickedFiles == null) {
      return;
    }
    uploadPhotosRequest(pickedFiles.files);
  }

  uploadPhotosRequest(List<PlatformFile> files) async {
    var postUri = Uri.parse('http://localhost:8080/photo/upload');
    var request = http.MultipartRequest(
      'POST',
      postUri,
    );

    for (var element in files) {
      if (element.readStream == null) {
        continue;
      }
      request.files.add(http.MultipartFile(
          'images', element.readStream!.asBroadcastStream(), element.size,
          filename: element.name));
    }
    setState(() {
      isUploading = true;
    });
    late ToastificationType toastificationType;
    late String toastText;
    late Icon icon;
    try {
      http.StreamedResponse response = await request.send();
      switch (response.statusCode) {
        case HttpStatus.ok:
          {
            print('Media uploaded successfully!');
            toastText = 'Media uploaded successfully!';
            toastificationType = ToastificationType.success;
            icon = const Icon(Icons.check);
            break;
          }
        default:
          {
            print('Media was not uploaded!');
            toastText = 'Media was not uploaded!';
            toastificationType = ToastificationType.error;
            icon = const Icon(Icons.error);
            break;
          }
      }
    } catch (e) {
      print('Internal error occurred!');
      toastText = 'Internal error occurred!';
      toastificationType = ToastificationType.error;
      icon = const Icon(Icons.error);
    }

    if (mounted) {
      //FIXME bug in the library when close duration is longer than animation duration
      toastification.show(
        closeButtonShowType: CloseButtonShowType.none,
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
        icon: icon,
        title: Text(toastText),
        type: toastificationType,
        alignment: Alignment.topCenter,
        context: context,
      );
    }

    setState(() {
      isUploading = false;
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          color: const Color.fromARGB(255, 101, 101, 101)),
                      'Thank you for joining our special day. We would love to see all the beautiful moments you have captured!'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(100),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.85)),
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 181, 181, 181)
                                .withOpacity(.85)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                    onPressed: () {
                      pickFiles();
                    },
                    child: (isUploading == false)
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            height: 50,
                            child: Center(
                              child: Text(
                                'upload',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 101, 101, 101),
                                  fontSize: 24,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.cookie().fontFamily,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            child: const CircularProgressIndicator(
                                color: Color.fromARGB(255, 101, 101, 101)),
                          )),
              ),
            ],
          )),
    );
  }
}
