import 'package:flutter/material.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final etName = TextEditingController();
  final etPinCode = TextEditingController();
  final etAddress = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "My Address"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            10.sBh,
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Manage your shipping addresses",
                    maxLines: 2,
                    softWrap: true,
                    style: commonTextStyle(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _handelAddressForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Add New Address", style: commonTextStyle()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _handelAddressFormEntry() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() ?? false) {
      toast("New Address is Added");
      etName.clear();
      etPinCode.clear();
      etAddress.clear();
      Navigator.of(context).pop();
    }
  }

  _handelAddressForm() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(18)),
      ),
      enableDrag: false,
      isScrollControlled: true,
      builder:
          (_) => StatefulBuilder(
            builder:
                (_, modalSetState) => Form(
                  key: formKey,
                  canPop: false,
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.sBh,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Your Address",
                                  style: commonTextStyle(
                                    fontSize: 18,
                                    fontFamily: Fonts.fontSemiBold,
                                  ),
                                ),

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
                                        Icons.close,
                                        size: 18,
                                        color: appColors.primary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            12.sBh,
                            buildInputLabel("Name"),
                            8.sBh,
                            TextFormField(
                              controller: etName,
                              decoration: textFieldInputDecoration(
                                hintText: "Enter Address Name",
                              ),
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? "Please Enter Address Name"
                                          : null,
                            ),
                            12.sBh,
                            buildInputLabel("PinCode"),
                            8.sBh,
                            TextFormField(
                              controller: etPinCode,
                              decoration: textFieldInputDecoration(
                                hintText: "Enter PinCode",
                              ),
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? "Please Enter PinCode"
                                          : null,
                            ),
                            12.sBh,
                            buildInputLabel("Full Address"),
                            8.sBh,
                            TextFormField(
                              controller: etAddress,
                              decoration: textFieldInputDecoration(
                                hintText: "Enter Full Address",
                              ),
                              maxLines: 3,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? "Please Enter Full Address"
                                          : null,
                            ),
                            18.sBh,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _handelAddressFormEntry,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Save Address",
                                    style: commonTextStyle(),
                                  ),
                                ),
                              ],
                            ),
                            10.sBh,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ),
    );
  }
}
