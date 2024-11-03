import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/case_model.dart';

class FileGrid extends StatelessWidget {
  const FileGrid({
    super.key,
    required this.index,
    required this.fileDetails,
  });

  final CaseFile fileDetails;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(fileDetails.filepath!)),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.indigo[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(fileDetails.filedateAdded ?? ''),
              const Spacer(),
              Text(
                fileDetails.filepath!.split('.').last.toUpperCase(),
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
