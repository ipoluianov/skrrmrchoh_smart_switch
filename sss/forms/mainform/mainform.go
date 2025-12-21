package mainform

import (
	"sss/forms/bottompanel"
	"sss/forms/centerpanel"
	"sss/forms/toppanel"

	"github.com/u00io/nui/nuikey"
	"github.com/u00io/nuiforms/ui"
)

type MainForm struct {
	ui.Widget

	topPanel    *toppanel.TopPanel
	centerPanel *centerpanel.CenterPanel
	bottomPanel *bottompanel.BottomPanel
}

func NewMainForm() *MainForm {
	var c MainForm
	c.InitWidget()

	c.topPanel = toppanel.NewTopPanel()
	c.topPanel.OnModeChanged = c.modeChanged

	c.centerPanel = centerpanel.NewCenterPanel()
	c.bottomPanel = bottompanel.NewBottomPanel()

	customWidgets := map[string]ui.Widgeter{
		"topPanel":    c.topPanel,
		"centerPanel": c.centerPanel,
		"bottomPanel": c.bottomPanel,
	}

	c.SetLayout(`
<column>
	<widget id="topPanel" />
	<widget id="centerPanel"/>
	<widget id="bottomPanel" />
</column>
	`, &c, customWidgets)

	ui.MainForm.SetOnGlobalKeyDown(c.onKeyDown)

	c.topPanel.BtnRelays()

	return &c
}

func (c *MainForm) modeChanged(mode string) {
	c.centerPanel.SetMode(mode)
}

func (c *MainForm) onKeyDown(keyCode nuikey.Key, mods nuikey.KeyModifiers) bool {
	switch keyCode {
	case nuikey.KeyF1:
		c.topPanel.BtnRelays()
	case nuikey.KeyF2:
		c.topPanel.BtnSummary()
	case nuikey.KeyF3:
		c.topPanel.BtnSettings()
	case nuikey.KeyF4:
		c.topPanel.BtnEeprom()
	default:
		return false
	}
	return true
}
