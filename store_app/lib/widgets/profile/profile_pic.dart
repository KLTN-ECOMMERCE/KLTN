import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/api/api_user.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final ApiUser _apiUser = ApiUser();
  File? _selectedImage;
  dynamic userAvatarData;

  Future<dynamic> _getUserAvatar() async {
    try {
      final response = await _apiUser.getProfile();
      final profile = response['user'];
      final avatar = profile['avatar'];
      if (avatar == null) {
        return;
      }
      final url = avatar['url'];
      if (url == null) {
        return null;
      }
      return url;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    print(_selectedImage!.path);
    _uploadAvatar(_selectedImage!);
  }

  Future<dynamic> _uploadAvatar(File image) async {
    try {
      await _apiUser.uploadAvatar('data:image/png;base64,${base64Encode(
        image.readAsBytesSync(),
      )}');
      setState(() {
        userAvatarData = _getUserAvatar();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    userAvatarData = _getUserAvatar();
    return FutureBuilder(
      future: userAvatarData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
          );
        } else {
          final avatar = snapshot.data;
          return SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: avatar != null
                      ? NetworkImage(avatar.toString())
                      : const AssetImage('assets/images/Profile Image.jpg')
                          as ImageProvider,
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        _takePicture();
                      },
                      child: SvgPicture.asset('assets/icons/Camera Icon.svg'),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
