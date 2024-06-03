class RelayViewRow {
  int relayIndex;
  int onsw1;
  int onsw2;
  int offsw1;
  int offsw2;
  int onrl1;
  int onrl2;
  int offrl1;
  int offrl2;
  int ontm1;
  int ontm2;
  int offtm1;
  int offtm2;

  RelayViewRow(
    this.relayIndex,
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
        'relayIndex': relayIndex,
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
      json['relayIndex'],
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
