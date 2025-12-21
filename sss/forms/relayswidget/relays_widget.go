package relayswidget

import (
	"github.com/u00io/nuiforms/ui"
)

type RelaysWidget struct {
	ui.Widget

	lvItems *ui.Table

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
	c.lvItems.SetColumnWidth(2, 150)
	c.lvItems.SetHeaderCellSpan2(0, 1, 1, 2)
	c.lvItems.SetColumnCellName2(1, 1, "фронту")
	c.lvItems.SetColumnCellName2(1, 2, "выключателя")

	c.lvItems.SetColumnWidth(3, 100)
	c.lvItems.SetColumnWidth(4, 150)
	c.lvItems.SetHeaderCellSpan2(0, 3, 1, 2)
	c.lvItems.SetColumnCellName2(1, 3, "фронту")
	c.lvItems.SetColumnCellName2(1, 4, "выключателя")

	c.lvItems.SetColumnWidth(5, 100)
	c.lvItems.SetColumnWidth(6, 150)
	c.lvItems.SetHeaderCellSpan2(0, 5, 1, 2)
	c.lvItems.SetColumnCellName2(1, 5, "фронту")
	c.lvItems.SetColumnCellName2(1, 6, "реле")

	c.lvItems.SetColumnWidth(7, 100)
	c.lvItems.SetColumnWidth(8, 150)
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

	c.AddTimer(100, c.timerUpdate)

	return &c
}

func (c *RelaysWidget) LoadData() {
	// Uniting cells
	for i := 0; i < 16; i++ {
		c.lvItems.CellBorderColor()
	}
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
