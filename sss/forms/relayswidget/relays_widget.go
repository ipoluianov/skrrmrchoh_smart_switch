package relayswidget

import (
	"sss/project"
	"strconv"

	"github.com/u00io/nui/nuikey"
	"github.com/u00io/nuiforms/ui"
)

type RelaysWidget struct {
	ui.Widget

	lvItems *ui.Table
	loading bool

	relaysWidgets []*RelayWidget
}

func NewRelaysWidget() *RelaysWidget {
	var c RelaysWidget
	c.InitWidget()
	c.SetLayout(`
<column>
	<table id="lvItems" />
</column>
	`, &c, nil)

	c.lvItems = c.FindWidgetByName("lvItems").(*ui.Table)
	c.lvItems.SetColumnCount(13)
	c.lvItems.SetColumnName(0, "Реле")
	c.lvItems.SetColumnName(1, "Включение по")
	c.lvItems.SetColumnName(2, "")
	c.lvItems.SetColumnName(3, "Отключение по")
	c.lvItems.SetColumnName(4, "")
	c.lvItems.SetColumnName(5, "Включение по")
	c.lvItems.SetColumnName(6, "")
	c.lvItems.SetColumnName(7, "Отключение по")
	c.lvItems.SetColumnName(8, "")
	c.lvItems.SetColumnName(9, "Включение по времени")
	c.lvItems.SetColumnName(10, "")
	c.lvItems.SetColumnName(11, "Отключение по времени")
	c.lvItems.SetColumnName(12, "")

	c.lvItems.SetHeaderRowCount(2)

	c.lvItems.SetColumnWidth(0, 270)

	c.lvItems.SetColumnWidth(1, 100)
	c.lvItems.SetColumnWidth(2, 170)
	c.lvItems.SetHeaderCellSpan2(0, 1, 1, 2)
	c.lvItems.SetColumnCellName2(1, 1, "фронту")
	c.lvItems.SetColumnCellName2(1, 2, "выключателя")

	c.lvItems.SetColumnWidth(3, 100)
	c.lvItems.SetColumnWidth(4, 170)
	c.lvItems.SetHeaderCellSpan2(0, 3, 1, 2)
	c.lvItems.SetColumnCellName2(1, 3, "фронту")
	c.lvItems.SetColumnCellName2(1, 4, "выключателя")

	c.lvItems.SetColumnWidth(5, 100)
	c.lvItems.SetColumnWidth(6, 170)
	c.lvItems.SetHeaderCellSpan2(0, 5, 1, 2)
	c.lvItems.SetColumnCellName2(1, 5, "фронту")
	c.lvItems.SetColumnCellName2(1, 6, "реле")

	c.lvItems.SetColumnWidth(7, 100)
	c.lvItems.SetColumnWidth(8, 170)
	c.lvItems.SetHeaderCellSpan2(0, 7, 1, 2)
	c.lvItems.SetColumnCellName2(1, 7, "фронту")
	c.lvItems.SetColumnCellName2(1, 8, "реле")

	c.lvItems.SetColumnWidth(9, 100)
	c.lvItems.SetColumnWidth(10, 150)
	c.lvItems.SetHeaderCellSpan2(0, 9, 1, 2)
	c.lvItems.SetColumnCellName2(1, 9, "часы")
	c.lvItems.SetColumnCellName2(1, 10, "минуты")

	c.lvItems.SetColumnWidth(11, 100)
	c.lvItems.SetColumnWidth(12, 150)
	c.lvItems.SetHeaderCellSpan2(0, 11, 1, 2)
	c.lvItems.SetColumnCellName2(1, 11, "часы")
	c.lvItems.SetColumnCellName2(1, 12, "минуты")

	c.lvItems.SetRowCount(16 * 8)

	for i := 0; i < 16; i++ {
		relayWidget := NewRelayWidget(i)
		c.relaysWidgets = append(c.relaysWidgets, relayWidget)
		c.lvItems.AddWidgetOnTable(relayWidget, i*8, 0, 1, 8)
	}

	/*c.lvItems.SetEditTriggerEnter(true)
	c.lvItems.SetEditTriggerF2(true)
	c.lvItems.SetEditTriggerDoubleClick(true)
	c.lvItems.SetEditTriggerKeyDown(true)*/

	c.lvItems.SetOnCellChanged(c.OnCellChanged)
	c.lvItems.SetOnKeyDown(c.onKeyDown)

	c.AddTimer(100, c.timerUpdate)

	c.LoadData()

	return &c
}

