import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opt_autofill_ps/sample_strategy.dart';
import 'package:otp_autofill/otp_autofill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 5,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{5})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        SampleStrategy(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }
}