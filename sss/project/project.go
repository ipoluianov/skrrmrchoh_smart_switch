package project

import (
	"encoding/json"
	"os"
	"strconv"

	"github.com/u00io/gomisc/logger"
)

type Project struct {
	Inversion   int
	EscortBlock int
	EscortTimer int

	Items    []RelayViewRow
	Settings []string
}

var CurrentProject *Project
var originalProjectData string

func HasChanged() bool {
	bs, _ := json.MarshalIndent(CurrentProject, "", " ")
	currentData := string(bs)
	return currentData != originalProjectData
}

func init() {
	CurrentProject = NewProject()
	err := CurrentProject.LoadFromFile()
	if err != nil {
		logger.Println("Could not load project from file:", err)
	}
}

type RelayViewRow struct {
	RowIndex int
	OnSW1    string
	OnSW2    string
	OffSW1   string
	OffSW2   string
	OnRl1    string
	OnRl2    string
	OffRl1   string
	OffRl2   string
	OnTm1    string
	OnTm2    string
	OffTm1   string
	OffTm2   string
}

func NewProject() *Project {
	var c Project
	c.Inversion = 0
	c.EscortBlock = 0
	c.EscortTimer = 0

	// Relays names
	for i := 0; i < 16; i++ {
		c.Settings = append(c.Settings, "Реле №"+strconv.FormatInt(int64(i), 10))
	}

	// Switches names
	for i := 0; i < 24; i++ {
		c.Settings = append(c.Settings, "Выключатель №"+strconv.FormatInt(int64(i), 10))
	}

	c.Settings = append(c.Settings, "")
	c.Settings = append(c.Settings, "")
	c.Settings = append(c.Settings, "")

	// Fill items
	for i := 0; i < 16*8; i++ {
		var item RelayViewRow
		item.RowIndex = i
		item.OnSW1 = ""
		item.OnSW2 = ""
		item.OffSW1 = ""
		item.OffSW2 = ""
		item.OnRl1 = ""
		item.OnRl2 = ""
		item.OffRl1 = ""
		item.OffRl2 = ""
		item.OnTm1 = ""
		item.OnTm2 = ""
		item.OffTm1 = ""
		item.OffTm2 = ""

		c.Items = append(c.Items, item)
	}

	return &c
}

func (c *Project) CheckIntegrity() {
	expectedItemsCount := 16 * 8
	for len(c.Items) < expectedItemsCount {
		var item RelayViewRow
		item.RowIndex = len(c.Items)
		c.Items = append(c.Items, item)
	}

	for len(c.Settings) < 16+24+3 {
		c.Settings = append(c.Settings, "")
	}
}

func (c *Project) LoadFromFile() error {
	filePath := logger.CurrentExePath() + "/project.sss"
	bs, err := os.ReadFile(filePath)
	if err != nil {
		bs, _ = json.MarshalIndent(c, "", " ")
		originalProjectData = string(bs)
		return err
	}
	err = json.Unmarshal(bs, c)
	c.CheckIntegrity()
	originalProjectData = string(bs)
	return err
}

func (c *Project) SaveToFile() error {
	filePath := logger.CurrentExePath() + "/project.sss"
	bs, _ := json.MarshalIndent(c, "", " ")
	err := os.WriteFile(filePath, bs, 0644)
	originalProjectData = string(bs)
	return err
}

func (c *Project) DisplayTextForRelayIndex(relayIndexStr string) string {
	if relayIndexStr == "" {
		return ""
	}
	relayIndex, err := strconv.Atoi(relayIndexStr)
	if err != nil {
		return "Реле №" + relayIndexStr
	}
	if relayIndex == 255 {
		return ""
	}
	if relayIndex < 0 || relayIndex >= 16 {
		return "Реле №" + strconv.FormatInt(int64(relayIndex), 10)
	}
	return c.Settings[relayIndex]
}

