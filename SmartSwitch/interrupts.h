// Timer1 output compare A interrupt service routine
// once in 5 ms
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{


error_blinking_counter++;
seconds_blinking_counter++;
to_second_counter++;

if (rs485_timeout_counter < 10)
{
    rs485_timeout_counter++;
}

if (to_second_counter > 199)
{
    char i;
    to_second_counter = 0;

    for (i = 0; i < 16; i++)
    {               
        if (timers[i] > 0 && timers[i] != 65535)
        {
            if (timers[i] == 1)
            {
                timers[i] = 65535;    
            }
            else
            {
                timers[i]--;
            }
        }
            
    }
}

if(switching_relay_off_prohibited_counter>0)
{
    switching_relay_off_prohibited_counter --;
}
else
{
switching_relay_off_prohibited = 0;
};

if(OFF_timer>0)
{
    OFF_timer --;
};

if(sec_error_counter>0)
{
    sec_error_counter --;
}
else
{
    error=error | 0b00000001;
};        


if(Buttons==0)
{
    if(Back_to_main_menu_counter>0)
    {
        Back_to_main_menu_counter--;
    }
    else
    {
        menu=0;
    };
    if(Keyboard_inactive>0)
    {
        Keyboard_inactive--;
    };
};    
if(seconds_blinking_counter>199)
{
    seconds_blinking_counter =0;
};
if(error_blinking_counter>399)
{
    error_blinking_counter =0;
}; 

       
        DDRD  = 0x06;  //PORT as INPUT 
        PORTD = PORTD | 0b11111000;
        Buttons = PIND;
        Buttons = Buttons>>3;
        Buttons = 0xFF-Buttons;        
        Buttons = Buttons & 0b00011111;
        
        DDRD  = 0xFE;
        PORTD = PORTD | 0b11111000;
        TMP_LED = LEDs;
        TMP_LED  = 0xFF - TMP_LED; 
        TMP_LED  = TMP_LED<<3;
        // PORTD = PORTD & TMP_LED;
        PORTD = (PORTD & TMP_LED) | (PORTD & 0b00000111);      

switch (interrupt_counter) 
    {
        case 0 :    Anode_4=0;
                    Anode_1=1;
                    PORTA=symbols[digit_1];
        break;
        case 1 :    Anode_1=0;
                    Anode_2=1;
                    PORTA=symbols[digit_2];
                    if(seconds_blinking_counter <100 && seconds_blinking==1)
                    {
                        indicator_dp=0;
                    }
                    else
                    {
                        indicator_dp=1;
                    };
        break;
        case 2 :    Anode_2=0;
                    Anode_3=1;
                    PORTA=symbols[digit_3];
        break;
        case 3 :    Anode_3=0;
                    Anode_4=1;
                    PORTA=symbols[digit_4];

        break;
       
    };

interrupt_counter++;
if(interrupt_counter>3)
{
    interrupt_counter=0;
};




}


// 0 = Dest Address
// 1 = Src Address
// 2 = Function // 1 = Write EEPROM, 2 = Read EEPROM, 3 = Write Relay, ...
// 3 = SubAddress 0
// 4 = SubAddress 1
// 5 = Data 0
// ...
// 20 = Data 15
// 21 = Reserved
// 22 = Reserved
// 23 = CRC
char input_buffer_counter = 0;
char input_buffer[FRAME_SIZE];
bit frame_received = 0;

char output_buffer_counter = 0;
char output_buffer[FRAME_SIZE];

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)                                        
{
    
    if (rs485_timeout_counter >= 10)
    {
        input_buffer_counter = 0;
    }

    if (frame_received)
    {          
        return; // Last frame is being processed
    }
    
    
    
    input_buffer[input_buffer_counter] = UDR;
    input_buffer_counter++;
    rs485_timeout_counter = 0;
    
    if (input_buffer_counter >= FRAME_SIZE)
    {
        
        input_buffer_counter = 0;
        if (input_buffer[0] == rs485_addr)
        {
            
            unsigned char crc_in_frame = input_buffer[23];
            unsigned char crc_calculated = calculate_crc(input_buffer);
            
            if (crc_in_frame == crc_calculated || 1)
            {
                frame_received = 1;
            }
        }
    }
}

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
    if (output_buffer_counter < FRAME_SIZE)
    {
        UDR = output_buffer[output_buffer_counter];
        output_buffer_counter++;
    }
    else
    {
        RS_485_direction = 0;
    }
}
