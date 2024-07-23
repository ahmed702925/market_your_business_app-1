import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../models/emailm.dart';

class EmailProvider with ChangeNotifier {
  Future<void> send(EmailM emailM, List<String> attachments) async {
    final Email email = Email(
      body: emailM.bodyController,
      subject: emailM.subjectController,
      recipients: [emailM.recipientController],
      attachmentPaths: attachments,
    );
 log("Send button pressed");
  log("Recipient: ${emailM.recipientController}");
  log("Subject: ${emailM.subjectController}");
  log("Body: ${emailM.bodyController}");
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
       log("Email sent successfully");
    } catch (error) {
      platformResponse = error.toString();
      log(platformResponse);
    }

  }
}
