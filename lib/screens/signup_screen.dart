import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_todo/resources/auth_methods.dart';
import 'package:insta_todo/responsive/mobile_screen_layout.dart';
import 'package:insta_todo/responsive/responsive_layout.dart';
import 'package:insta_todo/screens/login_screen.dart';

import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    if (_image==null) {
      _image = Uint8List(0);
    }

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //img
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(height: 50),
            //avatar image
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!),
                  backgroundColor: Colors.red,
                )
                    : const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://i.stack.imgur.com/l60Hf.png'),
                  backgroundColor: Colors.red,
                ),
                Positioned(
                  bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)
                    )
                )
              ],
            ),
            const SizedBox(height: 50),
            //text input email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Nhập email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),

            //text in put pass
            TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Nhập mật khẩu',
                textInputType: TextInputType.text,
                isPass: true),
            const SizedBox(
              height: 24,
            ),

            //text username
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Nhập tên',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),

            //text bio
            TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Nhập giới thiệu',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),

            // nút đăng nhập
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor,
                ),
                child: const Text('Đăng kí'),
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            // nút đăng kí
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('Bạn đã có tài khoản ? '),
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
