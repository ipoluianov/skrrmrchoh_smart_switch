import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cell.dart';

abstract class CellEditor extends StatefulWidget {
  final Cell cell;
  final bool inDialog;
  const CellEditor(this.cell, this.inDialog, {super.key});
}
