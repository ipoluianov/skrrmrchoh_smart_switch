package project

import "strconv"

type EEPROMRow struct {
	Cells [11]string
}

type EEPROM struct {
	Rows [64]EEPROMRow
}

var CurrentEEPROM *EEPROM

func NewEEPROM() *EEPROM {
	var c EEPROM
	return &c
}

func (c *EEPROM) Cell(rowIndex int, cellIndex int) string {
	return c.Rows[rowIndex].Cells[cellIndex]
}

func (c *EEPROM) CellInt(rowIndex int, cellIndex int) int {
	val := c.Rows[rowIndex].Cells[cellIndex]
	intVal, _ := strconv.ParseInt(val, 16, 64)
	return int(intVal)
}

func (c *EEPROM) Marshal() ([]byte, int) {
	linesCount, _ := strconv.ParseInt(c.Rows[0].Cells[1], 16, 64)
	linesCount += 1
	data := make([]byte, linesCount*16)
	for i := range data {
		data[i] = 0xFF
	}
	for rowIndex := 0; rowIndex < int(linesCount); rowIndex++ {
		for cellIndex := 1; cellIndex < 11; cellIndex++ {
			val := c.Rows[rowIndex].Cells[cellIndex]
			intVal, _ := strconv.ParseInt(val, 16, 64)
			data[rowIndex*16+cellIndex-1] = byte(intVal)
		}
	}
	return data, int(linesCount * 16)
}
