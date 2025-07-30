
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/common/loading_dialog.dart';
import 'package:trendiq/constants/keys.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/extensions.dart';

import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      authBloc.add(
        AuthLoginEvent(_emailController.text, _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        backgroundColor: appColors.background,
        automaticallyImplyLeading: false,
        title: GestureDetector(
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
      ),
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
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appLogoWidget(),
                            14.sBh,
                            // App Name
                            Center(
                              child: Text(
                                "TrendIQ",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: appColors.onBackground,
                                  fontFamily: Fonts.fontBold,
                                ),
                              ),
                            ),
                            4.sBh,
                            // App Tagline
                            Center(
                              child: Text(
                                "Stay ahead of the curve",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: appColors.onBackground.withOpacity(
                                    0.7,
                                  ),
                                  fontFamily: Fonts.fontRegular,
                                ),
                              ),
                            ),
                            30.sBh,
                            // Welcome Back Text
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: appColors.onBackground,
                                fontFamily: Fonts.fontSemiBold,
                              ),
                            ),
                            4.sBh,
                            Text(
                              "Sign in to continue with your account",
                              style: TextStyle(
                                fontSize: 14,
                                color: appColors.onBackground.withOpacity(0.7),
                                fontFamily: Fonts.fontRegular,
                              ),
                            ),
                            15.sBh,
                            // Email Field
                            buildInputLabel("Email", size: 16),
                            5.sBh,
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: appColors.primary,
                              style: TextStyle(
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
                            buildInputLabel("Password", size: 16),
                            5.sBh,
                            passwordTextForm(
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            20.sBh,
                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appColors.primary,
                                  foregroundColor: appColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Fonts.fontSemiBold,
                                  ),
                                ),
                              ),
                            ),
                            15.sBh,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    toast(
                                      "Our Backend Developers are working on this feature.",
                                    );
                                  },
                                  child: buildInputLabel(
                                    "Forget Password?",
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            15.sBh,
                            // Divider
                            orContinueWithDivider(),
                            15.sBh,
                            // Social Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildSocialButton(
                                  Icons.g_mobiledata,
                                  "Google",
                                  () {
                                    authBloc.add(
                                      AuthSocialLoginEvent(Keys.google, false),
                                    );
                                  },
                                ),
                                // 20.sBw,
                                // buildSocialButton(
                                //   Icons.facebook,
                                //   "Facebook",
                                //   () {
                                //     authBloc.add(
                                //       AuthSocialLoginEvent(
                                //         Keys.facebook,
                                //         false,
                                //       ),
                                //     );
                                //   },
                                // ),
                                // if (Platform.isIOS) ...[
                                //   20.sBw,
                                //   buildSocialButton(Icons.apple, "Apple", () {
                                //     authBloc.add(
                                //       AuthSocialLoginEvent(Keys.apple, false),
                                //     );
                                //   }),
                                // ],
                              ],
                            ),
                            20.sBh,
                            // Sign Up Text
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: commonTextStyle(
                                    fontSize: 14,
                                    color: appColors.onBackground.withOpacity(
                                      0.7,
                                    ),
                                    fontFamily: Fonts.fontRegular,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap:
                                            () => Navigator.pushNamed(
                                              context,
                                              RoutesKey.register,
                                            ),
                                        child: Text(
                                          "Sign Up",
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {
              if (state is AuthErrorState) {
                toast(state.message, isError: true);
              }
              if (state is AuthLoadedState) {
                Navigator.pop(context);
              }

              if (state is AuthLoadingState) {
                LoadingDialog.show(context);
              } else {
                LoadingDialog.hide(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
