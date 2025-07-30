import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trendiq/common/common_app_bar.dart';
import 'package:trendiq/common/common_widgets_methods.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/models/address.dart';
import 'package:trendiq/services/app_colors.dart';
import 'package:trendiq/services/extensions.dart';
import 'package:trendiq/services/toast_service.dart';
import 'package:trendiq/views/profile/address/bloc/address_bloc.dart';

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
  late final AddressBloc addressBloc;

  @override
  void initState() {
    addressBloc = BlocProvider.of<AddressBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addressBloc.add(AddressLoadEvent());
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(showBackButton: true, title: "My Address"),
      body: BlocConsumer<AddressBloc,AddressState>(
        builder: (context, state) {
          return Skeletonizer(
            enabled: state is AddressLoadingState,
            child: Padding(
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
                  8.sBh,
                  Flexible(
                    child: ListView.builder(itemBuilder: (context, index) =>
                        _buildAddressCard(addressBloc.addresses[index], index), itemCount: addressBloc.addresses.length,),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is AddressErrorState) {
            toast(state.message,isError: true);
          }
          if (state is AddressUpdatedState) {
            toast(state.message);
            addressBloc.add(AddressLoadEvent());
          }
        },
      ),
    );
  }
  Widget _buildAddressCard(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault
              ? appColors.primary.withValues(alpha: 0.4)
              : Theme.of(context).dividerColor,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      style: commonTextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.fontSemiBold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    4.sBh,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: appColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "PIN: ${address.pincode}",
                        style: commonTextStyle(
                          fontSize: 12,
                          fontFamily: Fonts.fontMedium,
                          color: appColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.sBw,
              if (address.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.white,
                      ),
                      4.sBw,
                      Text(
                        "Default",
                        style: commonTextStyle(
                          fontSize: 12,
                          fontFamily: Fonts.fontSemiBold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    addressBloc.add(AddressDefaultEvent(address.id));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.star_border,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
          16.sBh,
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                8.sBw,
                Expanded(
                  child: Text(
                    address.address,
                    style: commonTextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          20.sBh,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleEditAddress(address, index),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.blue,
                  ),
                  label: Text(
                    "Edit",
                    style: commonTextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.fontMedium,
                      color: Colors.blue,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.blue, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.05),
                  ),
                ),
              ),
              12.sBw,
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleDeleteAddress(address, index),
                  icon: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: Colors.red,
                  ),
                  label: Text(
                    "Delete",
                    style: commonTextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.fontMedium,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }  void _handleEditAddress(Address address, int index) {
    _handelAddressForm(address: address);
  }

  void _handleDeleteAddress(Address address, int index) {
    showAdaptiveDialog(context: context, builder: (context) {
      return AlertDialog(title: Text("Delete Address"),content: Text("Are you sure you want to delete this address?"),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            addressBloc.add(AddressDeleteEvent(address.id));
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text("Continue"),
        ),
      ],);
    },);
  }

  _handelAddressFormEntry(String? id) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() ?? false) {
      addressBloc.add(id != null ? AddressUpdateEvent(id, etName.text, etPinCode.text, etAddress.text) : AddressCreateEvent(etName.text, etPinCode.text, etAddress.text));
      etName.clear();
      etPinCode.clear();
      etAddress.clear();
      Navigator.of(context).pop();
    }
  }

  _handelAddressForm({Address? address}) {
    if (address != null) {
      etName.text = address.name;
      etPinCode.text = address.pincode;
      etAddress.text = address.address;
    }
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
                                ),
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
                            buildInputLabel("Pin Code"),
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
                                  onPressed: () => _handelAddressFormEntry(address?.id),
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