func (c *RelaysWidget) OnCellChanged(row int, column int, text string, data interface{}) bool {
	if c.loading {
		return true
	}

	// fronts 0-1 | 255 | empty
	if column == 1 || column == 3 || column == 5 || column == 7 {
		if text == "" {
			// ok
		} else {
			intVal, err := strconv.ParseInt(text, 10, 64)
			if err != nil || (intVal < 1 || intVal > 2) && intVal != 255 {
				c.LoadData()
				return false
			}
		}
	}

	// switches 0-23 | 255 | empty
	if column == 2 || column == 4 {
		if text == "" {
			// ok
		} else {
			intVal, err := strconv.ParseInt(text, 10, 64)
			if err != nil || (intVal < 0 || intVal > 23) && intVal != 255 {
				c.LoadData()
				return false
			}
		}
	}

	// relays 0-15 | 255 | empty
	if column == 6 || column == 8 {
		if text == "" {
			// ok
		} else {
			intVal, err := strconv.ParseInt(text, 10, 64)
			if err != nil || (intVal < 0 || intVal > 15) && intVal != 255 {
				c.LoadData()
				return false
			}
		}
	}

	item := &project.CurrentProject.Items[row]
	switch column {
	case 1:
		item.OnSW1 = text
	case 2:
		item.OnSW2 = text
	case 3:
		item.OffSW1 = text
	case 4:
		item.OffSW2 = text
	case 5:
		item.OnRl1 = text
	case 6:
		item.OnRl2 = text
	case 7:
		item.OffRl1 = text
	case 8:
		item.OffRl2 = text
	case 9:
		item.OnTm1 = text
	case 10:
		item.OnTm2 = text
	case 11:
		item.OffTm1 = text
	case 12:
		item.OffTm2 = text
	}
	c.LoadData()
	return true
}

func (c *RelaysWidget) onKeyDown(key nuikey.Key, mods nuikey.KeyModifiers) bool {
	if key == nuikey.KeyDelete {
		col := c.lvItems.CurrentColumn()
		row := c.lvItems.CurrentRow()
		if col == 0 {
			return false
		}
		c.lvItems.SetCellText2(row, col, "")
		return true
	}

	if key == nuikey.KeyEnter {
		col := c.lvItems.CurrentColumn()
		row := c.lvItems.CurrentRow()

		if col == 1 || col == 3 || col == 5 || col == 7 {
			currentValue := c.lvItems.GetCellText2(row, col)
			c.SelectFront(row, col, currentValue)
			return true
		}
	}
	return false
}

func (c *RelaysWidget) SelectFront(rowIndex int, columnIndex int, currentValue string) {
	widgetToFocusAfterClose := ui.MainForm.FocusedWidget()

	dialog := ui.NewDialog("Выбор фронта", 300, 400)
	dialog.ContentPanel().SetLayout(`
<column>
	<table id="lvItems" />
	<row>
		<hspacer />
		<button id="btnOK" text="OK" />
		<button id="btnCancel" text="Отмена" />
	</row>
</column>
	`, nil, nil)

	lvItems := dialog.ContentPanel().FindWidgetByName("lvItems").(*ui.Table)
	lvItems.SetColumnCount(2)
	lvItems.SetColumnName(0, "Код")
	lvItems.SetColumnName(1, "Описание")
	lvItems.SetColumnWidth(0, 50)
	lvItems.SetColumnWidth(1, 200)
	lvItems.SetRowCount(3)

	lvItems.SetCellText2(0, 0, "1")
	lvItems.SetCellDisplayText(0, 1, "ВКЛ")
	lvItems.SetCellText2(1, 0, "2")
	lvItems.SetCellDisplayText(1, 1, "ОТКЛ")
	lvItems.SetCellText2(2, 0, "255")
	lvItems.SetCellDisplayText(2, 1, "")
	selectedRow := -1
	for r := 0; r < lvItems.RowCount(); r++ {
		if lvItems.GetCellText2(r, 0) == currentValue {
			selectedRow = r
			break
		}
	}
	if selectedRow >= 0 {
		lvItems.SetCurrentCell2(selectedRow, 0)
	} else {
		lvItems.SetCurrentCell2(2, 0)
	}

	accept := func() {
		currentRow := lvItems.CurrentRow()
		selectedValue := lvItems.GetCellText2(currentRow, 0)
		c.lvItems.SetCellText2(rowIndex, columnIndex, selectedValue)
		c.lvItems.SetCellDisplayText(rowIndex, columnIndex, project.CurrentProject.DisplayTextForFront(selectedValue))
		c.LoadData()
		dialog.Close()
		widgetToFocusAfterClose.Focus()
	}

	btnOK := dialog.ContentPanel().FindWidgetByName("btnOK").(*ui.Button)
	btnOK.SetMinWidth(70)
	btnOK.SetOnButtonClick(func() {
		accept()
	})

	btnCancel := dialog.ContentPanel().FindWidgetByName("btnCancel").(*ui.Button)
	btnCancel.SetMinWidth(70)
	btnCancel.SetOnButtonClick(func() {
		dialog.Close()
		widgetToFocusAfterClose.Focus()
	})

	lvItems.SetOnKeyDown(func(key nuikey.Key, mods nuikey.KeyModifiers) bool {
		if key == nuikey.KeyEnter {
			accept()
			return true
		}
		return false
	})

	dialog.ShowDialog()
	lvItems.Focus()
}

