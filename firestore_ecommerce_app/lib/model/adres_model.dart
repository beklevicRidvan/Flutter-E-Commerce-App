class AdressModel {
  dynamic adressId;
  int? index;
  bool isSelected;
  String fullAdress;
  String mahalleAdi;
  String binaNo;
  String kat;
  String daireNo;
  String baslik;

  AdressModel(
      {this.adressId,
      this.index,
      required this.fullAdress,
      this.isSelected = false,
      required this.mahalleAdi,
      required this.binaNo,
      required this.kat,
      required this.daireNo,
      required this.baslik});

  factory AdressModel.fromMap(Map<String, dynamic> map, {dynamic key}) {
    return AdressModel(
        adressId: key ?? map["adressId"],
        fullAdress: map["fullAdress"],
        isSelected: map["isSelected"],
        mahalleAdi: map["mahalleAdi"],
        binaNo: map["binaNo"],
        kat: map["kat"],
        daireNo: map["kat"],
        baslik: map["baslik"]);
  }

  Map<String, dynamic> toMap({dynamic key,dynamic indexCount}) {
    return {
      "adressId": key ?? adressId,
      "index": index ?? 0,
      "isSelected": isSelected,
      "fullAdress": fullAdress,
      "mahalleAdi": mahalleAdi,
      "binaNo": binaNo,
      "kat": kat,
      "daireNo": daireNo,
      "baslik": baslik
    };
  }

  Map<String, dynamic> toUpdatedMap(
      String newFullAdress,
      bool newSelectedValue,
      String newMahalleAdi,
      String newBinaNo,
      String newKat,
      String newDaireNo,
      String newBaslik) {
    return {
      "adressId": adressId,
      "isSelected": newSelectedValue,
      "fullAdress": newFullAdress,
      "mahalleAdi": newMahalleAdi,
      "binaNo": newBinaNo,
      "kat": newKat,
      "daireNo": newDaireNo,
      "baslik": newBaslik
    };
  }
}
