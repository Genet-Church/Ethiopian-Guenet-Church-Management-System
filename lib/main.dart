import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/app.dart';
import 'package:genet_church_portal/core/js_interop.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  runApp(const ProviderScope(child: MyApp()));
  if (kIsWeb) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hideLoadingIndicator();
    });
  }
}
