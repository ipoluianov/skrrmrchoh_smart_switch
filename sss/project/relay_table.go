package project

type RelayTableRow struct {
	Cells [13]string
}

type RelayTable struct {
	Rows [16 * 8]RelayTableRow
}

func NewRelayTable() *RelayTable {
	var c RelayTable
	return &c
}

func (c *RelayTable) Cell(rowIndex int, cellIndex int) string {
	return c.Rows[rowIndex].Cells[cellIndex]
}
