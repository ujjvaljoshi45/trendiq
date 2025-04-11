import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendiq/common/colors.dart';
import 'package:trendiq/common/common_text_field.dart';
import 'package:trendiq/services/theme/theme_bloc.dart';
import 'package:trendiq/services/theme/theme_event.dart';
import 'package:trendiq/services/theme/theme_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TrendiQ")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.tune),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Trendy Q"),
            ElevatedButton(onPressed: () {}, child: Text("Button")),
            TextButton(onPressed: () {}, child: Text("Text Button")),
            IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
            CommonTextField(),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                final themeMode = state.themeMode;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap:
                          () => context.read<ThemeBloc>().add(SetLightTheme()),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              themeMode == ThemeMode.light
                                  ? MyColors.primaryColor
                                  : null,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text("Light"),
                      ),
                    ),
                    InkWell(
                      onTap:
                          () => context.read<ThemeBloc>().add(SetDarkTheme()),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              themeMode == ThemeMode.dark
                                  ? MyColors.primaryColor
                                  : null,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text("Dark"),
                      ),
                    ),
                    InkWell(
                      onTap:
                          () => context.read<ThemeBloc>().add(SetSystemTheme()),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              themeMode == ThemeMode.system
                                  ? MyColors.primaryColor
                                  : null,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text("System"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
