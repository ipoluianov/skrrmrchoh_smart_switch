void registers()
{

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1 
PORTA=0xFF;
DDRA=0xFF;

// Port B initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=0 State6=P State5=1 State4=0 State3=0 State2=0 State1=0 State0=P 
PORTB=0x61;
DDRB=0xBE;

// Port C initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=P State6=0 State5=0 State4=0 State3=0 State2=P State1=P State0=P 
PORTC=0x87;
DDRC=0x78;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=In 
// State7=P State6=P State5=P State4=P State3=P State2=0 State1=0 State0=P 
DDRD=0x06;
PORTD=0xF9;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x27;
OCR1AL=0x10;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x10;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200 (Double Speed Mode)
UCSRA=0x02;
UCSRB=0x18;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x10;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 1000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
//SPCR=0x51;
//SPSR=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 1000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: LSB First
SPCR=0x71;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// I2C Bus initialization
i2c_init();

// Global enable interrupts
#asm("sei")

        digit_1 = 11;
        digit_2 = 11;
        digit_3 = 11;
        digit_4 = 11;

        i2c_start();
        i2c_write(0xd0);
        i2c_write(0);
        i2c_start();
        i2c_write(0xd1);
        sec=bcd2bin(i2c_read(1)&0x7F);
        minute=bcd2bin(i2c_read(1)&0x7F);
        hour=bcd2bin(i2c_read(1)&0x3F); 
        day=bcd2bin(i2c_read(1)&0x07);
        date=bcd2bin(i2c_read(1)&0x3F);
        month=bcd2bin(i2c_read(1)&0x1F);
        year=bcd2bin(i2c_read(1)&0xFF);
        calibration=bcd2bin(i2c_read(1)&0xFF);
        year_thousands=bcd2bin(i2c_read(0)&0xFF);
        i2c_stop();
        
        
        {   //Prevents generating "rising edge" event after reset on all opened switches 
            unsigned  i=0;
            for (i=0; i < (double_click_counter_value + 10); i++)
            {
                get_165_reg();
                rattle_supression();
                edge_detection();
            };
        }             
        
     
settings[0]=14; //how many lines of settings are there;
settings[1]=0;
settings[2]=0;
settings[3]=0;
settings[4]=0;
settings[5]=0;
settings[6]=0;
settings[7]=0;
settings[8]=0;
settings[9]=0;
settings[10]=0;
settings[11]=0;
settings[12]=0;
settings[13]=0;
settings[14]=0;
settings[15]=0;

settings_line_1[0] = 0;    //Relay number 0...15
settings_line_1[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_1[2] = 0;    //falling edge on switch #...
settings_line_1[3] = 0xFF; //rising  edge on switch #...
settings_line_1[4] = 0xFF; //falling edge on relay #...
settings_line_1[5] = 15;   //rising  edge on relay #...
settings_line_1[6] = 0xFF; //double click on switch #...
settings_line_1[7] = 0xFF; //time, hours
settings_line_1[8] = 0xFF; //time, minutes
settings_line_1[9] = 0xFF;
settings_line_1[10] = 0xFF;
settings_line_1[11] = 0xFF;
settings_line_1[12] = 0xFF;
settings_line_1[13] = 0xFF;
settings_line_1[14] = 0xFF;
settings_line_1[15] = 0xFF;

settings_line_2[0] = 0;    //Relay number 0...15
settings_line_2[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_2[2] = 0xFF; //falling edge on switch #...
settings_line_2[3] = 0;    //rising  edge on switch #...
settings_line_2[4] = 15;   //falling edge on relay #...
settings_line_2[5] = 0xFF; //rising  edge on relay #...
settings_line_2[6] = 0xFF; //double click on switch #...
settings_line_2[7] = 0xFF; //time, hours
settings_line_2[8] = 0xFF; //time, minutes
settings_line_2[9] = 0xFF;
settings_line_2[10] = 0xFF;
settings_line_2[11] = 0xFF;
settings_line_2[12] = 0xFF;
settings_line_2[13] = 0xFF;
settings_line_2[14] = 0xFF;
settings_line_2[15] = 0xFF;

settings_line_3[0] = 1;   //Relay number 0...15
settings_line_3[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_3[2] = 1;    //falling edge on switch #...
settings_line_3[3] = 0xFF; //rising  edge on switch #...
settings_line_3[4] = 0xFF; //falling edge on relay #...
settings_line_3[5] = 0xFF; //rising  edge on relay #...
settings_line_3[6] = 0xFF; //double click on switch #...
settings_line_3[7] = 0xFF; //time, hours
settings_line_3[8] = 0xFF; //time, minutes
settings_line_3[9] = 0xFF;
settings_line_3[10] = 0xFF;
settings_line_3[11] = 0xFF;
settings_line_3[12] = 0xFF;
settings_line_3[13] = 0xFF;
settings_line_3[14] = 0xFF;
settings_line_3[15] = 0xFF;

settings_line_4[0] = 1;   //Relay number 0...15
settings_line_4[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_4[2] = 0xFF; //falling edge on switch #...
settings_line_4[3] = 1;    //rising  edge on switch #...
settings_line_4[4] = 0xFF; //falling edge on relay #...
settings_line_4[5] = 0xFF; //rising  edge on relay #...
settings_line_4[6] = 0xFF; //double click on switch #...
settings_line_4[7] = 0xFF; //time, hours
settings_line_4[8] = 0xFF; //time, minutes
settings_line_4[9] = 0xFF;
settings_line_4[10] = 0xFF;
settings_line_4[11] = 0xFF;
settings_line_4[12] = 0xFF;
settings_line_4[13] = 0xFF;
settings_line_4[14] = 0xFF;
settings_line_4[15] = 0xFF;

settings_line_5[0] = 2;   //Relay number 0...15
settings_line_5[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_5[2] = 2;    //falling edge on switch #...
settings_line_5[3] = 0xFF; //rising  edge on switch #...
settings_line_5[4] = 0xFF; //falling edge on relay #...
settings_line_5[5] = 0xFF; //rising  edge on relay #...
settings_line_5[6] = 0xFF; //double click on switch #...
settings_line_5[7] = 0xFF; //time, hours
settings_line_5[8] = 0xFF; //time, minutes
settings_line_5[9] = 0xFF;
settings_line_5[10] = 0xFF;
settings_line_5[11] = 0xFF;
settings_line_5[12] = 0xFF;
settings_line_5[13] = 0xFF;
settings_line_5[14] = 0xFF;
settings_line_5[15] = 0xFF;

settings_line_6[0] = 2;   //Relay number 0...15
settings_line_6[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_6[2] = 0xFF; //falling edge on switch #...
settings_line_6[3] = 2;    //rising  edge on switch #...
settings_line_6[4] = 0xFF; //falling edge on relay #...
settings_line_6[5] = 0xFF; //rising  edge on relay #...
settings_line_6[6] = 0xFF; //double click on switch #...
settings_line_6[7] = 0xFF; //time, hours
settings_line_6[8] = 0xFF; //time, minutes
settings_line_6[9] = 0xFF;
settings_line_6[10] = 0xFF;
settings_line_6[11] = 0xFF;
settings_line_6[12] = 0xFF;
settings_line_6[13] = 0xFF;
settings_line_6[14] = 0xFF;
settings_line_6[15] = 0xFF;

settings_line_7[0] = 3;   //Relay number 0...15
settings_line_7[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_7[2] = 3;    //falling edge on switch #...
settings_line_7[3] = 0xFF; //rising  edge on switch #...
settings_line_7[4] = 0xFF; //falling edge on relay #...
settings_line_7[5] = 0xFF; //rising  edge on relay #...
settings_line_7[6] = 0xFF; //double click on switch #...
settings_line_7[7] = 0xFF; //time, hours
settings_line_7[8] = 0xFF; //time, minutes
settings_line_7[9] = 0xFF;
settings_line_7[10] = 0xFF;
settings_line_7[11] = 0xFF;
settings_line_7[12] = 0xFF;
settings_line_7[13] = 0xFF;
settings_line_7[14] = 0xFF;
settings_line_7[15] = 0xFF;

settings_line_8[0] = 3;   //Relay number 0...15
settings_line_8[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_8[2] = 0xFF; //falling edge on switch #...
settings_line_8[3] = 3;    //rising  edge on switch #...
settings_line_8[4] = 0xFF; //falling edge on relay #...
settings_line_8[5] = 0xFF; //rising  edge on relay #...
settings_line_8[6] = 0xFF; //double click on switch #...
settings_line_8[7] = 0xFF; //time, hours
settings_line_8[8] = 0xFF; //time, minutes
settings_line_8[9] = 0xFF;
settings_line_8[10] = 0xFF;
settings_line_8[11] = 0xFF;
settings_line_8[12] = 0xFF;
settings_line_8[13] = 0xFF;
settings_line_8[14] = 0xFF;
settings_line_8[15] = 0xFF;

settings_line_9[0] = 4;   //Relay number 0...15
settings_line_9[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_9[2] = 4;    //falling edge on switch #...
settings_line_9[3] = 0xFF; //rising  edge on switch #...
settings_line_9[4] = 0xFF; //falling edge on relay #...
settings_line_9[5] = 0xFF; //rising  edge on relay #...
settings_line_9[6] = 0xFF; //double click on switch #...
settings_line_9[7] = 0xFF; //time, hours
settings_line_9[8] = 0xFF; //time, minutes
settings_line_9[9] = 0xFF;
settings_line_9[10] = 0xFF;
settings_line_9[11] = 0xFF;
settings_line_9[12] = 0xFF;
settings_line_9[13] = 0xFF;
settings_line_9[14] = 0xFF;
settings_line_9[15] = 0xFF;

settings_line_10[0] = 4;   //Relay number 0...15
settings_line_10[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_10[2] = 0xFF; //falling edge on switch #...
settings_line_10[3] = 4;    //rising  edge on switch #...
settings_line_10[4] = 0xFF; //falling edge on relay #...
settings_line_10[5] = 0xFF; //rising  edge on relay #...
settings_line_10[6] = 0xFF; //double click on switch #...
settings_line_10[7] = 0xFF; //time, hours
settings_line_10[8] = 0xFF; //time, minutes
settings_line_10[9] = 0xFF;
settings_line_10[10] = 0xFF;
settings_line_10[11] = 0xFF;
settings_line_10[12] = 0xFF;
settings_line_10[13] = 0xFF;
settings_line_10[14] = 0xFF;
settings_line_10[15] = 0xFF;

settings_line_11[0] = 5;   //Relay number 0...15
settings_line_11[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_11[2] = 5;    //falling edge on switch #...
settings_line_11[3] = 0xFF; //rising  edge on switch #...
settings_line_11[4] = 0xFF; //falling edge on relay #...
settings_line_11[5] = 0xFF; //rising  edge on relay #...
settings_line_11[6] = 0xFF; //double click on switch #...
settings_line_11[7] = 0xFF; //time, hours
settings_line_11[8] = 0xFF; //time, minutes
settings_line_11[9] = 0xFF;
settings_line_11[10] = 0xFF;
settings_line_11[11] = 0xFF;
settings_line_11[12] = 0xFF;
settings_line_11[13] = 0xFF;
settings_line_11[14] = 0xFF;
settings_line_11[15] = 0xFF;

settings_line_12[0] = 5;   //Relay number 0...15
settings_line_12[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_12[2] = 0xFF; //falling edge on switch #...
settings_line_12[3] = 5;    //rising  edge on switch #...
settings_line_12[4] = 0xFF; //falling edge on relay #...
settings_line_12[5] = 0xFF; //rising  edge on relay #...
settings_line_12[6] = 0xFF; //double click on switch #...
settings_line_12[7] = 0xFF; //time, hours
settings_line_12[8] = 0xFF; //time, minutes
settings_line_12[9] = 0xFF;
settings_line_12[10] = 0xFF;
settings_line_12[11] = 0xFF;
settings_line_12[12] = 0xFF;
settings_line_12[13] = 0xFF;
settings_line_12[14] = 0xFF;
settings_line_12[15] = 0xFF;

settings_line_13[0] = 15;   //Relay number 0...15
settings_line_13[1] = 1;    //Action 0-turn OFF; 1-turn ON
settings_line_13[2] = 0xFF; //falling edge on switch #...
settings_line_13[3] = 0xFF; //rising  edge on switch #...
settings_line_13[4] = 0xFF; //falling edge on relay #...
settings_line_13[5] = 1   ; //rising  edge on relay #...
settings_line_13[6] = 0xFF; //double click on switch #...
settings_line_13[7] = 0xFF; //time, hours
settings_line_13[8] = 0xFF; //time, minutes
settings_line_13[9] = 0xFF;
settings_line_13[10] = 0xFF;
settings_line_13[11] = 0xFF;
settings_line_13[12] = 0xFF;
settings_line_13[13] = 0xFF;
settings_line_13[14] = 0xFF;
settings_line_13[15] = 0xFF;

settings_line_14[0] = 15;   //Relay number 0...15
settings_line_14[1] = 0;    //Action 0-turn OFF; 1-turn ON
settings_line_14[2] = 0xFF; //falling edge on switch #...
settings_line_14[3] = 0xFF; //rising  edge on switch #...
settings_line_14[4] = 1;    //falling edge on relay #...
settings_line_14[5] = 0xFF; //rising  edge on relay #...
settings_line_14[6] = 0xFF; //double click on switch #...
settings_line_14[7] = 0xFF; //time, hours
settings_line_14[8] = 0xFF; //time, minutes
settings_line_14[9] = 0xFF;
settings_line_14[10] = 0xFF;
settings_line_14[11] = 0xFF;
settings_line_14[12] = 0xFF;
settings_line_14[13] = 0xFF;
settings_line_14[14] = 0xFF;
settings_line_14[15] = 0xFF;
}