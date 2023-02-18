import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_todo/responsive/mobile_screen_layout.dart';

import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/widgets/text_field_input.dart';
import 'package:path/path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
            const SizedBox(height: 64),

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

            // nút đăng nhập
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MobileScreenLayout()),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor,
                ),
                child: const Text('Đăng nhập'),
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
                  child: const Text('Bạn chưa có tài khoản ? '),
                ),
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Đăng kí',
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
