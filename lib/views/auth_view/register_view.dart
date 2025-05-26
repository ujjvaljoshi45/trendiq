import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/loading_dialog.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late final AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      authBloc.add(
        AuthRegisterEvent(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          "empty",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                appColors.isDark ? Brightness.light : Brightness.dark,
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is AuthLoadingState,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(
                                  appColors.primary.red,
                                  appColors.primary.green,
                                  appColors.primary.blue,
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                  color: appColors.primary,
                                ),
                              ),
                            ),
                          ),
                          // App Logo with Animated Gradient
                          appLogoWidget(),
                          10.sBh,
                          // App Name
                          Center(
                            child: Text(
                              "Create Account",
                              style: commonTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: appColors.onBackground,
                                fontFamily: Fonts.fontBold,
                              ),
                            ),
                          ),
                          2.sBh,
                          // App Tagline
                          Center(
                            child: Text(
                              "Join the TrendIQ community",
                              style: commonTextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(
                                  appColors.onBackground.red,
                                  appColors.onBackground.green,
                                  appColors.onBackground.blue,
                                  0.7,
                                ),
                                fontFamily: Fonts.fontRegular,
                              ),
                            ),
                          ),
                          16.sBh,
                          // Full Name Field
                          buildInputLabel("Full Name"),
                          6.sBh,
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: appColors.primary,
                            style: commonTextStyle(
                              fontSize: 14,
                              color: appColors.onBackground,
                              fontFamily: Fonts.fontRegular,
                            ),
                            decoration: textFieldInputDecoration(
                              hintText: "Enter your full name",
                              prefixIcon: Icons.person_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              if (value.trim().split(' ').length < 2) {
                                return "Please enter your full name";
                              }
                              return null;
                            },
                          ),
                          10.sBh,
                          // Email Field
                          buildInputLabel("Email"),
                          6.sBh,
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: appColors.primary,
                            style: commonTextStyle(
                              fontSize: 16,
                              color: appColors.onBackground,
                              fontFamily: Fonts.fontRegular,
                            ),
                            decoration: textFieldInputDecoration(
                              hintText: "Enter your email",
                              prefixIcon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          10.sBh,
                          // Password Field
                          buildInputLabel("Password"),
                          6.sBh,
                          passwordTextForm(
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            hintText: "Create a password",
                          ),
                          10.sBh,

                          // Confirm Password Field
                          buildInputLabel("Confirm Password"),
                          6.sBh,
                          passwordTextForm(
                            passwordController: _confirmPasswordController,
                            obscurePassword: _obscureConfirmPassword,
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            hintText: "Confirm your password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          15.sBh,
                          // Register Button with Gradient
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  appColors.primary,
                                  Color.fromARGB(
                                    255,
                                    (appColors.primary.red - 40).clamp(0, 255),
                                    (appColors.primary.green - 20).clamp(
                                      0,
                                      255,
                                    ),
                                    (appColors.primary.blue - 20).clamp(0, 255),
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: appColors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                "Create Account",
                                style: commonTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Fonts.fontSemiBold,
                                ),
                              ),
                            ),
                          ),
                          16.sBh,
                          // Already have an account text
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: commonTextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(
                                    appColors.onBackground.red,
                                    appColors.onBackground.green,
                                    appColors.onBackground.blue,
                                    0.7,
                                  ),
                                  fontFamily: Fonts.fontRegular,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Sign In",
                                        style: commonTextStyle(
                                          fontSize: 14,
                                          color: appColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Fonts.fontSemiBold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          15.sBh,
                          // Divider
                          orContinueWithDivider(),
                          15.sBh,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildSocialButton(
                                Icons.g_mobiledata,
                                "Google",
                                () {
                                  authBloc.add(
                                    AuthSocialLoginEvent(Keys.google, true),
                                  );
                                },
                              ),
                              20.sBw,
                              buildSocialButton(Icons.facebook, "Facebook", () {
                                authBloc.add(
                                  AuthSocialLoginEvent(Keys.facebook, true),
                                );
                              }),
                              if (Platform.isIOS) ...[
                                20.sBw,
                                buildSocialButton(Icons.apple, "Apple", () {
                                  authBloc.add(
                                    AuthSocialLoginEvent(Keys.apple, true),
                                  );
                                }),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {
              if (state is AuthLoadingState) {
                LoadingDialog.show(context);
              } else {
                LoadingDialog.hide(context);
              }
              if (state is AuthLoadedState) {
                Navigator.pop(context);
              }
              if (state is AuthErrorState) {
                ToastService().showToast(state.message,isError: true);
              }
            },
          ),
        ),
      ),
    );
  }
}
