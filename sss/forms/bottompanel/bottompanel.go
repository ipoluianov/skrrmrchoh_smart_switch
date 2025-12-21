package bottompanel

import (
	"sss/serialinterface"
	"strconv"

	"github.com/u00io/nuiforms/ui"
)

type BottomPanel struct {
	ui.Widget
}

func NewBottomPanel() *BottomPanel {
	var c BottomPanel
	c.InitWidget()
	c.SetMinHeight(40)
	c.SetMaxHeight(40)
	c.SetOnPaint(c.onPaint)
	return &c
}

func (c *BottomPanel) onPaint(cnv *ui.Canvas) {
	yOffset := 0

	xOffset := 0
	for switchIndex := 0; switchIndex < 24; switchIndex++ {
		width := 30
		if (switchIndex%4) == 0 && switchIndex != 0 {
			xOffset += 10
		}

		col := ui.ColorFromHex("#333333")
		on := serialinterface.Instance.IsSwitchOn(switchIndex)
		if on {
			col = ui.ColorFromHex("#0f77ee")
		}
		cnv.FillRect(xOffset, yOffset, width, 18, col)

		if on {
			cnv.SetColor(ui.ColorFromHex("#FFFFFF"))
		} else {
			cnv.SetColor(ui.ColorFromHex("#0f77ee"))
		}

		cnv.SetFontSize(12)
		cnv.SetFontFamily(c.FontFamily())
		cnv.SetHAlign(ui.HAlignCenter)
		cnv.DrawText(xOffset, yOffset, width, 18, strconv.FormatInt(int64(switchIndex), 10))

		xOffset += width + 2
	}

	yOffset += 20

	xOffset = 2
	for relayIndex := 0; relayIndex < 16; relayIndex++ {
		width := 47
		if (relayIndex%4) == 0 && relayIndex != 0 {
			xOffset += 10
		}

		col := ui.ColorFromHex("#333333")
		on := serialinterface.Instance.IsRelayOn(relayIndex)
		if on {
			col = ui.ColorFromHex("#f5a91d")
		}
		cnv.FillRect(xOffset, yOffset, width, 18, col)

		if on {
			cnv.SetColor(ui.ColorFromHex("#FFFFFF"))
		} else {
			cnv.SetColor(ui.ColorFromHex("#f5a91d"))
		}
		cnv.SetFontSize(12)
		cnv.SetFontFamily(c.FontFamily())
		cnv.SetHAlign(ui.HAlignCenter)
		cnv.DrawText(xOffset, yOffset, width, 18, strconv.FormatInt(int64(relayIndex), 10))

		xOffset += width + 2
	}
}
