// File: lib/core/config/config_loader.dart
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;
import 'package:mi_ipred_plantel_exterior/models/ServiceProviderConfig/model.dart';
import 'package:mi_ipred_plantel_exterior/models/error_handler.dart';

// Web-specific loader
import 'config_loader_web.dart' if (dart.library.io) 'config_loader_io.dart';

class ConfigLoader {
  static Future<ServiceProviderConfigModel> loadConfig(
      String defaultWssUri) async {
    developer.log(
      '=> Cargando configuración...',
      name: 'ConfigLoader',
    );
    var lConfig = await ConfigLoaderPlatform.loadConfig(defaultWssUri);
    developer.log(
      '=> Configuración cargada: $lConfig',
      name: 'ConfigLoader',
    );
    return lConfig;
  }

  static Future<ErrorHandler> saveConfig(
      ServiceProviderConfigModel config) async {
    developer.log(
      '=> Guardando configuración...',
      name: 'ConfigLoader',
    );
    var sConfig = await ConfigLoaderPlatform.saveConfig(config);
    developer.log(
      '=> Configuración guardada: $sConfig',
      name: 'ConfigLoader',
    );
    return sConfig;
  }
}
