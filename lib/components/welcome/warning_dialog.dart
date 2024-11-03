import 'package:flutter/material.dart';

class WarningDialog {
  static show({required String msg, required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF263D43)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 60,
                color: Color(0xFFF0CCEF),
              ),
              Text(
                msg,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFFAFAFA)),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                color: Colors.transparent,
                elevation: 10,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  splashColor: const Color(0xFFF0CCEF),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'OKAY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263D43),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
