import 'relay_view_row.dart';

class Project {
  List<RelayViewRow> items = [];
  List<String> settings = [];

  Project(List<RelayViewRow> its, List<String> sts) {
    int settingsIndex = 0;
    for (int i = 0; i < 16; i++) {
      var val = "Реле №$i";
      if (settingsIndex < sts.length) {
        val = sts[settingsIndex];
      }
      settings.add(val);
      settingsIndex++;
    }
    for (int i = 0; i < 24; i++) {
      var val = "Выключатель №$i";
      if (settingsIndex < sts.length) {
        val = sts[settingsIndex];
      }
      settings.add(val);
      settingsIndex++;
    }

    while (settings.length < 16 + 24) {
      settings.add("");
    }

    for (int i = 0; i < 16; i++) {
      for (int r = 0; r < 8; r++) {
        var rowIndex = i * 8 + r;
        RelayViewRow item = RelayViewRow(
          rowIndex,
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
        );

        for (int j = 0; j < its.length; j++) {
          if (its[j].rowIndex == rowIndex) {
            item = its[j];
          }
        }

        items.add(item);
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'items': items,
        'settings': settings,
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      List<RelayViewRow>.from(
        json['items'].map((model) => RelayViewRow.fromJson(model)),
      ),
      json['settings'] == null ? [] : json['settings'].cast<String>(),
    );
  }
}
