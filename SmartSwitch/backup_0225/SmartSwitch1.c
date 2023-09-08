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
        
}

void rattle_supression()
{
        { 
            char i=0;
            for (i=0; i<8; i++)
            { 
                if(reg_165_1 & (1 << i))
                {
                    if(switches_rattle_supression[7-i] < rattle_supression_value)
                    {
                        switches_rattle_supression[7-i]++;
                    };
                }
                else
                {
                    if(switches_rattle_supression[7-i] > 0)
                    {
                        switches_rattle_supression[7-i]--;
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
                    if(switches_rattle_supression[15-i] < rattle_supression_value)
                    {
                        switches_rattle_supression[15-i]++;
                    };
                }
                else
                {
                    if(switches_rattle_supression[15-i] > 0)
                    {
                        switches_rattle_supression[15-i]--;
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
                    if(switches_rattle_supression[23-i] < rattle_supression_value)
                    {
                        switches_rattle_supression[23-i]++;
                    };
                }
                else
                {
                    if(switches_rattle_supression[23-i] > 0)
                    {
                        switches_rattle_supression[23-i]--;
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

                if(switches_rattle_supression[i] == rattle_supression_value)
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
                Changing "rattle_supression_value" affects counter speed.  
                User shall make double click faster than double_click_counter empties.  
                */
                
                    if(switches_old_state[i] == rattle_supression_value)
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

                    switches_old_state[i] = switches_rattle_supression[i]; 
                    
                };
                if(switches_rattle_supression[i] == 0)
                {                        

                    if(switches_old_state[i] == 0)
                    {
                        // nothing was changed
                        switches_state[i] = 0;
                    }; 
                    if(switches_old_state[i] == rattle_supression_value)
                    {
                        // this is falling edge
                        switches_state[i] = 1;
                        switches_double_click[i]++;
                        if(double_click_counter[i] ==0 )
                        {                        
                            double_click_counter[i] = double_click_counter_value;
                        };
                    };
                    
                    switches_old_state[i] = switches_rattle_supression[i];                        
                
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
                                if(eeprom_read_byte(16*j+1) ==1) //see if turning relay on is needed
                                {
                                    relays_16 = relays_16 | (1<<eeprom_read_byte(16*j)); //Turn the relay on
                                };
                                if(eeprom_read_byte(16*j+1) ==0) //see if turning relay off is needed
                                {
                                    relays_16 = relays_16 & ~(1<<eeprom_read_byte(16*j)); //Switch the relay off
                                };                                     
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
                                if(eeprom_read_byte(16*j+1) ==1) //see if turning relay on is needed
                                {
                                    relays_16 = relays_16 | (1<<eeprom_read_byte(16*j)); //Turn the relay on
                                };
                                if(eeprom_read_byte(16*j+1) ==0) //see if turning relay off is needed
                                {
                                    relays_16 = relays_16 & ~(1<<eeprom_read_byte(16*j)); //Switch the relay off
                                };                                     
                            };
                            
                        };
                     }
                     
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