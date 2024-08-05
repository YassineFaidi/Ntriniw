import 'package:flutter/material.dart';

class ContentSection extends StatefulWidget {
  final String content;

  const ContentSection({
    super.key,
    required this.content,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ContentSectionState createState() => _ContentSectionState();
}

class _ContentSectionState extends State<ContentSection> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: const TextStyle(fontSize: 14.0),
            maxLines: _isExpanded ? null : 2,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
