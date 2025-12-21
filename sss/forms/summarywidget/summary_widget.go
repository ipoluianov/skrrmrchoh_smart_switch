package summarywidget

import "github.com/u00io/nuiforms/ui"

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
