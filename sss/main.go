package main

import (
	"sss/forms/mainform"
	"sss/localstorage"

	"github.com/u00io/gomisc/logger"
	"github.com/u00io/nuiforms/ui"
)

func main() {
	localstorage.Init("skrrmrchoh_smart_switch")
	logger.Init(localstorage.Path() + "/logs")

	ui.ApplyLightTheme()
	ui.ApplyBaseFontSize(16)

	form := ui.NewForm()
	form.SetTitle("Skrrmrchoh Smart Switch")
	form.SetSize(1300, 800)
	form.Panel().AddWidgetOnGrid(mainform.NewMainForm(), 0, 0)
	form.ExecMaximized()
}
