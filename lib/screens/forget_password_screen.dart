import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skyways_group/constants/constant.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
          children: [
             Positioned(
                 right: 0,
                 child: SvgPicture.asset('assets/svg/mask_group.svg')
             ),
             SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.only(left:10.0,top:60.0),
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Row(
                         children: [
                            Container(
                              height: 20,
                              child: Image.asset('assets/icons/back.png'),
                            ),
                            const Expanded(
                                child: Text("Forget Password", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold))),
                         ],
                       ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.16,
                                width: double.infinity,
                                child: SvgPicture.asset('assets/svg/forgott_password.svg'),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                              Text("We will send a mail to the email", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                              SizedBox(height: 2.0),
                              Text("address you registered to regain your", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                              SizedBox(height: 2.0),
                              Text("password", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(left:60.0, top: 10.0, right: 60.0, bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _textFieldOTP(first: true, last: false),
                                    _textFieldOTP(first: false, last: false),
                                    _textFieldOTP(first: false, last: false),
                                    _textFieldOTP(first: false, last: true),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container (
                                    decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.white, width: 1),
                                        )),
                                    child: const Text(
                                      "Don't receive OTP?" ,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(width: 3.0),
                                  Container (
                                    decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.white, width: 1),
                                        )),
                                    child: const Text(
                                      'Resend OTP',
                                      style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                      child: Text(
                                        "Send",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                      SizedBox(height: 10.0)
                    ],
                 ),
               )
             )
          ],
       ),
    );
  }

  /*AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Icon(
        Icons.arrow_back_ios,
        size: 18.0,
        color: Colors.black,
      ),
      centerTitle: true,
      title: Text("Forget Password", style: TextStyle(color: Colors.black, fontSize: 16.0)),
    );
  }*/

  Widget _textFieldOTP({bool first, last}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.14,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 2.0),
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
