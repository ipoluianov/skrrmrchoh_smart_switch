package eepromwidget

import (
	"encoding/hex"
	"fmt"
	"sss/project"
	"sss/serialinterface"
	"strconv"
	"time"

	"github.com/u00io/gomisc/logger"
	"github.com/u00io/nuiforms/ui"
)

type EepromWidget struct {
	ui.Widget

	lvItems *ui.Table

	OnCompiled func()
}

func NewEepromWidget() *EepromWidget {
	var c EepromWidget
	c.InitWidget()
	c.SetLayout(`
<column>
	<row>
		<button text="Прочитать" onclick="BtnLoadFromDevice" />
		<button text="Записать" role="primary" onclick="BtnWriteToDevice" />
		<hspacer />		
		<button text="Скомпилировать" onclick="BtnCompile" />
	</row>
	<table id="lvItems" />
</column>
	`, &c, nil)

	c.lvItems = c.FindWidgetByName("lvItems").(*ui.Table)

	c.lvItems.SetColumnCount(11)

	c.lvItems.SetColumnName(0, "Индекс")
	c.lvItems.SetColumnName(1, "Реле")
	c.lvItems.SetColumnName(2, "Action")
	c.lvItems.SetColumnName(3, "SW falling")
	c.lvItems.SetColumnName(4, "SW rising")
	c.lvItems.SetColumnName(5, "Relay falling")
	c.lvItems.SetColumnName(6, "Relay rising")
	c.lvItems.SetColumnName(7, "---")
	c.lvItems.SetColumnName(8, "Время часы")
	c.lvItems.SetColumnName(9, "Время минуты")
	c.lvItems.SetColumnName(10, "Таймер")

	c.lvItems.SetColumnWidth(0, 50)
	c.lvItems.SetColumnWidth(1, 100)
	c.lvItems.SetColumnWidth(2, 100)
	c.lvItems.SetColumnWidth(3, 100)
	c.lvItems.SetColumnWidth(4, 100)
	c.lvItems.SetColumnWidth(5, 100)
	c.lvItems.SetColumnWidth(6, 100)
	c.lvItems.SetColumnWidth(7, 100)
	c.lvItems.SetColumnWidth(8, 100)
	c.lvItems.SetColumnWidth(9, 100)
	c.lvItems.SetColumnWidth(10, 100)

	c.lvItems.SetRowCount(64)
	return &c
}

func (c *EepromWidget) BtnCompile() {
	c.Compile()
}

func (c *EepromWidget) BtnLoadFromDevice() {

}

func (c *EepromWidget) BtnWriteToDevice() {
	bs, effectiveBytes := project.CurrentEEPROM.Marshal()
	logger.Println(hex.EncodeToString(bs))
	for lineIndex := 0; lineIndex < effectiveBytes/16; lineIndex++ {
		serialinterface.Instance.WriteEEPROM(bs[lineIndex*16:(lineIndex+1)*16], lineIndex)
	}
	time.Sleep(100 * time.Millisecond)
	serialinterface.Instance.ResetReeadEEPROMBuffer()
	for lineIndex := 0; lineIndex < effectiveBytes/16; lineIndex++ {
		serialinterface.Instance.ReadEEPROM(lineIndex)
	}
	time.Sleep(500 * time.Millisecond)
	var err error
	for lineIndex := 0; lineIndex < effectiveBytes/16; lineIndex++ {
		eepromLine := serialinterface.Instance.GetEEPROMLine(lineIndex)
		if eepromLine == nil {
			err = fmt.Errorf("Ошибка чтения строки EEPROM %d", lineIndex)
			break
		}
		expectedData := bs[lineIndex*16 : (lineIndex+1)*16]
		for i := 0; i < 16; i++ {
			if eepromLine.Data[i] != expectedData[i] {
				err = fmt.Errorf("Ошибка проверки строки EEPROM %d:", lineIndex)
				break
			}
		}
		if err != nil {
			break
		}
	}

	if err != nil {
		logger.Println("Ошибка записи EEPROM:", err)
		ui.ShowMessageBox("Ошибка", err.Error())
	} else {
		ui.ShowMessageBox("Успех", "EEPROM успешно записан и прочитан.")
	}
}

