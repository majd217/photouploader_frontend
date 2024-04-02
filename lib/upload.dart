import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadYourPhotos extends StatefulWidget {
  @override
  State<UploadYourPhotos> createState() => UploadYourPhotosState();
}

class UploadYourPhotosState extends State<UploadYourPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: .8,
                  image: AssetImage('assets/images/background.JPG'),
                  fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 8,
                child: Center(
                  child: Text(
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: GoogleFonts.greatVibes().fontFamily,
                          fontSize: 20,
                          color: Color.fromARGB(255, 101, 100, 100)),
                      'Thank you for joining our special day. We would love to see all the beautiful moments you have captured!'),
                ),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'upload',
                    textAlign: TextAlign.center,
                  ))
            ],
          )),
    );
  }
}
