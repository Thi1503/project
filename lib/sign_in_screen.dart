import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image(image: AssetImage('assets/todolist.png')),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          hintText: 'Tên đăng nhập',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15), // Thêm khoảng cách giữa hai ô nhập
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        obscureText:
                            _isObscure, // Sử dụng trạng thái _isObscure để ẩn hoặc hiển thị mật khẩu
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          hintText: 'Mật khẩu',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