var compileEEPROMIndex int = 1

func (c *EepromWidget) addEvent(relayIndex int, action int, column int, value int) {
	shEEPROM := c.lvItems
	valueStr := formatValue(value)
	hasSet := false
	for i := 0; i <= compileEEPROMIndex; i++ {
		rIndexCellText := shEEPROM.GetCellText2(i, 1)
		aIndexCellText := shEEPROM.GetCellText2(i, 2)
		vCellText := shEEPROM.GetCellText2(i, column)
		rIndex, err1 := strconv.ParseInt(rIndexCellText, 16, 64)
		aIndex, err2 := strconv.ParseInt(aIndexCellText, 16, 64)
		v, err3 := strconv.ParseInt(vCellText, 16, 64)
		if err1 == nil && err2 == nil && err3 == nil {
			if relayIndex == int(rIndex) && action == int(aIndex) {
				if v == 0xFF {
					shEEPROM.SetCellText2(i, column, valueStr)
					hasSet = true
				}
			}
		}
	}
	if !hasSet {
		if compileEEPROMIndex < 63 {
			compileEEPROMIndex++
			shEEPROM.SetCellText2(compileEEPROMIndex, 1, formatValue(relayIndex))
			shEEPROM.SetCellText2(compileEEPROMIndex, 2, formatValue(action))
			shEEPROM.SetCellText2(compileEEPROMIndex, column, valueStr)
		}
	}
}

func (c *EepromWidget) addEventTime(relayIndex int, action int, column int, h int, m int) {
	shEEPROM := c.lvItems
	valueHStr := formatValue(h)
	valueMStr := formatValue(m)
	hasSet := false
	for i := 0; i <= compileEEPROMIndex; i++ {
		rIndexCellText := shEEPROM.GetCellText2(i, 1)
		aIndexCellText := shEEPROM.GetCellText2(i, 2)
		vHCellText := shEEPROM.GetCellText2(i, column)
		vMCellText := shEEPROM.GetCellText2(i, column+1)
		rIndex, err1 := strconv.ParseInt(rIndexCellText, 16, 64)
		aIndex, err2 := strconv.ParseInt(aIndexCellText, 16, 64)
		vH, err3 := strconv.ParseInt(vHCellText, 16, 64)
		vM, err4 := strconv.ParseInt(vMCellText, 16, 64)
		if err1 == nil && err2 == nil && err3 == nil && err4 == nil {
			if relayIndex == int(rIndex) && action == int(aIndex) {
				if vH == 0xFF && vM == 0xFF {
					shEEPROM.SetCellText2(i, column, valueHStr)
					shEEPROM.SetCellText2(i, column+1, valueMStr)
					hasSet = true
				}
			}
		}
	}
	if !hasSet {
		if compileEEPROMIndex < 63 {
			compileEEPROMIndex++
			shEEPROM.SetCellText2(compileEEPROMIndex, 1, formatValue(relayIndex))
			shEEPROM.SetCellText2(compileEEPROMIndex, 2, formatValue(action))
			shEEPROM.SetCellText2(compileEEPROMIndex, column, valueHStr)
			shEEPROM.SetCellText2(compileEEPROMIndex, column+1, valueMStr)
		}
	}
}

