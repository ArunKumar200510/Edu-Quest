import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edu_quest/core/extension/context.dart';
import 'package:edu_quest/core/extension/date_time.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.isMainButton,
    required this.onPressed,
    super.key,
    this.type,
    this.subject,
    this.date,
  });

  const CardButton.subject({
    required this.title,
    required this.imagePath,
    required this.onPressed,
    required this.color,
    this.subject,
    this.date,
    this.type = 'subject',
    super.key,
  }) : isMainButton = false;

  const CardButton.generated({
    required this.title,
    required this.imagePath,
    required this.onPressed,
    required this.color,
    required this.date,
    required this.subject,
    this.type = 'generated',
    super.key,
  }) : isMainButton = false;

  final String? type;
  final String title;
  final String imagePath;
  final Color color;
  final bool isMainButton;
  final VoidCallback onPressed;
  final String? subject;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    // Format the date in English
    final formattedDate = date != null
        ? DateFormat.yMMMd('en_US').format(date!)
        : '';

    return type == 'subject'
        ? DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.background,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    )
        : type == null
        ? ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor:
                context.colorScheme.background.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    imagePath,
                    color: context.colorScheme.background,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.arrow_up_right,
                color: context.colorScheme.background,
                size: 32,
              ),
            ],
          ),
          SizedBox(
            height: isMainButton ? 10 : 8,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.background,
                fontSize: isMainButton ? 31 : 18,
              ),
            ),
          ),
        ],
      ),
    )
        : SizedBox(
      width: 220,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor:
                  context.colorScheme.background.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      imagePath,
                      color: context.colorScheme.background,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.arrow_up_right,
                  color: context.colorScheme.background,
                  size: 32,
                ),
              ],
            ),
            SizedBox(
              height: isMainButton ? 16 : 8,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.background,
                      fontSize: isMainButton ? 20 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.background
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formattedDate,  // Display formatted date in English
                      style: TextStyle(
                        color: context.colorScheme.background,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.background
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subject.toString(),
                      style: TextStyle(
                        color: context.colorScheme.background,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
