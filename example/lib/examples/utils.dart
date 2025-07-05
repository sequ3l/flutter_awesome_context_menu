import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Callback for updating the last action in the main UI
typedef UpdateActionCallback = void Function(String action);

/// Build a standard example card with title, description, and content
Widget buildExampleCard({
  required String title,
  required String description,
  required Widget content,
}) {
  return Card(
    margin: EdgeInsets.zero,
    elevation: 3,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Center(child: content),
        ],
      ),
    ),
  );
}

/// Build the action feedback panel to display the last performed action
Widget buildActionFeedback(BuildContext context, String action) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Text(
          'Last Action',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            action,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: action == "No action yet"
                    ? Colors.grey.shade600
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
