package serialinterface

import (
	"encoding/hex"
	"errors"
	"sync"
	"time"

	"github.com/tarm/serial"
	"github.com/u00io/gomisc/logger"
)

type SerialInterface struct {
	serialPort   *serial.Port
	serialConfig *serial.Config

	PortName string
	BaudRate int
	Timeout  int

	dtLastRelayStateRequest time.Time
	SwitchesStatus          [24]bool
	RelaysStatus            [16]bool

	mtx          sync.Mutex
	framesToSend []*Transaction
	eepromLines  []*EEPROMLine
	//completeTransactions []*Transaction
}

type EEPROMLine struct {
	LineIndex int
	Data      []byte
}

type Transaction struct {
	SentFrame     *Frame
	ReceivedFrame *Frame
	Error         error
}

var Instance *SerialInterface

func init() {
	Instance = NewSerialInterface()
	Instance.Start()
}

func NewSerialInterface() *SerialInterface {
	var c SerialInterface

	c.PortName = "COM5"
	c.BaudRate = 115200
	c.Timeout = 500

	return &c
}

func (c *SerialInterface) Start() {
	go c.thWork()
}

func (c *SerialInterface) Stop() {

}

func (c *SerialInterface) IsRelayOn(relayIndex int) bool {
	if relayIndex < 0 || relayIndex >= len(c.RelaysStatus) {
		return false
	}
	return c.RelaysStatus[relayIndex]
}

func (c *SerialInterface) IsSwitchOn(switchIndex int) bool {
	if switchIndex < 0 || switchIndex >= len(c.SwitchesStatus) {
		return false
	}
	return c.SwitchesStatus[switchIndex]
}

func (c *SerialInterface) WriteEEPROM(lineData []byte, lineIndex int) {
	var frame Frame
	frame.AddrDest = 0x06
	frame.AddrSrc = 0x00
	frame.Function = 0x01
	frame.SubAddr1 = byte(lineIndex)
	frame.Data = make([]byte, 16)
	copy(frame.Data, lineData)
	c.SendFrame(&frame)
	logger.Println("Wrote EEPROM line", lineIndex, "data:", hex.EncodeToString(lineData))
}

func (c *SerialInterface) ResetReeadEEPROMBuffer() {
	c.eepromLines = make([]*EEPROMLine, 0)
}

func (c *SerialInterface) GetEEPROMLine(index int) *EEPROMLine {
	if index < 0 || index >= len(c.eepromLines) {
		return nil
	}
	return c.eepromLines[index]
}

func (c *SerialInterface) ReadEEPROM(lineIndex int) {
	var frame Frame
	frame.AddrDest = 0x06
	frame.AddrSrc = 0x00
	frame.Function = 0x02
	frame.SubAddr1 = byte(lineIndex)
	c.SendFrame(&frame)
	logger.Println("Read EEPROM line", lineIndex)
}

func (c *SerialInterface) SwitchRelay(relayIndex int, turnOn bool) {
	var frame Frame
	frame.AddrDest = 0x06
	frame.AddrSrc = 0x00
	if turnOn {
		frame.Function = 0x05
	} else {
		frame.Function = 0x06
	}
	frame.Data = make([]byte, 1)
	frame.Data[0] = byte(relayIndex)
	c.SendFrame(&frame)
}

func (c *SerialInterface) SendFrame(frame *Frame) {
	var tr Transaction
	tr.SentFrame = frame
	tr.ReceivedFrame = nil
	tr.Error = nil

	c.mtx.Lock()
	c.framesToSend = append(c.framesToSend, &tr)
	c.mtx.Unlock()
}

/*func (c *SerialInterface) GetCompletedTransactions() []*Transaction {
	c.mtx.Lock()
	trs := c.completeTransactions
	c.completeTransactions = make([]*Transaction, 0)
	c.mtx.Unlock()
	return trs
}*/

func (c *SerialInterface) AddFrameRelaysStateIfNotExists() bool {
	if time.Since(c.dtLastRelayStateRequest) < 100*time.Millisecond {
		return false
	}
	c.dtLastRelayStateRequest = time.Now()

	for _, tr := range c.framesToSend {
		if tr.SentFrame.Function == 0x03 {
			return false
		}
	}
	var frame Frame
	frame.AddrDest = 0x06
	frame.AddrSrc = 0x00
	frame.Function = 0x03
	frame.Data = make([]byte, 0)
	c.framesToSend = append(c.framesToSend, &Transaction{SentFrame: &frame})
	return true
}

