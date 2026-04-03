library;

import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mi_ipred_plantel_exterior/models/CommonMessages/common_whole_message_model.dart';
import 'package:mi_ipred_plantel_exterior/models/error_handler.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_Ciudades/model.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_ClientesV2/model.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_DetBarriosCiudades/model.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_Empresas/model.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_Paises/model.dart';
import 'package:mi_ipred_plantel_exterior/models/tbl_Provincias/model.dart';

part 'src/is_null.dart';
part 'src/generate_random_unique_hash.dart';
part 'src/standarize_errors.dart';
part 'src/generate_credentials.dart';

// class CommonUtils {
//   /// Genera un hash único y rándom
//   ///
//   static String generateRandomUniqueHash() {
//     // 1. Generar un número aleatorio usando Random
//     final random = Random.secure();
//     final randomBytes = List<int>.generate(16, (_) => random.nextInt(256));

//     // 2. Convertir a una cadena de texto (puedes combinarlo con otros valores si es necesario)
//     final randomString = base64Url.encode(randomBytes);

//     // 3. Generar el hash (SHA-256)
//     final bytes =
//         utf8.encode(randomString); // Convertimos el string aleatorio a bytes
//     final hash = sha256.convert(bytes); // Usamos SHA-256 para el hash

//     // 4. Retornar el valor en formato hexadecimal
//     return hash.toString();
//   }
// }