func (c *RelaysWidget) LoadData() {
	c.loading = true
	ui.MainForm.LayoutingBlockPush()
	defer ui.MainForm.LayoutingBlockPop()
	ui.MainForm.UpdateBlockPush()
	defer ui.MainForm.UpdateBlockPop()

	// Load data from project to table
	for relayIndex := 0; relayIndex < 16; relayIndex++ {
		for rowIndex := 0; rowIndex < 8; rowIndex++ {
			row := relayIndex*8 + rowIndex
			item := project.CurrentProject.Items[relayIndex*8+rowIndex]
			c.lvItems.SetCellText2(row, 1, item.OnSW1)
			c.lvItems.SetCellText2(row, 2, item.OnSW2)
			c.lvItems.SetCellText2(row, 3, item.OffSW1)
			c.lvItems.SetCellText2(row, 4, item.OffSW2)
			c.lvItems.SetCellText2(row, 5, item.OnRl1)
			c.lvItems.SetCellText2(row, 6, item.OnRl2)
			c.lvItems.SetCellText2(row, 7, item.OffRl1)
			c.lvItems.SetCellText2(row, 8, item.OffRl2)
			c.lvItems.SetCellText2(row, 9, item.OnTm1)
			c.lvItems.SetCellText2(row, 10, item.OnTm2)
			c.lvItems.SetCellText2(row, 11, item.OffTm1)
			c.lvItems.SetCellText2(row, 12, item.OffTm2)

			// set display names
			c.lvItems.SetCellDisplayText(row, 1, project.CurrentProject.DisplayTextForFront(item.OnSW1))
			c.lvItems.SetCellDisplayText(row, 2, project.CurrentProject.DisplayTextForSwitchIndex(item.OnSW2))
			c.lvItems.SetCellDisplayText(row, 3, project.CurrentProject.DisplayTextForFront(item.OffSW1))
			c.lvItems.SetCellDisplayText(row, 4, project.CurrentProject.DisplayTextForSwitchIndex(item.OffSW2))
			c.lvItems.SetCellDisplayText(row, 5, project.CurrentProject.DisplayTextForFront(item.OnRl1))
			c.lvItems.SetCellDisplayText(row, 6, project.CurrentProject.DisplayTextForRelayIndex(item.OnRl2))
			c.lvItems.SetCellDisplayText(row, 7, project.CurrentProject.DisplayTextForFront(item.OffRl1))
			c.lvItems.SetCellDisplayText(row, 8, project.CurrentProject.DisplayTextForRelayIndex(item.OffRl2))

			c.lvItems.SetCellDisplayText(row, 9, project.CurrentProject.DisplayTextForHours(item.OnTm1))
			c.lvItems.SetCellDisplayText(row, 10, project.CurrentProject.DisplayTextForMinutes(item.OnTm2))
			c.lvItems.SetCellDisplayText(row, 11, project.CurrentProject.DisplayTextForHours(item.OffTm1))
			c.lvItems.SetCellDisplayText(row, 12, project.CurrentProject.DisplayTextForMinutes(item.OffTm2))

			c.lvItems.SetCellEditTriggerEnter(row, 9, true)
			c.lvItems.SetCellEditTriggerEnter(row, 10, true)
			c.lvItems.SetCellEditTriggerEnter(row, 11, true)
			c.lvItems.SetCellEditTriggerEnter(row, 12, true)
		}
	}
	c.loading = false
}

func (c *RelaysWidget) timerUpdate() {
	ui.MainForm.UpdateBlockPush()
	defer ui.MainForm.UpdateBlockPop()
	ui.MainForm.LayoutingBlockPush()
	defer ui.MainForm.LayoutingBlockPop()
	for _, rw := range c.relaysWidgets {
		rw.UpdateStatus()
	}
}