func (c *SerialInterface) ProcessTransactions() {
	c.mtx.Lock()
	c.AddFrameRelaysStateIfNotExists()
	framesToSend := c.framesToSend
	c.framesToSend = make([]*Transaction, 0)
	c.mtx.Unlock()

	for _, tr := range framesToSend {
		c.processTransaction(tr)
		c.mtx.Lock()
		//c.completeTransactions = append(c.completeTransactions, tr)
		c.mtx.Unlock()
	}
}

func (c *SerialInterface) processTransaction(tr *Transaction) {
	bs := tr.SentFrame.ToBytes()
	//logger.Println("Sending frame to", c.PortName, ":", tr.SentFrame, "bytes:", hex.EncodeToString(bs))

	_, err := c.serialPort.Write(bs)
	if err != nil {
		tr.Error = err
		logger.Println("error writing to serial port:", err)
		return
	}

	inputBuffer := make([]byte, 256)
	inputBufferOffset := 0
	for {
		n, err := c.serialPort.Read(inputBuffer[inputBufferOffset:])
		// logger.Println("Read", n, "bytes from serial port", hex.EncodeToString(inputBuffer[:inputBufferOffset+n]))
		if err != nil {
			tr.Error = err
			logger.Println("error reading from serial port:", err)
			return
		}
		if n == 0 {
			tr.Error = errors.New("timeout")
			logger.Println("timeout waiting for response")
			return
		}
		inputBufferOffset += n

		if inputBufferOffset >= 24 {
			receivedFrame, err := FrameFromBytes(inputBuffer[:inputBufferOffset])
			if err != nil {
				logger.Println("error parsing received frame:", err)
				tr.Error = err
				c.serialPort.Close()
				c.serialPort = nil
				return
			}
			// logger.Println("Received Frame:", receivedFrame)
			tr.ReceivedFrame = receivedFrame
			c.ProcessReceivedFrame(tr)
			tr.Error = nil
			return
		}
	}
}

func (c *SerialInterface) ProcessReceivedFrame(tr *Transaction) {
	if tr.ReceivedFrame.Function == 0x03 {
		if len(tr.ReceivedFrame.Data) < 2 {
			return
		}
		for i := 0; i < 24; i++ {
			byteIndex := i / 8
			bitIndex := 7 - (i % 8)
			if byteIndex >= len(tr.ReceivedFrame.Data) {
				break
			}
			c.SwitchesStatus[i] = (tr.ReceivedFrame.Data[byteIndex]&(1<<bitIndex) != 0)
			// logger.Println("Switch", i, "status:", c.SwitchesStatus[i])
		}

		for i := 0; i < 16; i++ {
			// 15 14 ..... 0
			byteIndex := 3 + (i / 8)
			bitIndex := (i % 8)
			c.RelaysStatus[i] = (tr.ReceivedFrame.Data[byteIndex]&(1<<bitIndex) != 0)
			// logger.Println("Relay", i, "status:", c.RelaysStatus[i])
		}
	}

	if tr.ReceivedFrame.Function == 0x02 {
		if len(tr.ReceivedFrame.Data) < 16 {
			return
		}
		lineIndex := int(tr.ReceivedFrame.SubAddr1)
		lineData := make([]byte, 16)
		copy(lineData, tr.ReceivedFrame.Data[:16])
		eepromLine := &EEPROMLine{
			LineIndex: lineIndex,
			Data:      lineData,
		}
		c.eepromLines = append(c.eepromLines, eepromLine)
		logger.Println("Received EEPROM line", lineIndex, "data:", hex.EncodeToString(lineData))
	}
}

func (c *SerialInterface) thWork() {
	var err error
	for {
		if c.serialPort == nil {
			time.Sleep(100 * time.Millisecond)
			logger.Println("opening port", c.PortName)
			c.serialConfig = &serial.Config{
				Name:        c.PortName,
				Baud:        int(c.BaudRate),
				ReadTimeout: time.Duration(c.Timeout) * time.Millisecond,
				Size:        byte(8),
				Parity:      serial.ParityNone,
				StopBits:    serial.Stop1,
			}

			c.serialPort, err = serial.OpenPort(c.serialConfig)
			if err != nil {
				logger.Println("error opening port:", err)
				c.serialPort = nil
			}
			logger.Println("port opened")
		}

		if c.serialPort == nil {
			time.Sleep(100 * time.Millisecond)
			continue
		}

		c.ProcessTransactions()
		time.Sleep(10 * time.Millisecond)
	}
}
