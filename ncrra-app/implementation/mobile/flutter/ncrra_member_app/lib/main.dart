// NCRRA Trusted Member Utility: Flutter entry point for the approved visual system.
import 'package:flutter/widgets.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NcrraApp());
}
