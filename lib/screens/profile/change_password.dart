import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleOldPasswordVisibility() {
    setState(() {
      _showOldPassword = !_showOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _showNewPassword = !_showNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password change logic.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ubah Kata Sandi',
          style: TextStyle(fontSize: 18),
          // textAlign: TextAlign.center,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(

          child: Column(
            children: [
              Container(
                color: Colors.deepPurple.shade700,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kata Sandi Lama",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextFormField(
                              controller: _oldPasswordController,
                              obscureText: !_showOldPassword,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 21, vertical: 10),
                                // labelText: 'Old Password',
                                hintText: 'Masukkan kata sandi lama',
                                suffixIcon: IconButton(
                                  icon: Icon(_showOldPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _toggleOldPasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'kata sandi tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kata Sandi Baru",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: !_showNewPassword,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 21, vertical: 10),
                                // labelText: 'Old Password',
                                hintText: 'Masukkan kata sandi lama',
                                suffixIcon: IconButton(
                                  icon: Icon(_showNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _toggleNewPasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'kata sandi tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      // TextFormField(
                      //   controller: _newPasswordController,
                      //   obscureText: !_showNewPassword,
                      //   decoration: InputDecoration(
                      //     labelText: 'Kata Sandi Baru',
                      //     suffixIcon: IconButton(
                      //       icon: Icon(_showNewPassword
                      //           ? Icons.visibility
                      //           : Icons.visibility_off),
                      //       onPressed: _toggleNewPasswordVisibility,
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'New password cannot be empty.';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kata Sandi Baru",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_showConfirmPassword,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 21, vertical: 10),
                                // labelText: 'Old Password',
                                hintText: 'Konfirmasi Kata Sandi Baru',
                                suffixIcon: IconButton(
                                  icon: Icon(_showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: _toggleConfirmPasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'kata sandi tidak boleh kosong.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      // TextFormField(
                      //   controller: _confirmPasswordController,
                      //   obscureText: !_showConfirmPassword,
                      //   decoration: InputDecoration(
                      //     labelText: 'Confirm Password',
                      //     suffixIcon: IconButton(
                      //       icon: Icon(_showConfirmPassword
                      //           ? Icons.visibility
                      //           : Icons.visibility_off),
                      //       onPressed: _toggleConfirmPasswordVisibility,
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Confirm password cannot be empty.';
                      //     }
                      //     if (value != _newPasswordController.text) {
                      //       return 'Passwords do not match.';
                      //     }
                      //     return null;
                      //   },
                      // ),

                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: Colors.amber,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
