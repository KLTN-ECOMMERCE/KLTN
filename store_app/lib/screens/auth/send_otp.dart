import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/models/send_otp.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<SendOtpScreen> createState() {
    return _SendOtpState();
  }
}

class _SendOtpState extends State<SendOtpScreen> {
  final _otpController = TextEditingController();
  var _isAuthenticating = false;
  var _hasMessage = false;
  dynamic _responseSendOtp;

  final ApiStart _apiStart = ApiStart();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() async {
    final data = SendOTP(
      email: widget.email,
      otp: int.parse(_otpController.text),
    );
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final responseSendOtp = await _apiStart.sendOtp(data);
      _responseSendOtp = responseSendOtp;
      setState(() {
        _isAuthenticating = false;
        _hasMessage = true;
      });
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _hasMessage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'VERIFY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please, enter your OTP which sent to your email',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: _otpController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surfaceColor,
                          labelText: 'OTP Code',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      if (_isAuthenticating)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (_hasMessage)
                        Center(
                          child: Text(
                            _responseSendOtp['message'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      if (!_isAuthenticating && !_hasMessage)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _verify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'SEND',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
