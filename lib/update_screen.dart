import 'package:flutter/material.dart';
import 'package:do_an_1/database/database_helper.dart';
import 'package:do_an_1/database/user.dart';

class UpdateAccountScreen extends StatefulWidget {
  final int userId;
  final String? email;
  const UpdateAccountScreen({Key? key, required this.userId, this.email}) : super(key: key);

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;
  String currentUsername = '';
  String? storedPassword;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      User? user = await dbHelper.getUserByUserId(widget.userId);
      if (user != null) {
        setState(() {
          currentUsername = user.username ?? '';
          _usernameController.text = user.username ?? '';
          storedPassword = user.password;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user info: $e')),
      );
    }
  }

  bool _validateForm() {
    if (_usernameController.text.isEmpty ||
        _oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ')),
      );
      return false;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới và nhập lại không khớp')),
      );
      return false;
    }
    if (_oldPasswordController.text != storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu hiện tại không chính xác')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cập nhật tài khoản'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'Tên đăng nhập hiện tại: $currentUsername',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người dùng mới',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _oldPasswordController,
                obscureText: _isObscureOld,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureOld ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureOld = !_isObscureOld;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _newPasswordController,
                obscureText: _isObscureNew,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureNew ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureNew = !_isObscureNew;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirm = !_isObscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    try {
                      User user = User(
                        userId: widget.userId,
                        email: widget.email,
                        username: _usernameController.text,
                        password: _newPasswordController.text,
                      );
                      await dbHelper.updateUser(user);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật thành công')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Update failed: $e')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
