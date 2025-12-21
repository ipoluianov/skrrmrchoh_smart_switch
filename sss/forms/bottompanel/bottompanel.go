package bottompanel

import "github.com/u00io/nuiforms/ui"

type BottomPanel struct {
	ui.Widget
}

func NewBottomPanel() *BottomPanel {
	var c BottomPanel
	c.InitWidget()
	return &c
}
