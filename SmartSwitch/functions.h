void get_165_reg()
{
        Reg_165_CLK_INH = 0;
        Reg_165_CLK = 0;   
        Reg_165_n_LOAD = 0;
        delay_us(10);
        Reg_165_n_LOAD = 1; 
        Reg_165_CLK_INH = 0; 
        
        reg_165_1 = 0; 
        reg_165_2 = 0;
        reg_165_3 = 0;

        { 
            char i=0;
            for (i=0; i<8; i++)
            { 
                reg_165_1 = reg_165_1<<1;  
                if(Reg_165_OUT)
                {
                    reg_165_1 = reg_165_1 +1;
                };
                     
                delay_us(5);  
                Reg_165_CLK = 1;
                delay_us(5);  
                Reg_165_CLK = 0;  
            };   

            for (i=0; i<8; i++)
            { 
                reg_165_2 = reg_165_2<<1;  
                if(Reg_165_OUT)
                {
                    reg_165_2 = reg_165_2 +1;
                };
                     
                delay_us(5);  
                Reg_165_CLK = 1;
                delay_us(5);  
                Reg_165_CLK = 0;  
            };   

            for (i=0; i<8; i++)
            { 
                reg_165_3 = reg_165_3<<1;  
                if(Reg_165_OUT)
                {
                    reg_165_3 = reg_165_3 +1;
                };
                     
                delay_us(5);  
                Reg_165_CLK = 1;
                delay_us(5);  
                Reg_165_CLK = 0;  
            };   
        }  
        
        TMP_8_bit = reg_165_1; 
        TMP_1_8_bit = 0;
        if(TMP_8_bit & 0b00000001)      
        {
        TMP_1_8_bit = TMP_1_8_bit+8;
        };        
        if(TMP_8_bit & 0b00000010)      
        {
        TMP_1_8_bit = TMP_1_8_bit+4;
        };
        if(TMP_8_bit & 0b00000100)      
        {
        TMP_1_8_bit = TMP_1_8_bit+2;
        };
        if(TMP_8_bit & 0b00001000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+1;
        };
        if(TMP_8_bit & 0b00010000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+128;
        };
        if(TMP_8_bit & 0b00100000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+64;
        };
        if(TMP_8_bit & 0b01000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+32;
        };
        if(TMP_8_bit & 0b10000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+16;
        }; 
        

        reg_165_1 = TMP_1_8_bit;
             
        
        TMP_8_bit = reg_165_2; 
        TMP_1_8_bit = 0;        
        if(TMP_8_bit & 0b00000001)      
        {
        TMP_1_8_bit = TMP_1_8_bit+8;
        };        
        if(TMP_8_bit & 0b00000010)      
        {
        TMP_1_8_bit = TMP_1_8_bit+4;
        };
        if(TMP_8_bit & 0b00000100)      
        {
        TMP_1_8_bit = TMP_1_8_bit+2;
        };
        if(TMP_8_bit & 0b00001000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+1;
        };
        if(TMP_8_bit & 0b00010000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+128;
        };
        if(TMP_8_bit & 0b00100000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+64;
        };
        if(TMP_8_bit & 0b01000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+32;
        };
        if(TMP_8_bit & 0b10000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+16;
        }; 
        

        reg_165_2 = TMP_1_8_bit;

        
        TMP_8_bit = reg_165_3; 
        TMP_1_8_bit = 0;        
        if(TMP_8_bit & 0b00000001)      
        {
        TMP_1_8_bit = TMP_1_8_bit+8;
        };        
        if(TMP_8_bit & 0b00000010)      
        {
        TMP_1_8_bit = TMP_1_8_bit+4;
        };
        if(TMP_8_bit & 0b00000100)      
        {
        TMP_1_8_bit = TMP_1_8_bit+2;
        };
        if(TMP_8_bit & 0b00001000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+1;
        };
        if(TMP_8_bit & 0b00010000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+128;
        };
        if(TMP_8_bit & 0b00100000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+64;
        };
        if(TMP_8_bit & 0b01000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+32;
        };
        if(TMP_8_bit & 0b10000000)      
        {
        TMP_1_8_bit = TMP_1_8_bit+16;
        }; 
        

        reg_165_3 = TMP_1_8_bit;

        
        if(eeprom_read_byte(1)==1)
        {
            reg_165_1 = ~reg_165_1;
            reg_165_2 = ~reg_165_2;
            reg_165_3 = ~reg_165_3;
        };                         
        
}

