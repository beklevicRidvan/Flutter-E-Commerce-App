import '../model/full_adress_model.dart';

abstract class ApiBase{
  Future<List<FullAdressModel>> getAdress(double lat, double lon);

}