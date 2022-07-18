class DosenModel {
  int? id;
  String? nama;
  String? nidn;
  String? tempat_lahir;
  String? tgl_lahir;
  String? no_hp;

  DosenModel(this.id, this.nama, this.nidn, this.tempat_lahir, this.tgl_lahir,
      this.no_hp);

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(json['id'], json['nama'], json['nidn'],
        json['tempat_lahir'], json['tgl_lahir'], json['no_hp']);
  }
}