void contact_bounce_supression()
{
        { 
            char i=0;
            for (i=0; i<8; i++)
            { 
                if(reg_165_1 & (1 << i))
                {
                    if(switches_contact_bounce_supression[7-i] < contact_bounce_supression_value)
                    {
                        switches_contact_bounce_supression[7-i]++;
                    };
                }
                else
                {
                    if(switches_contact_bounce_supression[7-i] > 0)
                    {
                        switches_contact_bounce_supression[7-i]--;
                    };
                };
            };          
         } 
         
        { 
            char i=0;
            for (i=0; i<8; i++)
            { 
                if(reg_165_2 & (1 << i))
                {
                    if(switches_contact_bounce_supression[15-i] < contact_bounce_supression_value)
                    {
                        switches_contact_bounce_supression[15-i]++;
                    };
                }
                else
                {
                    if(switches_contact_bounce_supression[15-i] > 0)
                    {
                        switches_contact_bounce_supression[15-i]--;
                    };
                };
            };          
         } 
         
        { 
            char i=0;
            for (i=0; i<8; i++)
            { 
                if(reg_165_3 & (1 << i))
                {
                    if(switches_contact_bounce_supression[23-i] < contact_bounce_supression_value)
                    {
                        switches_contact_bounce_supression[23-i]++;
                    };
                }
                else
                {
                    if(switches_contact_bounce_supression[23-i] > 0)
                    {
                        switches_contact_bounce_supression[23-i]--;
                    };
                };
            };          
         }                   
}

void edge_detection()
{
        { 
            char i=0;
            for (i=0; i<24; i++)
            { 

                if(switches_contact_bounce_supression[i] == contact_bounce_supression_value)
                {                        
                // switches_state == 0 - didn't change
                // switches_state == 1 - there was falling edge         
                // switches_state == 2 - there was rising edge
                /* Double click:
                in case of double click variable "switches state" will change as follow:
                     _____      _____
                ____|     |____|     |_____
                 0 0 2 0 0 1  0 2 0 0 1 0 0
                     _     _    _     _ 
                    
                or 
                ____       ____       _____       
                    |_____|    |_____|
                 0 0 1 0 0 2  0 1 0 0 2 0 0
                     _     _    _     _ 
                 
                so we shall catch sequence "1-2-1" or "1-2-1-2" (2-1-2-1 in inverse situation).
                values in "switches_double_click" will be 3 or 4(4) respectively.
                Amount of zeroes between "1-2-1" we can not know, so we will just ignore them.
                Since double click itself is time-sensitive thing, we need counter
                for every switch. Counter starts when it detects first event.
                Changing "contact_bounce_supression_value" affects counter speed.  
                User shall make double click faster than double_click_counter empties.  
                */
                
                    if(switches_old_state[i] == contact_bounce_supression_value)
                    {
                        // nothing was changed
                        switches_state[i] = 0;
                    }; 
                    if(switches_old_state[i] == 0)
                    {
                        // this is rising edge
                        switches_state[i] = 2;
                        switches_double_click[i]++;
                        if(double_click_counter[i] ==0 )
                        {
                            double_click_counter[i] = double_click_counter_value;
                        };
                    };                    

                    switches_old_state[i] = switches_contact_bounce_supression[i]; 
                    
                };
                if(switches_contact_bounce_supression[i] == 0)
                {                        

                    if(switches_old_state[i] == 0)
                    {
                        // nothing was changed
                        switches_state[i] = 0;
                    }; 
                    if(switches_old_state[i] == contact_bounce_supression_value)
                    {
                        // this is falling edge
                        switches_state[i] = 1;
                        switches_double_click[i]++;
                        if(double_click_counter[i] ==0 )
                        {                        
                            double_click_counter[i] = double_click_counter_value;
                        };
                    };
                    
                    switches_old_state[i] = switches_contact_bounce_supression[i];                        
                
                };
                
                if(double_click_counter[i] > 0)
                {
                    double_click_counter[i] --;
                }
                else
                {
                    switches_double_click[i] = 0;    
                };                
            };
        } 
}

