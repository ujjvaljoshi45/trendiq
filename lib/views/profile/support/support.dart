import 'package:flutter/material.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final formKey = GlobalKey<FormState>();
  final etSubject = TextEditingController();
  final etMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      appBar: CommonAppBar(title: "", backgroundColor: appColors.background),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Support",
                  style: headerTextStyle(),
                ),
                4.sBh,
                Text("Get help and support", style: commonTextStyle()),
                12.sBh,
                Divider(color: appColors.secondary),
                12.sBh,
                buildInputLabel("Subject"),
                8.sBh,
                TextFormField(
                  controller: etSubject,
                  decoration: textFieldInputDecoration(
                    hintText: "Enter the subject of your inquiry",
                  ),
                  validator: (value) => (value?.isEmpty ?? true) ? "Please Enter Subject" : null ,
                ),
                12.sBh,
                buildInputLabel("Message"),
                8.sBh,
                TextFormField(
                  controller: etMessage,
                  decoration: textFieldInputDecoration(
                    hintText: "Describe your issue or question",
                  ),
                  maxLines: 5,
                  validator: (value) => (value?.isEmpty ?? true) ? "Please Enter Message" : null ,
                ),
                12.sBh,
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState?.validate() ?? false) {
                        etSubject.clear();
                        etMessage.clear();
                        toast("Ticket Raised Successfully.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Submit Request", style: commonTextStyle()),
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
