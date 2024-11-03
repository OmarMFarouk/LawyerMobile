import 'package:flutter/material.dart';

class DetailsTile extends StatelessWidget {
  const DetailsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title, text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        leading: Icon(icon,
            color: title == 'Case Subject'
                ? Colors.red
                : title == 'Case Type'
                    ? Colors.blue
                    : title == 'Court Chamber'
                        ? Colors.yellow
                        : Colors.orange),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          text,
          style: const TextStyle(
              color: Color(0xFFF0CCEF), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
