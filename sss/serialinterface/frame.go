package serialinterface

import (
	"encoding/hex"
	"errors"
)

type Frame struct {
	AddrDest byte
	AddrSrc  byte
	Function byte
	SubAddr1 byte
	SubAddr2 byte
	Data     []byte
	CRC      byte
}

func NewFrame() *Frame {
	var c Frame
	return &c
}

func (c *Frame) ToBytes() []byte {
	frameBytes := make([]byte, 24)
	frameBytes[0] = c.AddrDest
	frameBytes[1] = c.AddrSrc
	frameBytes[2] = c.Function
	frameBytes[3] = c.SubAddr1
	frameBytes[4] = c.SubAddr2
	copy(frameBytes[5:], c.Data)
	return frameBytes
}

func FrameFromBytes(data []byte) (*Frame, error) {
	if len(data) < 24 {
		return nil, errors.New("data too short")
	}
	var c Frame
	c.AddrDest = data[0]
	c.AddrSrc = data[1]
	c.Function = data[2]
	c.SubAddr1 = data[3]
	c.SubAddr2 = data[4]
	c.Data = make([]byte, 18)
	c.CRC = data[23]
	copy(c.Data, data[5:24])
	return &c, nil
}

func (c *Frame) String() string {
	result := "\n"
	result += "AddrDest: 0x" + hex.EncodeToString([]byte{c.AddrDest}) + "\n"
	result += "AddrSrc: 0x" + hex.EncodeToString([]byte{c.AddrSrc}) + "\n"
	result += "Function: 0x" + hex.EncodeToString([]byte{c.Function}) + "\n"
	result += "SubAddr1: 0x" + hex.EncodeToString([]byte{c.SubAddr1}) + "\n"
	result += "SubAddr2: 0x" + hex.EncodeToString([]byte{c.SubAddr2}) + "\n"

	dataHex := hex.EncodeToString(c.Data)
	formattedData := ""
	for i := 0; i < len(dataHex); i += 2 {
		if i > 0 {
			formattedData += " "
		}
		formattedData += dataHex[i : i+2]
	}
	result += "Data (HEX): " + formattedData + "\n"
	result += "CRC: 0x" + hex.EncodeToString([]byte{c.CRC}) + "\n"
	return result
}
