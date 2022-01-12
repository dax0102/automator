import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({Key? key, required this.heading}) : super(key: key);

  final String heading;

  Widget get _spinner {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
        width: 32,
        height: 32,
      ),
    );
  }

  Widget get _heading {
    return Text(
      heading,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ThemeComponents.defaultPadding,
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _spinner,
          _heading,
        ],
      ),
    );
  }
}
