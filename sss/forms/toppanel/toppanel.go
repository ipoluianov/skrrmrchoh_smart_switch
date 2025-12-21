package toppanel

import "github.com/u00io/nuiforms/ui"

type TopPanel struct {
	ui.Widget

	mode string

	OnModeChanged func(mode string)
}

func NewTopPanel() *TopPanel {
	var c TopPanel
	c.InitWidget()
	c.SetLayout(`
	<row>
		<button id="btnRelays" text="Реле (F1)" onclick="BtnRelays" />
		<button id="btnSummary" text="Сводка (F2)" onclick="BtnSummary" />
		<button id="btnSettings" text="Настройки (F3)" onclick="BtnSettings" />
		<button id="btnEeprom" text="Образ EEPROM (F4)" onclick="BtnEeprom" />
		<hspacer />
		<button text="Сохранить проект" onclick="BtnSaveProject" />
	</row>
	`, &c, nil)

	c.SetElevation(1)
	return &c
}

func (c *TopPanel) BtnRelays() {
	c.mode = "relays"
	if c.OnModeChanged != nil {
		c.OnModeChanged(c.mode)
	}
	c.updateButtons()
}

func (c *TopPanel) BtnSummary() {
	c.mode = "summary"
	if c.OnModeChanged != nil {
		c.OnModeChanged(c.mode)
	}
	c.updateButtons()
}

func (c *TopPanel) BtnSettings() {
	c.mode = "settings"
	if c.OnModeChanged != nil {
		c.OnModeChanged(c.mode)
	}
	c.updateButtons()
}

func (c *TopPanel) BtnEeprom() {
	c.mode = "eeprom"
	if c.OnModeChanged != nil {
		c.OnModeChanged(c.mode)
	}
	c.updateButtons()
}

func (c *TopPanel) updateButtons() {
	btnRelays := c.FindWidgetByName("btnRelays").(*ui.Button)
	btnSummary := c.FindWidgetByName("btnSummary").(*ui.Button)
	btnSettings := c.FindWidgetByName("btnSettings").(*ui.Button)
	btnEeprom := c.FindWidgetByName("btnEeprom").(*ui.Button)

	btnRelays.SetEnabled(c.mode != "relays")
	btnSummary.SetEnabled(c.mode != "summary")
	btnSettings.SetEnabled(c.mode != "settings")
	btnEeprom.SetEnabled(c.mode != "eeprom")

	btnRelays.SetRole("")
	btnSummary.SetRole("")
	btnSettings.SetRole("")
	btnEeprom.SetRole("")

	if c.mode == "relays" {
		btnRelays.SetRole("primary")
	}

	if c.mode == "summary" {
		btnSummary.SetRole("primary")
	}

	if c.mode == "settings" {
		btnSettings.SetRole("primary")
	}

	if c.mode == "eeprom" {
		btnEeprom.SetRole("primary")
	}
}
