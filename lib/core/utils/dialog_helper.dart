import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String desc,
    VoidCallback? onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: onOkPress ?? () {},
    ).show();
  }

  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String desc,
    VoidCallback? onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: onOkPress ?? () {},
      btnOkColor: Colors.red,
    ).show();
  }

  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String desc,
    VoidCallback? onOkPress,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: onOkPress ?? () {},
    ).show();
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
