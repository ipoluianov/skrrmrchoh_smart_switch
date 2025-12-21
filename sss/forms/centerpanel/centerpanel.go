package centerpanel

import (
	"sss/forms/eepromwidget"
	"sss/forms/relayswidget"
	"sss/forms/settingswidget"
	"sss/forms/summarywidget"

	"github.com/u00io/nuiforms/ui"
)

type CenterPanel struct {
	ui.Widget

	relaysWidget   *relayswidget.RelaysWidget
	summaryWidget  *summarywidget.SummaryWidget
	settingsWidget *settingswidget.SettingsWidget
	eepromWidget   *eepromwidget.EepromWidget

	mode string
}

func NewCenterPanel() *CenterPanel {
	var c CenterPanel
	c.InitWidget()

	c.relaysWidget = relayswidget.NewRelaysWidget()
	c.summaryWidget = summarywidget.NewSummaryWidget()
	c.settingsWidget = settingswidget.NewSettingsWidget()
	c.eepromWidget = eepromwidget.NewEepromWidget()

	c.settingsWidget.OnChanged = func() {
		c.relaysWidget.LoadData()
		c.eepromWidget.Compile()
	}

	c.relaysWidget.OnChanged = func() {
		c.eepromWidget.Compile()
	}

	c.eepromWidget.OnCompiled = func() {

		c.summaryWidget.LoadData()
	}

	c.eepromWidget.Compile()

	return &c
}

func (c *CenterPanel) SetMode(mode string) {
	c.mode = mode
	c.SetContentWidget()
}

func (c *CenterPanel) SetContentWidget() {
	ui.MainForm.UpdateBlockPush()
	defer ui.MainForm.UpdateBlockPop()
	ui.MainForm.LayoutingBlockPush()
	defer ui.MainForm.LayoutingBlockPop()
	c.RemoveAllWidgets()

	switch c.mode {
	case "relays":
		c.AddWidgetOnGrid(c.relaysWidget, 0, 0)
		c.relaysWidget.Activate()
	case "summary":
		c.AddWidgetOnGrid(c.summaryWidget, 0, 0)
	case "settings":
		c.AddWidgetOnGrid(c.settingsWidget, 0, 0)
	case "eeprom":
		c.AddWidgetOnGrid(c.eepromWidget, 0, 0)
	}
	ui.UpdateMainFormLayout()
}
