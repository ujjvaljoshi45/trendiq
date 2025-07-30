import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/constants/route_key.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_event.dart';
import 'package:trendiq/services/theme/theme_state.dart';
import 'package:trendiq/models/user_model.dart';
import 'package:trendiq/services/tools.dart';
import 'package:trendiq/views/auth_view/bloc/auth_bloc.dart';
import 'package:trendiq/views/auth_view/bloc/auth_event.dart';
import 'package:trendiq/views/auth_view/bloc/auth_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final AuthBloc authBloc;
  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoadingState) {
              return Skeletonizer(
                enabled: true,
                child: _buildAuthenticatedProfile(context, null),
              );
            } else if (authState is AuthLoadedState) {
              return _buildAuthenticatedProfile(context, authBloc.user);
            } else {
              return _buildUnauthenticatedProfile(context);
            }
          },
        );
      },
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context, UserModel? user) {
    final userName = user?.username ?? "";
    final userEmail = user?.email ?? "";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Profile Header with Avatar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appColors.primary,
                  Color.fromARGB(
                    255,
                    (appColors.primary.red - 40).clamp(0, 255),
                    (appColors.primary.green - 20).clamp(0, 255),
                    (appColors.primary.blue - 20).clamp(0, 255),
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar Section
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.background,
                    border: Border.all(
                      color: appColors.background,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: _buildAvatarFallback(userName)),
                ),
                8.sBh,
                // User Name
                Text(
                  userName,
                  style: commonTextStyle(
                    fontSize: 18,
                    color: appColors.onPrimary,
                    fontFamily: Fonts.fontBold,
                  ),
                ),
                3.sBh,
                // User Email
                Text(
                  userEmail,
                  style: commonTextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    fontFamily: Fonts.fontRegular,
                  ),
                ),
              ],
            ),
          ),
          // Statistics Row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                _buildStatItem(context, "3", "Orders"),
                Container(
                  height: 40,
                  width: 1.2,
                  color: Color.fromRGBO(
                    appColors.outline.red,
                    appColors.outline.green,
                    appColors.outline.blue,
                    0.5,
                  ),
                ),
                _buildStatItem(context, "7", "Wishlist"),
                if (user?.createdAt != null) ...[
                  Container(
                    height: 40,
                    width: 1.2,
                    color: Color.fromRGBO(
                      appColors.outline.red,
                      appColors.outline.green,
                      appColors.outline.blue,
                      0.5,
                    ),
                  ),
                  _buildStatItem(
                      context, getDateStr(user!.createdAt), "Member Since",
                      headerFontSize: 14),
                ]
              ],
            ),
          ),
          // Main Menu Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Account Settings Section
                _buildSectionHeader("Account Settings"),
                // _buildProfileMenuItem(
                //   context,
                //   icon: Icons.person_outline,
                //   title: "Personal Information",
                //   subtitle: "Update your personal details",
                //   onTap: () {},
                // ),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  title: "Orders",
                  subtitle: "View Orders",
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesKey.order),
                ),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: "Update Password",
                  subtitle: "Change your password",
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesKey.updatePassword),
                ),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: "My Addresses",
                  subtitle: "Manage your delivery addresses",
                  onTap: () {
                    Navigator.pushNamed(context, RoutesKey.address);
                  },
                ),
                // Preferences Section
                _buildSectionHeader("Preferences"),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  subtitle: "Switch between light & dark theme",
                  toggle: true,
                  toggleValue: appColors.isDark,
                  onTap: () {
                    BlocProvider.of<ThemeBloc>(context).add(
                        appColors.isDark ? SetLightTheme() : SetDarkTheme());
                  },
                ),
                // Support Section
                _buildSectionHeader("Support"),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  subtitle: "Get assistance with your orders",
                  onTap: () {
                    Navigator.pushNamed(context, RoutesKey.support);
                  },
                ),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  subtitle: "Read about our terms of service",
                  onTap: () {
                    launchUrl("https://trendiq-fe.vercel.app/profile?tab=terms");
                  },
                ),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  subtitle: "How we handle your data",
                  onTap: () {
                    launchUrl("https://trendiq-fe.vercel.app/profile?tab=terms");
                  },
                ),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: appColors.primary,
                        width: 1.5,
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
                      },
                      icon: Icon(
                        Icons.logout,
                        color: appColors.primary,
                      ),
                      label: Text(
                        "Log Out",
                        style: commonTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: appColors.primary,
                          fontFamily: Fonts.fontSemiBold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or Icon
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Color.fromRGBO(
                  appColors.primary.red,
                  appColors.primary.green,
                  appColors.primary.blue,
                  0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 80,
                color: appColors.primary,
              ),
            ),
            const SizedBox(height: 30),
            // Title
            Text(
              "Personalize Your TrendIQ Experience",
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appColors.onBackground,
                fontFamily: Fonts.fontBold,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              "Sign in to view your profile, track orders, save your favorite items, and get personalized recommendations.",
              textAlign: TextAlign.center,
              style: commonTextStyle(
                fontSize: 16,
                color: Color.fromRGBO(
                  appColors.onBackground.red,
                  appColors.onBackground.green,
                  appColors.onBackground.blue,
                  0.7,
                ),
                fontFamily: Fonts.fontRegular,
              ),
            ),
            const SizedBox(height: 40),
            // Login Button
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    appColors.primary,
                    Color.fromARGB(
                      255,
                      (appColors.primary.red - 40).clamp(0, 255),
                      (appColors.primary.green - 20).clamp(0, 255),
                      (appColors.primary.blue - 20).clamp(0, 255),
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RoutesKey.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: appColors.onPrimary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Sign In",
                  style: commonTextStyle(
                    fontSize: 16,
                    color: appColors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.fontSemiBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Register Text
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RoutesKey.register);
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
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
                    TextSpan(
                      text: "Register",
                      style: commonTextStyle(
                        fontSize: 14,
                        color: appColors.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.fontSemiBold,
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

  // Helper Widgets
  Widget _buildAvatarFallback(String userName) {
    final initials = userName.isNotEmpty
        ? userName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase()
        : 'U';

    return Container(
      color: appColors.primary,
      child: Center(
        child: Text(
          initials.length > 2 ? initials.substring(0, 2) : initials,
          style: commonTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appColors.onPrimary,
            fontFamily: Fonts.fontBold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label,
      {double? headerFontSize}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 2,
              style: commonTextStyle(
                fontSize: headerFontSize ?? 22,
                fontWeight: FontWeight.bold,
                color: appColors.primary,
                fontFamily: Fonts.fontBold,
              ),
            ),
            3.sBh,
            Text(
              label,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: commonTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: appColors.onBackground,
              fontFamily: Fonts.fontSemiBold,
            ),
          ),
          8.sBw,
          Expanded(
            child: Container(
              height: 1,
              color: Color.fromRGBO(
                appColors.outline.red,
                appColors.outline.green,
                appColors.outline.blue,
                0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        String? badge,
        bool toggle = false,
        bool toggleValue = false,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color.fromRGBO(
            appColors.outline.red,
            appColors.outline.green,
            appColors.outline.blue,
            0.3,
          ),
          width: 1,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon with background
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      appColors.primary.red,
                      appColors.primary.green,
                      appColors.primary.blue,
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: appColors.primary, size: 22),
                ),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: commonTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.onBackground,
                          fontFamily: Fonts.fontMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: commonTextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(
                            appColors.onBackground.red,
                            appColors.onBackground.green,
                            appColors.onBackground.blue,
                            0.6,
                          ),
                          fontFamily: Fonts.fontRegular,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge, toggle or chevron
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: commonTextStyle(
                        fontSize: 12,
                        color: appColors.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.fontSemiBold,
                      ),
                    ),
                  )
                else if (toggle)
                  Switch(
                    value: toggleValue,
                    onChanged: (_) => onTap(),
                    activeColor: appColors.primary,
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: Color.fromRGBO(
                      appColors.onBackground.red,
                      appColors.onBackground.green,
                      appColors.onBackground.blue,
                      0.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}