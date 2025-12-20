void indication ()
{
    // Display Overriding 
    if (display_overridden_flag)
    {
        digit_1 = display_overridden[0];
        digit_2 = display_overridden[1];
        digit_3 = display_overridden[2];
        digit_4 = display_overridden[3];
        return;
    }
        LEDs = menu;
        switch (menu) 
        {
            case 0: 
                if(switching_relay_off_prohibited == 0 && OFF_timer==0)
                {                    
                    //Show relays' status
                    if(error==0)
                    {
                        digit_1 = relay_low & 0x0F;
                        digit_2 = relay_low >>4;
                        digit_3 = relay_high & 0x0F;
                        digit_4 = relay_high >>4;
                        seconds_blinking=0;
                    }
                    else
                    {
                        if(error_blinking_counter>199)
                        {
                            digit_1 = relay_low & 0x0F;
                            digit_2 = relay_low >>4;
                            digit_3 = relay_high & 0x0F;
                            digit_4 = relay_high >>4;
                            seconds_blinking=0;                        
                        }
                        else
                        {
                            digit_1 = 18;
                            digit_2 = 19;
                            digit_3 = error/10;
                            digit_4 = error-digit_3*10;
                            seconds_blinking=0;                        
                        };
                    };
                };
                if(switching_relay_off_prohibited == 1 && OFF_timer==0)
                {
                    //Show SWITCH_OFF_Prohibition timer value with "P" letter
                    TMP_1_16_bit = switching_relay_off_prohibited_counter/200;
                    seconds_blinking=0;
                    digit_1 = 20;
                    digit_2 = (TMP_1_16_bit)/100;
                    digit_3 = (TMP_1_16_bit -digit_2*100)/10;
                    digit_4 = (TMP_1_16_bit -digit_2*100-digit_3*10); 
                    
                    if((seconds_blinking_counter<50) || (seconds_blinking_counter>99 && seconds_blinking_counter<150))
                    {
                        LEDs=2;
                    };

                                   
                };
                if(OFF_timer>0)
                {
                    //Show SWITCH_OFF_Prohibition timer value with "P" letter
                    TMP_1_16_bit = OFF_timer/200;
                    seconds_blinking=0;
                    digit_1 = 21;
                    digit_2 = (TMP_1_16_bit)/100;
                    digit_3 = (TMP_1_16_bit -digit_2*100)/10;
                    digit_4 = (TMP_1_16_bit -digit_2*100-digit_3*10); 
                    
                    if((seconds_blinking_counter<50) || (seconds_blinking_counter>99 && seconds_blinking_counter<150))
                    {
                        LEDs=4;
                    };

                                   
                };                                                             
            break;
            case 1: 
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_1 >>4;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }
                    
                    digit_1 = TMP_1_16_bit;
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_1 & 0x0F;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }                    
                    digit_2 = TMP_1_16_bit;
                    digit_3 = 17;
                    digit_4 = 17;
                    seconds_blinking=0;             
            break; 
            case 2:
                    digit_1 = 17;
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_2 >>4;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }
                    
                    digit_2 = TMP_1_16_bit;
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_2 & 0x0F;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }                    
                    digit_3 = TMP_1_16_bit;
                    digit_4 = 17;
                    seconds_blinking=0;             
            break; 
            case 3:
                    digit_1 = 17;
                    digit_2 = 17;
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_3 >>4;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }
                    
                    digit_3 = TMP_1_16_bit;
                    {
                        int i=0;
                        TMP_2_16_bit = reg_165_3 & 0x0F;
                        TMP_1_16_bit = 0;
                        for (i=0;i<4;i++)
                        {
                            if(TMP_2_16_bit & 0b00001000)
                            {
                                TMP_1_16_bit = TMP_1_16_bit | 1<<i;    
                            };
                            TMP_2_16_bit = TMP_2_16_bit<<1;
                        };
                    }                    
                    digit_4 = TMP_1_16_bit;
                    seconds_blinking=0;             
            break;                                    
            case 4:
                    TMP_1_16_bit = hour*100+minute;
                    seconds_blinking=1;
                    digit_1 = (TMP_1_16_bit )/1000;
                    digit_2 = (TMP_1_16_bit -digit_1*1000 )/100;
                    digit_3 = (TMP_1_16_bit -digit_1*1000 -digit_2*100)/10;
                    digit_4 = (TMP_1_16_bit -digit_1*1000 -digit_2*100-digit_3*10);            
            break; 
            case 5:
                    TMP_1_16_bit = sec;
                    seconds_blinking=1;
                    digit_1 = 17;
                    digit_2 = 17;
                    digit_3 = (TMP_1_16_bit)/10;
                    digit_4 = (TMP_1_16_bit - digit_3*10);            
            break;   
                     
            
             

            default:
                    digit_1 = 17;
                    digit_2 = 17;
                    digit_3 = 17;
                    digit_4 = 17;
                    seconds_blinking=0;                                     
        };
        
        

  
}