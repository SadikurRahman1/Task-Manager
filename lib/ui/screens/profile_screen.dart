import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/snack_bar_massage.dart';
import 'package:task_manager/ui/widgets/tm_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _UpdateProfileinProgress = false;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Update Profile',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                _buildPhotoPicker(),
                const SizedBox(height: 16),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                    controller: _firstNameEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter Your First name';
                      }
                      return null;
                    }),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter Your Last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mobileTEController,
                  decoration: const InputDecoration(
                    hintText: 'Phone',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter Mobile Number';
                      // } else if (value?.length != 11) {
                      //   return 'Please enter the correct number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_UpdateProfileinProgress,
                  replacement: const CircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickerImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            Text(_getSelectedPhotoTitle())
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    _UpdateProfileinProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody["password"] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody["photo"] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );
    _UpdateProfileinProgress = false;
    setState(() {});
    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMassage(context, 'Profile has been Update');
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

  String _getSelectedPhotoTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return 'Select Photo';
  }

  Future<void> _pickerImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }
}
