// Flutter imports:

// Flutter imports:

import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'constants.dart';
import 'login_service.dart';
import 'util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _userIDTextCtrl = TextEditingController(text: 'user_id');
  final _passwordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    getUniqueUserId().then((userID) async {
      setState(() {
        _userIDTextCtrl.text = userID;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          return ZegoUIKit().onWillPop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              const SizedBox(height: 50),
              userIDEditor(),
             /* passwordEditor(),*/
              const SizedBox(height: 30),
              signInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: RichText(
        text: const TextSpan(
          text: 'So',
          style: TextStyle(color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
              text: 'ul',
              style: TextStyle(color: Colors.purpleAccent),
            ),
            TextSpan(text: 'mate'),
          ],
        ),
      ),
    );
  }

  Widget userIDEditor() {
    return TextFormField(
      controller: _userIDTextCtrl,
      decoration: const InputDecoration(
        labelText: 'Phone Num.(User for user id)',
      ),
    );
  }

/*
  Widget passwordEditor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, isPasswordVisible, _) {
        return TextFormField(
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password.(Any character for test)',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                _passwordVisible.value = !_passwordVisible.value;
              },
            ),
          ),
        );
      },
    );
  }
*/

  Widget signInButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purpleAccent,
      ),
      onPressed: ()  {

        if(_userIDTextCtrl.text.isNotEmpty)
          {
            login(
              userID: _userIDTextCtrl.text,
              userName: 'user_${_userIDTextCtrl.text}',
              context: context
            );
          }
        else
          {
            const snackBar = SnackBar(
              content: Text('User Id Should not be Empty'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }



            },
      child: const Text('Sign In', style: TextStyle(color: Colors.white)),
    );
  }
}
