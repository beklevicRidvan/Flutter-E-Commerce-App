import 'dart:async';
import 'package:firestore_ecommerce_app/model/adres_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/full_adress_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class AdressViewModel with ChangeNotifier {
  Completer<GoogleMapController> haritaKontrol = Completer();

  List<FullAdressModel> _adress = [];

  LatLng selectedLocation = const LatLng(40.8110405, 29.4879474);

  late BitmapDescriptor _konumIcon;

  List<Marker> _isaretler = <Marker>[];

  bool _isTapped = false;

  String _selectedAdress = "Ev";

  final _repository = locator<DatabaseRepository>();

  //40.8110405,29.4879474
  var baslangicKonum =
      const CameraPosition(target: LatLng(40.8110405, 29.4879474), zoom: 20);

  late TextEditingController _mahalleController;
  late TextEditingController _binaNoController;
  late TextEditingController _katController;
  late TextEditingController _daireNoController;
  late TextEditingController _baslikController;

  AdressViewModel() {
    _mahalleController = TextEditingController();
    _binaNoController = TextEditingController();
    _katController = TextEditingController();
    _daireNoController = TextEditingController();
    _baslikController = TextEditingController(text: _selectedAdress);
  }

  void changeStateTapped(bool value) {
    _isTapped = !value;
    notifyListeners();
  }

  Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(position.latitude, position.longitude);
  }

  Future<void> goCurrentPosition() async {
    GoogleMapController controller = await haritaKontrol.future;
    var currentLocation = await getLocation();
    var gidilecekKonum = CameraPosition(target: currentLocation, zoom: 25);
    var gidilecekIsaret = Marker(
      markerId: MarkerId(currentLocation.toString()),
      position: currentLocation,
      infoWindow: const InfoWindow(title: "Home"),
      icon: _konumIcon,
    );
    isaretler = [gidilecekIsaret];
    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));
  }

  Future<void> createIcon(BuildContext context) async {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        configuration, "assets/location.png");
    _konumIcon = icon;
    notifyListeners();
  }

  Future<void> konumaGit(LatLng location) async {
    GoogleMapController controller = await haritaKontrol.future;
    var gidilecekKonum = CameraPosition(target: location, zoom: 20);
    var gidilecekIsaret = Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        infoWindow: const InfoWindow(title: "Seçilen Konum"),
        icon: _konumIcon);
    isaretler = [gidilecekIsaret];

    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));
  }

  set isaretler(List<Marker> value) {
    _isaretler = value;
    notifyListeners();
  }

  void updateSelectedAddress(String s) {
    _selectedAdress = s;
    _baslikController.text = _selectedAdress;
    notifyListeners();
  }

  void getFullAdressData() async {
    double lat = selectedLocation.latitude;
    double lon = selectedLocation.longitude;
    _adress = await _repository.getAdress(lat, lon);
    notifyListeners();

      _mahalleController.text = _adress[0].address.road;


  }

  void addAdressInfo() async {
    AdressModel adressModel = AdressModel(
        fullAdress: adress[0].displayName,
        mahalleAdi: _mahalleController.text,
        binaNo: _binaNoController.text,
        kat: _katController.text,
        daireNo: _daireNoController.text,
        baslik: _baslikController.text);
    dynamic adressId = await _repository.addAdress(adressModel);
    adressModel.adressId = adressId;
  }

  List<Marker> get isaretler => _isaretler;

  bool get isTapped => _isTapped;

  TextEditingController get daireNoController => _daireNoController;

  TextEditingController get katController => _katController;

  TextEditingController get binaNoController => _binaNoController;

  TextEditingController get mahalleController => _mahalleController;

  String get selectedAdress => _selectedAdress;

  TextEditingController get baslikController => _baslikController;

  List<FullAdressModel> get adress => _adress;
}