void relays_edge_detection()
{
    {
        char i=0;
        int  k=0;
        for (i=0; i<16; i++)    // for every relay
        {
            k = (1 << i);
            if(k & relays_16_oldstate)
            {   //if oldstate was 1... 
                if(k & relays_16)
                {   
                    //nothing changed
                    relays_state[i]=0;
                }
                else
                {
                    //falling edge
                    relays_state[i]=1;
                };
            }
            else
            {
                if(k & relays_16)
                {   
                    //rising edge
                    relays_state[i]=2;
                }
                else
                {
                    //nothing changed
                    relays_state[i]=0;
                };            
            };
        };
    }         

}

void switch_relay_on(char relay_index, char time_to_off)
{
    if (relay_index >= 0 && relay_index <= 15)
    {
        relays_16 = relays_16 | (1<<relay_index); //Turn the relay on 
        if (time_to_off != 255)
        {
            timers[relay_index] =  time_to_off * 60;
        }
    }
}

void switch_relay_off(char relay_index)
{
    if (relay_index >= 0 && relay_index <= 15)
    {
        relays_16 = relays_16 & ~(1<<relay_index); //Switch the relay off
    }
}

void execute_EE_line(char line_index, char check_prohibition) 
{
    unsigned char relay_index = eeprom_read_byte(16*line_index);        // reading value from settings_line[0]
    unsigned char action = eeprom_read_byte(16*line_index + 1);         // reading value from settings_line[1] 
    unsigned char time_to_off = eeprom_read_byte(16*line_index + 9);    // reading value from settings_line[9]
    
    if(action == 2) //see if inverting relay is needed
    {                                    
        if(relays_16 & (1<<relay_index)) //if relay is turned on
        {
            if(switching_relay_off_prohibited == 0 || check_prohibition == 0)
            {
                switch_relay_off(relay_index);    
            };                                    
        }
        else
        {                                                                                             
            switch_relay_on(relay_index, time_to_off); 
        };
    };                                                                    
    if (action == 1) // see if turning relay on is needed
    {
        switch_relay_on(relay_index, time_to_off);
    };
    if (action == 0) // see if turning relay off is needed
    {
        if(switching_relay_off_prohibited == 0 || check_prohibition == 0)
        {
            switch_relay_off(relay_index);
        };                                        
    };     
} 

void switches_event_check()
{ 
        { 
            char i=0;
            for (i=0; i<24; i++)    // for every switch
            {   
                if(switches_state[i] ==1 )//&& switches_double_click[i] <4) //when only "falling edge" occurs
                {
                    
                    { 
                        char j=1;
                        for (j=1; j<=(settings[0]); j++) // for every "settings" line
                        {
                            if(eeprom_read_byte(16*j+2) ==i) // Look in all "settings" lines where THIS switch is used
                            {                                   
                                execute_EE_line(j, 1);                                    
                            };
                            
                        };
                     }
                     
                };
                
                if(switches_state[i] ==2 )//&& switches_double_click[i] <4) //when only "rising edge" occurs
                {
                    
                    { 
                        char j=1;
                        for (j=1; j<=(settings[0]); j++) // for every "settings" line
                        {
                            if(eeprom_read_byte(16*j+3) ==i) // Look in all "settings" lines where THIS switch is used
                            {                                   
                                execute_EE_line(j, 1);                                     
                            };
                            
                        };
                     }
                     
                };                      
            };
        }    
}

void relays_event_check()
{
        { 
            char i=0;
            for (i=0; i<16; i++)    // for every relay
            {
                if(relays_state[i] ==1 )//when only "falling edge" occurs
                {
                    { 
                        char j=1;
                        for (j=1; j<=(settings[0]); j++) // for every "settings" line
                        {
                            if(eeprom_read_byte(16*j+4) ==i) // Look in all "settings" lines where THIS switch is used
                            {
                                execute_EE_line(j, 0);                                     
                            };
                            
                        };
                     }                
                };
                
                if(relays_state[i] ==2 )//when only "rising edge" occurs
                {

                    { 
                        char j=1;
                        for (j=1; j<=(settings[0]); j++) // for every "settings" line
                        {
                            if(eeprom_read_byte(16*j+5) ==i) // Look in all "settings" lines where THIS switch is used
                            {                                   
                                 execute_EE_line(j, 0);                                     
                            };
                            
                        };
                     }                
                };                            
            }; 
        }
}


