package settingswidget

import "github.com/u00io/nuiforms/ui"

type SettingsWidget struct {
	ui.Widget

	lvItems *ui.Table
}

func NewSettingsWidget() *SettingsWidget {
	var c SettingsWidget
	c.InitWidget()
	c.SetLayout(`
<column>
	<table id="lvItems" />
</column>
	`, &c, nil)

	c.lvItems = c.FindWidgetByName("lvItems").(*ui.Table)

	c.lvItems.SetColumnCount(2)

	c.lvItems.SetColumnName(0, "Параметр")
	c.lvItems.SetColumnName(1, "Значение")

	c.lvItems.SetColumnWidth(0, 200)
	c.lvItems.SetColumnWidth(1, 200)

	c.lvItems.SetRowCount(10)
	return &c
}
