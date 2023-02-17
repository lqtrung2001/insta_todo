import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:insta_todo/utils/colors.dart';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
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
              children: const [
                CircleAvatar(
                  radius: 64,
                    backgroundImage: AssetImage("assets/anime.jpg",),
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
                    onTap: () {},
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
