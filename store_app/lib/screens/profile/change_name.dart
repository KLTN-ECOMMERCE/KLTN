import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/screens/profile/my_profile.dart';
import 'package:store_app/screens/success/success.dart';
import 'package:store_app/utils/constants.dart';

// Undone
class ChangeNameScreen extends StatefulWidget {
  const ChangeNameScreen({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<ChangeNameScreen> createState() {
    return _ChangeNameState();
  }
}

class _ChangeNameState extends State<ChangeNameScreen> {
  var _enteredName = '';
  final _formKey = GlobalKey<FormState>();
  var _isAuthenticating = false;
  var _hasMessage = false;
  var errorApi = '';
  final ApiUser _apiUser = ApiUser();

  void _changeName() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _apiUser.changeName(
        _enteredName,
        widget.email,
      );

      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyProfileScreen(),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(
            text: 'Change Name Success',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        errorApi = e.toString();
        _isAuthenticating = false;
        _hasMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'CHANGE NAME',
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
                      'Please, enter your new name to display',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (newValue) => _enteredName = newValue!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return kNamelNullError;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Name',
                              hintText: 'Enter your new name',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: 'assets/icons/User Icon.svg',
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
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
                                errorApi,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isAuthenticating)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _changeName,
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
