void buttons()
{
        if(Buttons !=0 && Keyboard_inactive==0)
        {

            Back_to_main_menu_counter = Back_to_main_menu_value;
            
            if(Buttons_debouncing_counter < Buttons_debouncing_value)
            {
                Buttons_debouncing_counter++;
            }
            else
            {
                Keyboard_inactive = Keyboard_inactive_value;
            
                if(Buttons==16)
                {
                    if(menu < max_menu_value)
                    {
                        menu++;
                        //Keyboard_inactive = Keyboard_inactive_value;
                    }
                    else
                    {
                        menu=0;
                        //Keyboard_inactive = Keyboard_inactive_value;
                    };
                };
                if(menu==1)
                {
                    switch (Buttons) 
                    {
                        case 1: hour = hour+10;
                                if(hour>23)
                                {
                                    hour=0;
                                };
                        break;
                        case 2: hour++;
                                if(hour>23)
                                {
                                    hour=0;
                                };                        
                        break;
                        case 4: minute = minute+10;
                                if(minute>59)
                                {
                                    minute=0;
                                };                        
                        break;
                        case 8: minute++;
                                if(minute>59)
                                {
                                    minute=0;
                                };                        
                        break; 
                        case 12: sec=0;
                        break;                         
                                                            
                    };
                    
                i2c_start();
                i2c_write(0xd0);
                i2c_write(0);
                i2c_write(bin2bcd(sec));
                i2c_write(bin2bcd(minute));
                i2c_write(bin2bcd(hour));
                i2c_write(bin2bcd(day));
                i2c_write(bin2bcd(date));
                i2c_write(bin2bcd(month));
                i2c_write(bin2bcd(year));
                i2c_write(bin2bcd(calibration));
                i2c_write(bin2bcd(year_thousands));                                                     
                i2c_stop();                      

                };             
            };
            
                           
        }
        else
        {
            if(Buttons_debouncing_counter >0)
            {
                Buttons_debouncing_counter--;
            };
        };
}