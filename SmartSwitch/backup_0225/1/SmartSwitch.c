/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : SmartSwitch
Version : 1
Date    : 10/18/2022
Author  : Skrrmrchoh
Company : 
Comments: 
Skrrmrchoh@rambler.ru


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/
#define Anode_3 PORTC.4
#define Anode_4 PORTC.6
#define Anode_1 PORTC.3
#define Anode_2 PORTC.5
#define Relay_reset PORTB.4 // 0-Reset; 1-work 

#define Reg_165_CLK_INH PORTB.1 
#define Reg_165_CLK PORTB.2 
#define Reg_165_n_LOAD PORTB.3 
#define Reg_165_OUT PINB.0 

#define indicator_dp PORTA.1 

#define rattle_supression_value 15
#define double_click_counter_value 400


#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm

eeprom char settings[16];
/*
Relay_number - action - 
falling edge on switch #... - rising edge on switch #... -
falling edge on relay #... - rising edge on relay #... -
double click on switch #... - 
time, hours - time, minutes.

*/

eeprom char settings_line_1[16];
eeprom char settings_line_2[16];
eeprom char settings_line_3[16];
eeprom char settings_line_4[16];
eeprom char settings_line_5[16];
eeprom char settings_line_6[16];
eeprom char settings_line_7[16];
eeprom char settings_line_8[16];
eeprom char settings_line_9[16];
eeprom char settings_line_10[16];
eeprom char settings_line_11[16];
eeprom char settings_line_12[16];
eeprom char settings_line_13[16];
eeprom char settings_line_14[16];

unsigned char interrupt_counter=0;
unsigned char digit_1=0, digit_2=1, digit_3=2, digit_4=3;
unsigned char Buttons=0; // 16, 1, 2, 4, 8
unsigned char LEDs=0; // 16, 1, 2, 4, 8

bit seconds_blinking = 0;
unsigned char seconds_blinking_counter=0;

unsigned char TMP_LED=0, TMP_8_bit=0, TMP_1_8_bit=0;
unsigned char relay_high=0, relay_low=0;
unsigned int TMP_1_16_bit=0, TMP_2_16_bit=0;
unsigned int TMP_relay_16_bit=0;
unsigned char reg_165_1=0, reg_165_2=0, reg_165_3=0;

unsigned char sec=0, minute=0, hour=0; 
unsigned char day=0, date=31, month=12, year=95, year_thousands=19;
unsigned char calibration=0;

unsigned char switches_rattle_supression[24];
unsigned char switches_state[24], switches_old_state[24];
unsigned char relays_state[16];
unsigned char switches_double_click[24];
unsigned int double_click_counter[24];

unsigned int relays_16=0, relays_16_oldstate;

unsigned int TMP_counter=0;

/*
 80_
10/_/40 20
04/_/01
  08 .02
*/  
flash char symbols[] =      
{
0x22,                   //0
0xBE,                   //1
0x13,                   //2
0x16,                   //3
0x8E,                   //4
0x46,                   //5
0x42,                   //6
0x3E,                   //7
0x02,                   //8
0x06,                   //9
0xFF,                   //Space 
0xDF                    // -                  

};


#include <mega32a.h>
#include <eeprom.h>
#include <bcd.h> 
#include <i2c.h>
#include <stdio.h>
#include <spi.h>
#include <interrupts.h>
#include <delay.h>
#include <functions.h>
#include <registers.h>



void main(void)
{
registers();
Relay_reset=1;

while (1)
      {                

        
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
        

        
        get_165_reg();
        rattle_supression();
        edge_detection();
        
        relays_16_oldstate = relays_16;  
        switches_event_check();
                           
        relays_edge_detection();
        relays_event_check();

        relays_edge_detection();
        relays_event_check();
        /*
        Call functions relays_"edge_detection" and "relays_event_check" twice or more times
        is nesessary because of possible nesting of user settings. Here's an example:
        Switch #0 turns on relay #1.
        Turning on relay #1 turns on relay #15. That situation is OK.
        Then, user can program that turning on relay #15 turns on relay #8. If you call
        the functions once, events will be as following:
        Assume that all relays turned off;
        "edge detection" detects edge on SW0;
        relays_16_oldstate = 0;
        "switches_event_check" turns relay #1 on;
        "relays_edge_detection" detects that relay #1 is on , which
        turns relay #15 by "relays_event_check". Now "relays_16" contains turned on 
        relays 1 and 15. At the next iteration of "while" cycle
        assigning "relays_16_oldstate = relays_16;" will be executes, and we won't be having
        change on relay #15, so system won't turn on relay #8 as programmed.
        Calling mentioned functions twice, or 3 times solves the issue.
        */
        
               
        //TMP_1_16_bit = hour*100+minute;

        
        if (relays_state[1] !=0)
        {
            TMP_1_16_bit = relays_state[1];
            TMP_counter=200;
        };
   
        digit_1 = (TMP_1_16_bit )/1000;
        digit_2 = (TMP_1_16_bit -digit_1*1000 )/100;
        digit_3 = (TMP_1_16_bit -digit_1*1000 -digit_2*100)/10;
        digit_4 = (TMP_1_16_bit -digit_1*1000 -digit_2*100-digit_3*10);
        

        if(TMP_counter>0)
        {
            TMP_counter--;
        }
        else
        {
            TMP_1_16_bit = relays_state[1];
        };
        
        
        relay_high=relays_16 / 255;
        TMP_relay_16_bit = relay_high * 256;
        relay_low =relays_16 - TMP_relay_16_bit;
        spi(relay_low); 
        spi(relay_high);
        
              
        


        

        
                    
      }
}
