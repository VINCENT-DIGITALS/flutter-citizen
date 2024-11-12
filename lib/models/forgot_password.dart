import 'package:citizen/components/loading.dart';
import 'package:citizen/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../localization/locales.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({
    super.key,
  });

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        LocaleData.forgotPass.getString(context),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: LocaleData.enteremaill.getString(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    String email = emailController.text;
                    if (email.isNotEmpty) {
                      try {
                        LoadingIndicatorDialog().show(context);
                        await DatabaseService().sendPasswordResetEmail(email);
                        LoadingIndicatorDialog().dismiss();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $error")),
                        );
                      }
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      LocaleData.send.getString(context),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
