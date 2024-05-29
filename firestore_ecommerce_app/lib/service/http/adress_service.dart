import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/full_adress_model.dart';
import '../http_base_service.dart';

class HttpApiService extends HttpBaseService {
  @override
  Future<List<FullAdressModel>> getAdress(double lat, double lon) async {
    List<FullAdressModel> adress = [];
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      adress.add(FullAdressModel.fromJson(data));
    }
    return adress;
  }

  /*
  Future<List<FullAdressModel>> fetchAddressSuggestions(String query) async {
    List<FullAdressModel> adress = [];

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      adress.add(FullAdressModel.fromJson(data));
    } else {
      throw Exception('Failed to load address suggestions');
    }
    return adress;
  }

   */
}
