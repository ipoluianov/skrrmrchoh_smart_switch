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
#define RS_485_direction PORTD.2

#define contact_bounce_supression_value 15
#define Buttons_debouncing_value 5
#define double_click_counter_value 400
#define max_menu_value 10
#define Keyboard_inactive_value 20
#define Back_to_main_menu_value 2000
#define sec_error_counter_value 255
#define switching_relay_off_prohibited_counter_value 20000

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

#define FRAME_SIZE 24

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
eeprom char settings_line_15[16];
eeprom char settings_line_16[16];
eeprom char settings_line_17[16];
eeprom char settings_line_18[16];
eeprom char settings_line_19[16];
eeprom char settings_line_20[16];
eeprom char settings_line_21[16];
eeprom char settings_line_22[16];
eeprom char settings_line_23[16];
eeprom char settings_line_24[16];
eeprom char settings_line_25[16];
eeprom char settings_line_26[16];
eeprom char settings_line_27[16];
eeprom char settings_line_28[16];
eeprom char settings_line_29[16];
eeprom char settings_line_30[16];
eeprom char settings_line_31[16];
eeprom char settings_line_32[16];


unsigned char interrupt_counter=0;
unsigned char digit_1=0, digit_2=1, digit_3=2, digit_4=3;
unsigned char Buttons=0; // 16, 1, 2, 4, 8
unsigned char LEDs=0; // 16, 1, 2, 4, 8

bit seconds_blinking = 0;
unsigned char seconds_blinking_counter=0;


unsigned char TMP_LED=0, TMP_8_bit=0, TMP_1_8_bit=0;
unsigned char relay_high=0, relay_low=0;
unsigned int TMP_1_16_bit=0, TMP_2_16_bit=0;
// unsigned int TMP_relay_16_bit=0;
unsigned char reg_165_1=0, reg_165_2=0, reg_165_3=0;

unsigned char sec=0, minute=0, hour=0, sec_oldstate=0; 
unsigned char day=0, date=31, month=12, year=95, year_thousands=19;
unsigned char calibration=0;

unsigned char switches_contact_bounce_supression[24];
unsigned char switches_state[24], switches_old_state[24];
unsigned char relays_state[16];
unsigned char switches_double_click[24];
unsigned int timers[16];
unsigned int double_click_counter[24];

unsigned int relays_16=0, relays_16_oldstate;

unsigned int to_second_counter=0;
unsigned char rs485_timeout_counter = 0;
unsigned char rs485_addr = 6;

// unsigned int TMP_counter=0;

unsigned char menu=6;// must be <16
unsigned char Buttons_debouncing_counter=0, Keyboard_inactive=0;
unsigned int Back_to_main_menu_counter=0;
unsigned int error_blinking_counter=0;
unsigned char error=0; //must be <99
//error bit 0 - RTC error
unsigned char sec_error_counter=0;
bit switching_relay_off_prohibited=0;
unsigned int switching_relay_off_prohibited_counter=0;
unsigned int OFF_timer=0;   // see "settings[2]" in "registers.h" and "buttons_functions.h"
bit preventing_multiple_inversions=0;

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
0x0A,                   //A 
0xC2,                   //B 
0x63,                   //C 
0x92,                   //D 
0x43,                   //E 
0x4B,                   //F
0xFF,                   //Space 
0xDF,                   // -  
0x43,                   // E 
0xDB,                   // r                  
0x0B,                   // P
0xC3                    //t 
};


#include <mega32a.h>
#include <eeprom.h>
#include <bcd.h> 
#include <i2c.h>
#include <stdio.h>
#include <spi.h>
#include <rs485_functions.h>
#include <interrupts.h>
#include <delay.h>
#include <functions.h>
#include <registers.h>
#include <buttons_functions.h>
#include <indication.h>




void main(void)
{
registers();
Relay_reset=1;

RS_485_direction = 0;



while (1)
      { 
        rs485_frame_process();
        //delay_us(10); 
        //UDR = 42;              

        
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
        
        if(sec != sec_oldstate)// no time error situation
        {
            sec_error_counter = sec_error_counter_value;
        };
        
        sec_oldstate = sec;
        
        get_165_reg();
        contact_bounce_supression();
        edge_detection();
        
        relays_16_oldstate = relays_16;  
        switches_event_check();
        time_check();
                   
        relays_edge_detection();
        relays_event_check();

        timers_event_check();
        
        
        buttons_functions();
        if(error>99)
        {
            error=99;
        };
        indication();        
        
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


                
        if(OFF_timer>0 && OFF_timer<30)
        {
            relays_16_oldstate = 0;
            relays_16 = 0;
        };
        
        relay_high = relays_16 >> 8;
        relay_low = relays_16 & 0xFF;
        spi(relay_low); 
        spi(relay_high);        
      }
}
