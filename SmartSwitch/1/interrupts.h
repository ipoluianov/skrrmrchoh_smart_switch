// Timer1 output compare A interrupt service routine
// once in 5 ms
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
seconds_blinking_counter++;
if(seconds_blinking_counter>199)
{
    seconds_blinking_counter =0;
}; 

       
        DDRD  = 0x06;  //PORT as INPUT 
        PORTD = 0b11111000;
        Buttons = PIND;
        Buttons = Buttons>>3;
        Buttons = 0xFF-Buttons;        
        Buttons = Buttons & 0b00011111;
        
        DDRD  = 0xFE;
        PORTD = PORTD | 0b11111000;
        TMP_LED = LEDs;
        TMP_LED  = 0xFF - TMP_LED; 
        TMP_LED  = TMP_LED<<3;
        PORTD = PORTD & TMP_LED;        

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