func (c *Project) DisplayTextForSwitchIndex(switchIndex string) string {
	if switchIndex == "" {
		return ""
	}
	switchIndexInt, err := strconv.Atoi(switchIndex)
	if err != nil {
		return "Выключатель №" + switchIndex
	}
	if switchIndexInt == 255 {
		return ""
	}
	if switchIndexInt < 0 || switchIndexInt >= 24 {
		return "Выключатель №" + strconv.FormatInt(int64(switchIndexInt), 10)
	}
	return c.Settings[16+switchIndexInt]
}

func (c *Project) DisplayTextForFront(frontStr string) string {
	if frontStr == "" {
		return ""
	}
	frontIndex, err := strconv.Atoi(frontStr)
	if err != nil {
		return ""
	}
	if frontIndex == 255 {
		return ""
	}
	if frontIndex == 0 {
		return "низх"
	}
	if frontIndex == 1 {
		return "восх"
	}
	return ""
}

func (c *Project) DisplayTextForHours(hoursStr string) string {
	if hoursStr == "" {
		return ""
	}
	hoursIndex, err := strconv.Atoi(hoursStr)
	if err != nil {
		return ""
	}
	if hoursIndex == 255 {
		return ""
	}
	if hoursIndex < 0 || hoursIndex > 23 {
		return ""
	}
	hrStr := strconv.FormatInt(int64(hoursIndex), 10)
	if len(hrStr) == 1 {
		hrStr = "0" + hrStr
	}
	return hrStr
}

func (c *Project) DisplayTextForMinutes(minutesStr string) string {
	if minutesStr == "" {
		return ""
	}
	minutesIndex, err := strconv.Atoi(minutesStr)
	if err != nil {
		return ""
	}
	if minutesIndex == 255 {
		return ""
	}
	if minutesIndex < 0 || minutesIndex > 59 {
		return ""
	}
	minStr := strconv.FormatInt(int64(minutesIndex), 10)
	if len(minStr) == 1 {
		minStr = "0" + minStr
	}
	return minStr
}

func (c *Project) SetDisplayTextForRelayIndex(relayIndex int, text string) {
	if relayIndex < 0 || relayIndex >= 16 {
		return
	}
	c.Settings[relayIndex] = text
}

func (c *Project) SetDisplayTextForSwitchIndex(switchIndex int, text string) {
	if switchIndex < 0 || switchIndex >= 24 {
		return
	}
	c.Settings[16+switchIndex] = text
}

func (c *Project) GetInversion() int {
	return c.Inversion
}

func (c *Project) GetEscortBlock() int {
	return c.EscortBlock
}

func (c *Project) GetEscortTimer() int {
	return c.EscortTimer
}

func (c *Project) SetInversion(value int) {
	c.Inversion = value
}

func (c *Project) SetEscortBlock(value int) {
	c.EscortBlock = value
}

func (c *Project) SetEscortTimer(value int) {
	c.EscortTimer = value
}

func (c *Project) ToRelayTable() *RelayTable {
	var table RelayTable
	for rowIndex, item := range c.Items {
		table.Rows[rowIndex].Cells[1] = item.OnSW1
		table.Rows[rowIndex].Cells[2] = item.OnSW2
		table.Rows[rowIndex].Cells[3] = item.OffSW1
		table.Rows[rowIndex].Cells[4] = item.OffSW2
		table.Rows[rowIndex].Cells[5] = item.OnRl1
		table.Rows[rowIndex].Cells[6] = item.OnRl2
		table.Rows[rowIndex].Cells[7] = item.OffRl1
		table.Rows[rowIndex].Cells[8] = item.OffRl2
		table.Rows[rowIndex].Cells[9] = item.OnTm1
		table.Rows[rowIndex].Cells[10] = item.OnTm2
		table.Rows[rowIndex].Cells[11] = item.OffTm1
		table.Rows[rowIndex].Cells[12] = item.OffTm2
	}
	return &table
}
