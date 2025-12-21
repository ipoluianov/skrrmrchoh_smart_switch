package relayswidget

import (
	"fmt"
	"sss/serialinterface"

	"github.com/u00io/nuiforms/ui"
)

type RelayWidget struct {
	ui.Widget

	relayIndex int
}

func NewRelayWidget(relayIndex int) *RelayWidget {
	var c RelayWidget
	c.InitWidget()
	c.relayIndex = relayIndex
	c.SetElevation(1)
	c.SetLayout(`
<column>
	<panel autofillbackground="true" elevation="3" padding="1" spacing="0" />
	<label id="relayLabel" text="---" />
	<label id="statusLabel" text="Статус: ВКЛ" />
	<row>
		<button text="Включить" elevation="2" onclick="BtnSwitchOn" />
		<button text="Отключить" elevation="2" onclick="BtnSwitchOff" />
	</row>
	<label text="Отключить по таймеру" />
	<label text="нет"/>
	<vspacer />
</column>
	`, &c, nil)
	c.SetPanelPadding(0)
	c.SetCellPadding(0)
	c.SetAutoFillBackground(true)

	relayLabel := c.FindWidgetByName("relayLabel").(*ui.Label)
	relayLabel.SetText("Реле №" + fmt.Sprint(c.relayIndex))

	return &c
}

func (c *RelayWidget) BtnSwitchOn() {
	serialinterface.Instance.SwitchRelay(c.relayIndex, true)
}

func (c *RelayWidget) BtnSwitchOff() {
	serialinterface.Instance.SwitchRelay(c.relayIndex, false)
}

func (c *RelayWidget) UpdateStatus() {
	statusLabel := c.FindWidgetByName("statusLabel").(*ui.Label)
	if serialinterface.Instance.IsRelayOn(c.relayIndex) {
		statusLabel.SetText("Статус: ВКЛ")
		statusLabel.SetForegroundColor(ui.ColorFromHex("#00AA55"))
	} else {
		statusLabel.SetText("Статус: ВЫКЛ")
		statusLabel.SetForegroundColor(ui.ColorFromHex("#888888"))
	}
}
