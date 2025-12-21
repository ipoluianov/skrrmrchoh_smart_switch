package eepromwidget

import "github.com/u00io/nuiforms/ui"

type EepromWidget struct {
	ui.Widget

	lvItems *ui.Table
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
	</row>
	<table id="lvItems" />
</column>
	`, &c, nil)

	c.lvItems = c.FindWidgetByName("lvItems").(*ui.Table)

	c.lvItems.SetColumnCount(11)

	c.lvItems.SetHeaderRowCount(2)

	c.lvItems.SetColumnName(0, "Индекс")
	c.lvItems.SetColumnName(1, "Реле")
	c.lvItems.SetColumnCellName2(1, 1, "*строк")
	c.lvItems.SetColumnName(2, "Действие")
	c.lvItems.SetColumnCellName2(1, 2, "*инверсия")
	c.lvItems.SetColumnName(3, "Выключатель вниз")
	c.lvItems.SetColumnCellName2(1, 3, "*эскорт блок")
	c.lvItems.SetColumnName(4, "Выключатель вверх")
	c.lvItems.SetColumnCellName2(1, 4, "*эскорт таймер")
	c.lvItems.SetColumnName(5, "Реле выключается")
	c.lvItems.SetColumnName(6, "Реле включается")
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

	c.lvItems.SetRowCount(10)
	return &c
}
