package summarywidget

import (
	"sss/project"
	"strconv"

	"github.com/u00io/nuiforms/ui"
)

type SummaryWidget struct {
	ui.Widget

	lvItems *ui.Table
}

func NewSummaryWidget() *SummaryWidget {
	var c SummaryWidget
	c.InitWidget()
	c.SetLayout(`
<column>
	<table id="lvItems" />
</column>
	`, &c, nil)

	c.lvItems = c.FindWidgetByName("lvItems").(*ui.Table)

	c.lvItems.SetColumnCount(4)

	c.lvItems.SetColumnName(0, "Источник сигнала")
	c.lvItems.SetColumnName(1, "Фронт")
	c.lvItems.SetColumnName(2, "Действие")
	c.lvItems.SetColumnName(3, "Реле")

	c.lvItems.SetRowCount(10)

	return &c
}

func (c *SummaryWidget) LoadData() {
	index := 0
	lastSourceCode := 0xFFFFFFFF
	eepromSheet := project.CurrentEEPROM
	switchesSheet := c.lvItems
	switchesSheet.SetRowCount(0)

	for swIndex := 0; swIndex < 24; swIndex++ {
		for i := 1; i < 64; i++ {
			switchRising := eepromSheet.CellInt(i, 4)
			if swIndex != switchRising {
				continue
			}
			relay := eepromSheet.CellInt(i, 1)
			action := eepromSheet.CellInt(i, 2)
			if switchRising != 0xFF {
				switchesSheet.SetCellText2(index, 0, project.CurrentProject.DisplayTextForSwitchIndex(strconv.Itoa(swIndex))+" (switch)")
				switchesSheet.SetCellText2(index, 1, "восх фронт")
				if action == 1 {
					switchesSheet.SetCellText2(index, 2, "включает")
				} else {
					switchesSheet.SetCellText2(index, 2, "выключает")
				}
				switchesSheet.SetCellText2(index, 3, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relay)))
				if lastSourceCode != swIndex+100 {
					lastSourceCode = swIndex + 100
				} else {
					switchesSheet.SetCellText2(index, 0, "")
				}
				index++
			}
		}
		for i := 1; i < 64; i++ {
			switchRising := eepromSheet.CellInt(i, 3)
			if swIndex != switchRising {
				continue
			}
			relay := eepromSheet.CellInt(i, 1)
			action := eepromSheet.CellInt(i, 2)
			if switchRising != 0xFF {
				switchesSheet.SetCellText2(index, 0, project.CurrentProject.DisplayTextForSwitchIndex(strconv.Itoa(swIndex))+" (switch)")
				switchesSheet.SetCellText2(index, 1, "низх фронт")
				if action == 1 {
					switchesSheet.SetCellText2(index, 2, "включает")
				} else {
					switchesSheet.SetCellText2(index, 2, "выключает")
				}
				switchesSheet.SetCellText2(index, 3, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relay)))
				if lastSourceCode != swIndex+100 {
				} else {
					switchesSheet.SetCellText2(index, 0, "")
				}
				index++
			}
		}
	}
	for relayIndex := 0; relayIndex < 16; relayIndex++ {
		for i := 1; i < 64; i++ {
			relayRising := eepromSheet.CellInt(i, 6)
			if relayIndex != relayRising {
				continue
			}
			relay := eepromSheet.CellInt(i, 1)
			action := eepromSheet.CellInt(i, 2)
			if relayRising != 0xFF {
				switchesSheet.SetCellText2(index, 0, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relayIndex))+" (relay)")
				switchesSheet.SetCellText2(index, 1, "восх фронт")
				if action == 1 {
					switchesSheet.SetCellText2(index, 2, "включает")
				} else {
					switchesSheet.SetCellText2(index, 2, "выключает")
				}
				switchesSheet.SetCellText2(index, 3, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relay)))
				if lastSourceCode != relayIndex+10000 {
				} else {
					switchesSheet.SetCellText2(index, 0, "")
				}
				index++
			}
		}
		for i := 1; i < 64; i++ {
			relayRising := eepromSheet.CellInt(i, 5)
			if relayIndex != relayRising {
				continue
			}
			relay := eepromSheet.CellInt(i, 1)
			action := eepromSheet.CellInt(i, 2)
			if relayRising != 0xFF {
				switchesSheet.SetCellText2(index, 0, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relayIndex))+" (relay)")
				switchesSheet.SetCellText2(index, 1, "низх фронт")
				if action == 1 {
					switchesSheet.SetCellText2(index, 2, "включает")
				} else {
					switchesSheet.SetCellText2(index, 2, "выключает")
				}
				switchesSheet.SetCellText2(index, 3, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relay)))
				if lastSourceCode != relayIndex+10000 {
				} else {
					switchesSheet.SetCellText2(index, 0, "")
				}
				index++
			}
		}

	}

	c.lvItems.SetRowCount(index)
}

