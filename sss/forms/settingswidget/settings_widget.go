package settingswidget

import (
	"sss/project"
	"strconv"

	"github.com/u00io/nuiforms/ui"
)

type SettingsWidget struct {
	ui.Widget

	lvItems *ui.Table
	loading bool

	OnChanged func()
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

	c.lvItems.SetRowCount(16 + 24 + 3)

	c.lvItems.SetOnCellChanged(c.onCellChanged)

	c.LoadSettings()

	return &c
}

func (c *SettingsWidget) LoadSettings() {
	// 16 relays names
	// 24 switches names

	c.loading = true

	for relayIndex := 0; relayIndex < 16; relayIndex++ {
		c.lvItems.SetCellText2(relayIndex, 0, "Реле "+strconv.Itoa(relayIndex+1)+" имя")
		c.lvItems.SetCellText2(relayIndex, 1, project.CurrentProject.DisplayTextForRelayIndex(strconv.Itoa(relayIndex)))
	}

	for switchIndex := 0; switchIndex < 24; switchIndex++ {
		c.lvItems.SetCellText2(16+switchIndex, 0, "Выключатель "+strconv.Itoa(switchIndex+1)+" имя")
		c.lvItems.SetCellText2(16+switchIndex, 1, project.CurrentProject.DisplayTextForSwitchIndex(strconv.Itoa(switchIndex)))
	}

	c.lvItems.SetCellText2(40, 0, "Инверсия сигналов (0-нет, 1-да)")
	c.lvItems.SetCellText2(40, 1, strconv.Itoa(project.CurrentProject.GetInversion()))
	c.lvItems.SetCellText2(41, 0, "Блокировка эскорта (0-нет, 1-да)")
	c.lvItems.SetCellText2(41, 1, strconv.Itoa(project.CurrentProject.GetEscortBlock()))
	c.lvItems.SetCellText2(42, 0, "Таймер эскорта (секунды)")
	c.lvItems.SetCellText2(42, 1, strconv.Itoa(project.CurrentProject.GetEscortTimer()))

	for row := 0; row < c.lvItems.RowCount(); row++ {
		c.lvItems.SetCellEditTriggerEnter(row, 1, true)
		c.lvItems.SetCellEditTriggerDoubleClick(row, 1, true)
		c.lvItems.SetCellEditTriggerF2(row, 1, true)
	}

	c.loading = false
}

func (c *SettingsWidget) onCellChanged(row int, col int, text string, data interface{}) bool {
	if c.loading {
		return true
	}

	if col != 1 {
		return false
	}

	if row < 16 {
		project.CurrentProject.SetDisplayTextForRelayIndex(row, text)
	}

	if row >= 16 && row < 40 {
		switchIndex := row - 16
		project.CurrentProject.SetDisplayTextForSwitchIndex(switchIndex, text)
	}

	if row == 40 {
		value, err := strconv.Atoi(text)
		if err == nil {
			project.CurrentProject.SetInversion(value)
		}
	}

	if row == 41 {
		value, err := strconv.Atoi(text)
		if err == nil {
			project.CurrentProject.SetEscortBlock(value)
		}
	}

	if row == 42 {
		value, err := strconv.Atoi(text)
		if err == nil {
			project.CurrentProject.SetEscortTimer(value)
		}
	}

	if c.OnChanged != nil {
		c.OnChanged()
	}

	return true
}
