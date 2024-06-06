package main

import (
	"fmt"
	"os"

	"sss_installer/tools"
)

func main() {
	// version := "2.4"

	var err error
	fmt.Println("Installer creation started ...")
	os.RemoveAll("temp")
	os.RemoveAll("bin")
	os.MkdirAll("temp", 0777)
	os.MkdirAll("bin", 0777)

	err = tools.Run("flutter", "../", []string{"build", "windows"})
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println("copy flutter application to bin")

	err = tools.CopyDirectory("../build/windows/runner/Release/", "bin/")
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println("copy redist to bin")
	err = tools.Unzip("../redist/redist.zip", "bin/")
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println("creating distributive ...")
	err = tools.Run("c:\\Program Files (x86)\\NSIS\\makensisw.exe", ".", []string{"install.nsi"})
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	fmt.Println("Complete")
}
