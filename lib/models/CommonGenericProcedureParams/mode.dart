import 'package:mi_ipred_plantel_exterior/models/CommonClaseCpbteVT/model.dart';

class CommonGenericProcedureParamsModel {
  static const String className = "CommonGenericProcedureParamsModel";

  CommonClasesCpbteVT? claseCpbte;
  bool generateSelectItem;
  bool generateNewItem;

  CommonGenericProcedureParamsModel({
    this.claseCpbte,
    this.generateSelectItem = false,
    this.generateNewItem = false,
  });
}