func (c *EepromWidget) Compile() {
	compileEEPROMIndex = 0
	countPerRelay := 8
	c.clearEEPROM()

	shRelayView := project.CurrentProject.ToRelayTable()

	for ri := 0; ri < 16; ri++ {
		for i := 0; i < countPerRelay; i++ {
			y := ri*countPerRelay + i
			swoffFront := shRelayView.Cell(y, 1)
			swoffSwitch := shRelayView.Cell(y, 2)
			swonFront := shRelayView.Cell(y, 3)
			swonSwitch := shRelayView.Cell(y, 4)
			rloffFront := shRelayView.Cell(y, 5)
			rloffRelay := shRelayView.Cell(y, 6)
			rlonFront := shRelayView.Cell(y, 7)
			rlonRelay := shRelayView.Cell(y, 8)
			tonH := shRelayView.Cell(y, 9)
			tonM := shRelayView.Cell(y, 10)
			toffH := shRelayView.Cell(y, 11)
			toffM := shRelayView.Cell(y, 12)

			swonValid := false
			swonFrontByte := 0xFF
			swonSwitchByte := 0xFF
			if swonFront == "" && swonSwitch == "" {
				swonValid = true
			}
			if swonFront != "" && swonSwitch != "" {
				swonFrontByteN, err1 := strconv.Atoi(swonFront)
				swonSwitchByteN, err2 := strconv.Atoi(swonSwitch)
				if err1 == nil {
					swonFrontByte = swonFrontByteN
				}
				if err2 == nil {
					swonSwitchByte = swonSwitchByteN
				}
				if swonFrontByte == 0xFF || swonSwitchByte == 0xFF {
					swonFrontByte = 0xFF
					swonSwitchByte = 0xFF
				}
				swonValid = swonFrontByte != 0xFF && swonSwitchByte != 0xFF
				if swonValid {
					if swonFrontByte == 0x00 {
						c.addEvent(ri, 0, 3, swonSwitchByte)
					}
					if swonFrontByte == 0x01 {
						c.addEvent(ri, 0, 4, swonSwitchByte)
					}
				}
			}

			swoffValid := false
			swoffFrontByte := 0xFF
			swoffSwitchByte := 0xFF
			if swoffFront == "" && swoffSwitch == "" {
				swoffValid = true
			}
			if swoffFront != "" && swoffSwitch != "" {
				swoffFrontByteN, err1 := strconv.Atoi(swoffFront)
				swoffSwitchByteN, err2 := strconv.Atoi(swoffSwitch)
				if err1 == nil {
					swoffFrontByte = swoffFrontByteN
				}
				if err2 == nil {
					swoffSwitchByte = swoffSwitchByteN
				}
				if swoffFrontByte == 0xFF || swoffSwitchByte == 0xFF {
					swoffFrontByte = 0xFF
					swoffSwitchByte = 0xFF
				}
				swoffValid = swoffFrontByte != 0xFF && swoffSwitchByte != 0xFF
				if swoffValid {
					if swoffFrontByte == 0x00 {
						c.addEvent(ri, 1, 3, swoffSwitchByte)
					}
					if swoffFrontByte == 0x01 {
						c.addEvent(ri, 1, 4, swoffSwitchByte)
					}
				}
			}

			// Relays
			rlonValid := false
			rlonFrontByte := 0xFF
			rlonRelayByte := 0xFF
			if rlonFront == "" && rlonRelay == "" {
				rlonValid = true
			}
			if rlonFront != "" && rlonRelay != "" {
				rlonFrontByteN, err1 := strconv.Atoi(rlonFront)
				rlonRelayByteN, err2 := strconv.Atoi(rlonRelay)
				if err1 == nil {
					rlonFrontByte = rlonFrontByteN
				}
				if err2 == nil {
					rlonRelayByte = rlonRelayByteN
				}
				if rlonFrontByte == 0xFF || rlonRelayByte == 0xFF {
					rlonFrontByte = 0xFF
					rlonRelayByte = 0xFF
				}
				rlonValid = rlonFrontByte != 0xFF && rlonRelayByte != 0xFF
				if rlonValid {
					if rlonFrontByte == 0x00 {
						c.addEvent(ri, 0, 5, rlonRelayByte)
					}
					if rlonFrontByte == 0x01 {
						c.addEvent(ri, 0, 6, rlonRelayByte)
					}
				}
			}

			// Relays
			rloffValid := false
			rloffFrontByte := 0xFF
			rloffRelayByte := 0xFF
			if rloffFront == "" && rloffRelay == "" {
				rloffValid = true
			}
			if rloffFront != "" && rloffRelay != "" {
				rloffFrontByteN, err1 := strconv.Atoi(rloffFront)
				rloffRelayByteN, err2 := strconv.Atoi(rloffRelay)
				if err1 == nil {
					rloffFrontByte = rloffFrontByteN
				}
				if err2 == nil {
					rloffRelayByte = rloffRelayByteN
				}
				if rloffFrontByte == 0xFF || rloffRelayByte == 0xFF {
					rloffFrontByte = 0xFF
					rloffRelayByte = 0xFF
				}
				rloffValid = rloffFrontByte != 0xFF && rloffRelayByte != 0xFF
				if rloffValid {
					if rloffFrontByte == 0x00 {
						c.addEvent(ri, 1, 5, rloffRelayByte)
					}
					if rloffFrontByte == 0x01 {
						c.addEvent(ri, 1, 6, rloffRelayByte)
					}
				}
			}

			// Time
			tonValid := false
			tonHByte := 0xFF
			tonMByte := 0xFF
			if tonH == "" && tonM == "" {
				tonValid = true
			}
			if tonH != "" && tonM != "" {
				tonHByteN, err1 := strconv.Atoi(tonH)
				tonMByteN, err2 := strconv.Atoi(tonM)
				if err1 == nil {
					tonHByte = tonHByteN
				}
				if err2 == nil {
					tonMByte = tonMByteN
				}
				if tonHByte == 0xFF || tonMByte == 0xFF {
					tonHByte = 0xFF
					tonMByte = 0xFF
				}
				tonValid = tonHByte != 0xFF && tonMByte != 0xFF
				if tonValid {
					c.addEventTime(ri, 0, 8, tonHByte, tonMByte)
				}
			}

			// Time
			toffValid := false
			toffHByte := 0xFF
			toffMByte := 0xFF
			if toffH == "" && toffM == "" {
				toffValid = true
			}
			if toffH != "" && toffM != "" {
				toffHByteN, err1 := strconv.Atoi(toffH)
				toffMByteN, err2 := strconv.Atoi(toffM)
				if err1 == nil {
					toffHByte = toffHByteN
				}
				if err2 == nil {
					toffMByte = toffMByteN
				}
				if toffHByte == 0xFF || toffMByte == 0xFF {
					toffHByte = 0xFF
					toffMByte = 0xFF
				}
				toffValid = toffHByte != 0xFF && toffMByte != 0xFF
				if toffValid {
					c.addEventTime(ri, 1, 8, toffHByte, toffMByte)
				}
			}
		}
	}

	c.lvItems.SetCellText2(0, 1, formatValue(compileEEPROMIndex))
	c.lvItems.SetCellText2(0, 2, formatValue(project.CurrentProject.Inversion))
	c.lvItems.SetCellText2(0, 3, formatValue(project.CurrentProject.GetEscortBlock()))
	c.lvItems.SetCellText2(0, 4, formatValue(project.CurrentProject.GetEscortTimer()))

	// if FF = grey color
	for i := 0; i < c.lvItems.RowCount(); i++ {
		for j := 1; j < c.lvItems.ColumnCount(); j++ {
			cellText := c.lvItems.GetCellText2(i, j)
			if cellText == "FF" {
				c.lvItems.SetCellColor(i, j, ui.ColorFromHex("#CCCCCC"))
			} else {
				c.lvItems.SetCellColor(i, j, ui.ColorFromHex("#007000"))
			}
		}
	}

	c.lvItems.SetCellColor(0, 1, ui.ColorFromHex("#004080"))
	c.lvItems.SetCellColor(0, 2, ui.ColorFromHex("#004080"))
	c.lvItems.SetCellColor(0, 3, ui.ColorFromHex("#004080"))
	c.lvItems.SetCellColor(0, 4, ui.ColorFromHex("#004080"))

	// Fill EEPROM Object
	eeprom := project.NewEEPROM()
	for i := 0; i < c.lvItems.RowCount(); i++ {
		for j := 0; j < c.lvItems.ColumnCount(); j++ {
			cellText := c.lvItems.GetCellText2(i, j)
			eeprom.Rows[i].Cells[j] = cellText
		}
	}
	project.CurrentEEPROM = eeprom

	if c.OnCompiled != nil {
		c.OnCompiled()
	}
}

func (c *EepromWidget) clearEEPROM() {
	for i := 0; i < c.lvItems.RowCount(); i++ {
		c.lvItems.SetCellText2(i, 0, strconv.FormatInt(int64(i), 10))
		for j := 1; j < c.lvItems.ColumnCount(); j++ {
			c.lvItems.SetCellText2(i, j, formatValue(0xFF))
		}
	}
}
