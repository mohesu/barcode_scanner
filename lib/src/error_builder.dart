import 'package:flutter/material.dart';

/// A builder that shows an error message when the camera fails to start.
class ErrorBuilder extends StatelessWidget {
  const ErrorBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Center(
          heightFactor: 6.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_rounded,
                size: 68,
              ),
              const SizedBox(height: 12),
              Text(
                "Could not start the camera",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
