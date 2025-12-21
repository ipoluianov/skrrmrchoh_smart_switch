package eepromwidget

import (
	"strconv"
	"strings"
)

func formatValue(val int) string {
	if val < 0 || val > 255 {
		return "FF"
	}
	str := strconv.FormatInt(int64(val), 16)
	if len(str) == 1 {
		str = "0" + str
	}
	return strings.ToUpper(str)
}
