import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/models/reset_password.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _isAuthenticating = false;
  dynamic _responseResetPassword;
  var _hasMessage = false;

  final ApiStart _apiStart = ApiStart();

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    final data = ResetPassword(
      password: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
      otp: int.parse(_otpController.text),
    );
    try {
      setState(() {
        _isAuthenticating = true;
      });
      _responseResetPassword = await _apiStart.resetPassword(data);
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
              'PASSWORD RECOVERY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please, enter your OTP code and new password. If your OTP code is correct, your password will be changed',
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
                    TextField(
                      controller: _newPasswordController,
                      maxLength: 100,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: surfaceColor,
                        labelText: 'New Password',
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
                    TextField(
                      controller: _confirmPasswordController,
                      maxLength: 100,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: surfaceColor,
                        labelText: 'Confirm New Password',
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
                          _responseResetPassword,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: const Text(
                          'SUBMIT',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
