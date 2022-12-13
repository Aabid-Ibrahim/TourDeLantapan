import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(15), children: const [
      Text(
          "If you would like to request to access, correct, object to the use, restrict or delete personal information that you have previously provided to us, or if you would like to request to receive an electronic copy of your personal information for purposes of transmitting it to another company, you may contact us at support@russruffino.com with the subject line “Data Subject Request.” We will attempt to comply with your request. However, the nature of our business, along with the applicable law governing our business, requires us to retain your information for several years. Please also note that we may need to retain certain information for recordkeeping purposes and/or to complete any transactions that you began prior to requesting a change or deletion (e.g., when you make a purchase or enter a promotion, you may not be able to change or delete the personal information provided until after the completion of such purchase or promotion). There may also be residual information that will remain within our databases and other records, which will not be removed.")
    ]);
  }
}
