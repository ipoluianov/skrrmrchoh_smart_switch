class RelayViewRow {
  int rowIndex;
  String onsw1;
  String onsw2;
  String offsw1;
  String offsw2;
  String onrl1;
  String onrl2;
  String offrl1;
  String offrl2;
  String ontm1;
  String ontm2;
  String offtm1;
  String offtm2;

  RelayViewRow(
    this.rowIndex,
    this.onsw1,
    this.onsw2,
    this.offsw1,
    this.offsw2,
    this.onrl1,
    this.onrl2,
    this.offrl1,
    this.offrl2,
    this.ontm1,
    this.ontm2,
    this.offtm1,
    this.offtm2,
  );

  Map<String, dynamic> toJson() => {
        'rowIndex': rowIndex,
        'onsw1': onsw1,
        'onsw2': onsw2,
        'offsw1': offsw1,
        'offsw2': offsw2,
        'onrl1': onrl1,
        'onrl2': onrl2,
        'offrl1': offrl1,
        'offrl2': offrl2,
        'ontm1': ontm1,
        'ontm2': ontm2,
        'offtm1': offtm1,
        'offtm2': offtm2,
      };

  factory RelayViewRow.fromJson(Map<String, dynamic> json) {
    return RelayViewRow(
      json['rowIndex'],
      json['onsw1'],
      json['onsw2'],
      json['offsw1'],
      json['offsw2'],
      json['onrl1'],
      json['onrl2'],
      json['offrl1'],
      json['offrl2'],
      json['ontm1'],
      json['ontm2'],
      json['offtm1'],
      json['offtm2'],
    );
  }
}