/*
  void fillSwitches() {
    int index = 0;
    int lastSourceCode = 0xFFFFFFFF;
    var shEEPROM = docs[eepromSheetIndex];
    var shSwitches = docs[switchesSheetIndex];
    shSwitches.clearRows();

    var partBorder = CellBorder(2, Colors.black);

    // Switches
    for (int swIndex = 0; swIndex < 16; swIndex++) {
      for (int i = 1; i < 64; i++) {
        var switchRising = shEEPROM.getCellValue(4, i);
        if (swIndex != switchRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (switchRising != 0xFF) {
          shSwitches.setCell(0, index, getSwitchName(swIndex) + " (switch)");
          shSwitches.setCell(1, index, "восх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));
          if (lastSourceCode != swIndex + 100) {
            lastSourceCode = swIndex + 100;

            shSwitches.getCell(0, index).fontBold = true;
            shSwitches.getCell(0, index).fontSize = 18;
            shSwitches.getCell(0, index).backColor = Colors.amberAccent;
            for (int col = 0; col < 4; col++) {
              shSwitches.getCell(col, index).borderTop = partBorder;
            }
          } else {
            shSwitches.getCell(0, index).value = "";
          }

          index++;
        }
      }
      for (int i = 1; i < 64; i++) {
        var switchRising = shEEPROM.getCellValue(3, i);
        if (swIndex != switchRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (switchRising != 0xFF) {
          shSwitches.setCell(0, index, getSwitchName(swIndex) + " (switch)");
          shSwitches.setCell(1, index, "низх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));

          if (lastSourceCode != swIndex + 100) {
            lastSourceCode = swIndex + 100;
            shSwitches.getCell(0, index).fontBold = true;
            shSwitches.getCell(0, index).fontSize = 18;
            shSwitches.getCell(0, index).backColor = Colors.amberAccent;
            for (int col = 0; col < 4; col++) {
              shSwitches.getCell(col, index).borderTop = partBorder;
            }
          } else {
            shSwitches.getCell(0, index).value = "";
          }

          index++;
        }
      }
    }

    // Relays
    for (int relayIndex = 0; relayIndex < 16; relayIndex++) {
      for (int i = 1; i < 64; i++) {
        var relayRising = shEEPROM.getCellValue(6, i);
        if (relayIndex != relayRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (relayRising != 0xFF) {
          shSwitches.setCell(0, index, getRelayName(relayIndex) + " (relay)");
          shSwitches.setCell(1, index, "восх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));

          if (lastSourceCode != relayIndex + 10000) {
            lastSourceCode = relayIndex + 10000;
            shSwitches.getCell(0, index).fontBold = true;
            shSwitches.getCell(0, index).fontSize = 18;
            shSwitches.getCell(0, index).backColor = Colors.amberAccent;
            for (int col = 0; col < 4; col++) {
              shSwitches.getCell(col, index).borderTop = partBorder;
            }
          } else {
            shSwitches.getCell(0, index).value = "";
          }

          index++;
        }
      }
      for (int i = 1; i < 64; i++) {
        var relayRising = shEEPROM.getCellValue(5, i);
        if (relayIndex != relayRising) {
          continue;
        }
        var relay = shEEPROM.getCellValue(1, i);
        var action = shEEPROM.getCellValue(2, i);
        if (relayRising != 0xFF) {
          shSwitches.setCell(0, index, getRelayName(relayIndex) + " (relay)");
          shSwitches.setCell(1, index, "низх фронт");
          shSwitches.setCell(2, index, action == 0 ? "включает" : "выключает");
          shSwitches.setCell(3, index, getRelayName(relay));

          if (lastSourceCode != relayIndex + 10000) {
            lastSourceCode = relayIndex + 10000;
            shSwitches.getCell(0, index).fontBold = true;
            shSwitches.getCell(0, index).fontSize = 18;
            shSwitches.getCell(0, index).backColor = Colors.amberAccent;
            for (int col = 0; col < 4; col++) {
              shSwitches.getCell(col, index).borderTop = partBorder;
            }
          } else {
            shSwitches.getCell(0, index).value = "";
          }

          index++;
        }
      }
    }
  }

*/
