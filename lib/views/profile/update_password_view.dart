import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final etPassword = TextEditingController();
  final etNewPassword = TextEditingController();
  final etConfirmPassword = TextEditingController();
  late final AuthBloc authBloc;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    etPassword.dispose();
    etNewPassword.dispose();
    etConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      appBar: CommonAppBar(title: "Update Password"),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Skeletonizer(
            enabled: state is AuthUpdatePasswordLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Icon(
                        Icons.lock_outline,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Change your password",
                        style: commonTextStyle(
                          fontSize: 20,
                          fontFamily: Fonts.fontSemiBold,
                          color: appColors.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please enter your current password and a new password",
                        style: commonTextStyle(
                          color: appColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _buildPasswordField(
                        controller: etPassword,
                        label: "Current Password",
                        obscureText: _obscureCurrentPassword,
                        toggleObscure: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                        validator: (value) => (value?.isEmpty ?? true)
                            ? "Please enter your current password"
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        controller: etNewPassword,
                        label: "New Password",
                        obscureText: _obscureNewPassword,
                        toggleObscure: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter a new password";
                          }
                          if ((value?.length ?? 0) < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        controller: etConfirmPassword,
                        label: "Confirm New Password",
                        obscureText: _obscureConfirmPassword,
                        toggleObscure: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) => (value != etNewPassword.text)
                            ? "Passwords don't match"
                            : null,
                      ),
                      const SizedBox(height: 40),
                      _buildUpdateButton(state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is AuthUpdatePasswordDone) {
            if (state.errorMsg != null) {
              ToastService().showToast(state.errorMsg!);
            } else {
              ToastService().showToast("Password updated successfully");

              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleObscure,
    required String? Function(String?) validator,
  }) {
    final appColors = AppColors();

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: commonTextStyle(color: appColors.onBackground),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: commonTextStyle(color: appColors.onSurfaceVariant),
        fillColor: appColors.surfaceVariant.withOpacity(0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: appColors.onSurfaceVariant,
          ),
          onPressed: toggleObscure,
        ),
      ),
    );
  }

  Widget _buildUpdateButton(AuthState state) {
    final appColors = AppColors();
    final isLoading = state is AuthUpdatePasswordLoading;

    return ElevatedButton(
      onPressed: isLoading ? null : _updatePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.primary,
        foregroundColor: appColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: appColors.onPrimary,
        ),
      )
          : Text(
        "Update Password",
        style: commonTextStyle(
          fontFamily: Fonts.fontMedium,
          fontSize: 16,
          color: appColors.onPrimary,
        ),
      ),
    );
  }

  void _updatePassword() {
    FocusScope.of(context).unfocus();
    if (!_validateForm()) {
      return;
    }
    etPassword.clear();
    etNewPassword.clear();
    etConfirmPassword.clear();
    authBloc.add(AuthUpdatePasswordEvent(etPassword.text, etNewPassword.text));
  }

  bool _validateForm() => _formKey.currentState?.validate() ?? false;
}