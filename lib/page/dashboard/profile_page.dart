
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_store/bloc/profile/profile_bloc.dart';
import 'package:food_store/core/constants/app_config.dart';
import 'package:food_store/core/utils/error_handle.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formProfileKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  final ImagePicker _picker = ImagePicker();

  XFile? _image;
  Uint8List? _imageBytes;

  String? _avatarUrl;

  Map<String, String> _errorMessages = {};

  Future<void> getImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          _image = pickedFile;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackbar('Gagal memilih gambar: $e', Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          loadedProfile: (customer) {
            _fullNameController.text = customer.name.toString();
            _emailController.text = customer.email.toString();

            setState(() {
              _avatarUrl = customer.image == null ||
                      customer.image!.isEmpty
                  ? null
                  : '${AppConfig.STORAGE_AVATAR}${customer.image}';

              _errorMessages = {};
            });
          },
          updatedProfile: (message) {
            _passwordController.clear();
            _confirmPasswordController.clear();
            _image = null;
            _imageBytes = null;
            _errorMessages = {};

            ScaffoldMessenger.of(context).showSnackBar(
              _buildSnackbar(message, Colors.green),
            );

            context.read<ProfileBloc>().add(
                  const ProfileEvent.loadProfile(),
                );
          },
          failure: (error) {
            setState(() {
              _errorMessages = ErrorHandler.parseErrors(error);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              _buildSnackbar(
                error['message']?.toString() ??
                    'Gagal memperbarui profil',
                Colors.red,
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              _buildSnackbar(message, Colors.red),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formProfileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // FOTO PROFIL
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : _avatarUrl != null
                                      ? NetworkImage(_avatarUrl!)
                                      : null,
                              child: _imageBytes == null &&
                                      _avatarUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 55,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: getImage,
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.deepOrange,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _textFieldFullName(),

                      const SizedBox(height: 14),

                      _textFieldEmail(),

                      const SizedBox(height: 14),

                      _textFieldPassword(),

                      const SizedBox(height: 14),

                      _textFieldConfirmPassword(),

                      const SizedBox(height: 22),

                      _buttonUpdateProfile(isLoading),
                    ],
                  ),
                ),
              ),

              if (isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _textFieldFullName() {
    return TextFormField(
      controller: _fullNameController,
      focusNode: _fullNameFocus,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person_outline),
        errorText: _errorMessages['name'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget _textFieldEmail() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        errorText: _errorMessages['email'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }

        final emailRegex = RegExp(
          r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$',
        );

        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email';
        }

        return null;
      },
    );
  }

  Widget _textFieldPassword() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: _errorMessages['password'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
    );
  }

  Widget _textFieldConfirmPassword() {
    return TextFormField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocus,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: _errorMessages['password_confirmation'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (_passwordController.text.isNotEmpty &&
            value != _passwordController.text) {
          return 'Password confirmation does not match';
        }

        return null;
      },
    );
  }

  Widget _buttonUpdateProfile(bool isLoading) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (_formProfileKey.currentState!.validate()) {
                  setState(() {
                    _errorMessages = {};
                  });

                  context.read<ProfileBloc>().add(
                        ProfileEvent.updateProfile(
                          name: _fullNameController.text.trim(),
                          email: _emailController.text.trim(),
                          image: _image,
                          password: _passwordController.text.isEmpty
                              ? null
                              : _passwordController.text,
                          passwordConfirmation:
                              _confirmPasswordController.text.isEmpty
                                  ? null
                                  : _confirmPasswordController.text,
                        ),
                      );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.orange.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnackbar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      showCloseIcon: true,
    );
  }
}