void time_check()
{
    if(sec==0)
    {
        if(preventing_multiple_inversions==0)
        {
            preventing_multiple_inversions = 1; 
            {
                char j=1;
                for (j=1; j<=(settings[0]); j++) // for every "settings" line
                {
                    if(eeprom_read_byte(16*j+7) ==hour) 
                    {
                        if(eeprom_read_byte(16*j+8) ==minute)
                        {
                             execute_EE_line(j, 0);                            
                        };    
                    };
                }; 
            };
                
        };                
    }
    else
    {
        preventing_multiple_inversions=0;
    };
                                         
             

}

void timers_event_check()
{
    int i;
    for (i = 0; i < 16; i++)
    {
        if (timers[i] == 65535)
        {
            timers[i] = 0;
            switch_relay_off(i);
        }
    }
}

void rs485_transmit_first_byte()
{
    RS_485_direction = 1;
    output_buffer_counter = 0;
    UDR = output_buffer[output_buffer_counter];
    output_buffer_counter++;
    
}



const int FUNC_WRITE_EEPROM = 1;
const int FUNC_READ_EEPROM = 2;
const int FUNC_READ_SWITCHES_STATE = 3;
const int FUNC_SET_DISPLAY = 4;
const int FUNC_RELAY_ON = 5;
const int FUNC_RELAY_OFF = 6;

void rs485_half_response()
{
    
    output_buffer[0] = input_buffer[1]; // Dest Address
    output_buffer[1] = input_buffer[0]; // Src Address                
    output_buffer[2] = input_buffer[2]; // Function
    output_buffer[3] = input_buffer[3]; // SubAddress0
    output_buffer[4] = input_buffer[4]; // SubAddress1
    // 5 - 24 MUST BE FILLED BEFORE
    output_buffer[23] = calculate_crc(output_buffer);
    rs485_transmit_first_byte();
}


void rs485_write_eeprom(unsigned char line_index, unsigned char * data)
{
    char i;
    for (i = 0; i < 16; i++)
    {
        eeprom_write_byte(line_index * 16 + i, data[i]);
    }
    
    for (i = 5; i < FRAME_SIZE - 1; i++)
    {
        output_buffer[i] = input_buffer[i];
    }
}

void rs485_read_eeprom(unsigned char line_index)
{
    char i;
    for (i = 0; i < 16; i++)
    {
        output_buffer[5 + i] = eeprom_read_byte(line_index * 16 + i);
    }
}

void rs485_read_swithes_state()
{
    output_buffer[5] = reg_165_1;
    output_buffer[6] = reg_165_2;
    output_buffer[7] = reg_165_3;
    output_buffer[8] = relays_16 & 0xFF;
    output_buffer[9] = relays_16 >> 8;
}

void rs485_frame_process()
{
    unsigned char function = input_buffer[2];
    unsigned char subaddress_0 = input_buffer[3];
    unsigned char subaddress_1 = input_buffer[4];
    unsigned char * data = input_buffer + 5;
    
    if (frame_received)
    {
        frame_received = 0;
        
        switch(function)
        {
            case FUNC_WRITE_EEPROM:
                // rs485_write_eeprom(subaddress_0, data);
            break;
            case FUNC_READ_EEPROM:
                rs485_read_eeprom(subaddress_0);
            break;        
            case FUNC_READ_SWITCHES_STATE:
                rs485_read_swithes_state();
            break;
            case FUNC_SET_DISPLAY:
                display_overridden_flag =  data[0];
                display_overridden[0] = data[1]; 
                display_overridden[1] = data[2]; 
                display_overridden[2] = data[3]; 
                display_overridden[3] = data[4];
                
                output_buffer[5] = 0x0;
                break;
            case FUNC_RELAY_ON:
                switch_relay_on(data[0], 255);
                break;
            case FUNC_RELAY_OFF:
                switch_relay_off(data[0]);
                break;                 
            default:
            {
                output_buffer[5] = 0x31;
                output_buffer[6] = 0x32;
                output_buffer[7] = 0x33;
            }
            break;
        }

        // Send answer
        rs485_half_response();
    }
}

