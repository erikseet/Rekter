#include <mbed.h>
#include "i2c-lib.h"
#include "si4735-lib.h"

#define SI4735_ADDRESS 0x22
#define R    0b00000001
#define W    0b00000000

DigitalIn button1(PTC10);
DigitalIn button2(PTC11);
DigitalIn button3(PTC12);

int volume = 10;
int signal_quality_limit = 2;
bool button1_pressed = false;
bool button2_pressed = false;
bool button3_pressed = false;

void changeVolume(int volume){
    uint8_t ack = 0;
    pc.printf( "\nVOLUME %d\r\n", volume);
    I2C_Start();
    ack |= I2C_Output(SI4735_ADDRESS | W);
    ack |= I2C_Output(0x12);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(0x40);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(volume);
    I2C_Stop();
}

void autoTuning(){
    uint8_t ack = 0;
    I2C_Start();
    ack |= I2C_Output(SI4735_ADDRESS | W);
    ack |= I2C_Output(0x21);
    ack |= I2C_Output(0b00000000 | signal_quality_limit<<4);
    I2C_Stop();
}

void onButton1Pressed(){
    volume--;
    if(volume < 0) volume = 0;
    changeVolume(volume);
}

void onButton2Pressed(){
    volume++;
    if(volume > 63) volume = 63;
    changeVolume(volume);
}

void onButton3Pressed(){
    autoTuning();
}

void onTick(){
    if(button1.read() == 0){
        if(!button1_pressed){
            onButton1Pressed();
            button1_pressed = true;
        }
    }
    else{
        button1_pressed = false;
    }

    if(button2.read() == 0){
        if(!button2_pressed){
            onButton2Pressed();
            button2_pressed = true;
        }
    }
    else{
        button2_pressed = false;
    }

    if(button3.read() == 0){
        if(!button3_pressed){
            onButton3Pressed();
            button3_pressed = true;
        }
    }
    else{
        button3_pressed = false;
    }
}

int main(){
    Ticker ticker;
    i2c_init();
    si4735_init();

    ticker.attach(&onTick, 0.1);

    while(1){
        // do something else
    }
}











#include <mbed.h>
#include "i2c-lib.h"
#include "si4735-lib.h"

#define SI4735_ADDRESS 0x22
#define R    0b00000001
#define W    0b00000000

DigitalIn button1(PTC10);
DigitalIn button2(PTC11);
DigitalIn button3(PTC12);
DigitalIn button4(PTC9);

AnalogIn signal_quality(PTB0);

int volume = 10;
int signal_quality_limit = 2;
bool button1_pressed = false;
bool button2_pressed = false;
bool button3_pressed = false;
bool button4_pressed = false;

int mode = 1;
const int num_modes = 2;

int led[] = {
    0b00000001,
    0b00000011,
    0b00000111,
    0b00001111,
    0b00011111,
    0b00111111,
    0b01111111,
    0b11111111};

void changeVolume(int volume){
    uint8_t ack = 0;
    I2C_Start();
    ack |= I2C_Output(SI4735_ADDRESS | W);
    ack |= I2C_Output(0x12);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(0x40);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(0x00);
    ack |= I2C_Output(volume);
    I2C_Stop();
}

void autoTuning(){
    uint8_t ack = 0;
    I2C_Start();
    ack |= I2C_Output(SI4735_ADDRESS | W);
    ack |= I2C_Output(0x21);
    ack |= I2C_Output(0b00000000 | signal_quality_limit<<4);
    I2C_Stop();
}

void modeSwitch(){
    mode++;
    if(mode > num_modes) mode = 1;
}

void onTick(){
    if(mode == 1){
        if(button1.read() == 0){
            if(!button1_pressed){
                volume--;
                if(volume < 0) volume = 0;
                changeVolume(volume);
                button1_pressed = true;
            }
        }
        else{
            button1_pressed = false;
        }

        if(button2.read() == 0){
            if(!button2_pressed){
                volume++;
                if(volume > 63) volume = 63;
                changeVolume(volume);
                button2_pressed = true;
            }
        }
        else{
            button2_pressed = false;
        }

        if(button3.read() == 0){
            if(!button3_pressed){
                autoTuning();
                button3_pressed = true;
            }
        }
        else{
            button3_pressed = false;
        }

        if(button4.read() == 0){
            if(!button4_pressed){
                modeSwitch();
                button4_pressed = true;
            }
        }
        else{
            button4_pressed = false;
        }
    } else if(mode == 2){
        bool button1_pressed_mode2 = false;
        bool button2_pressed_mode2 = false;

        if(button1.read() == 0){
            if(!button1_pressed_mode2){
                uint8_t ack = 0;
                I2C_Start();
                ack |= I2C_Output(SI4735_ADDRESS | W);
                ack |= I2C_Output(0x20);
 ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x10);
                I2C_Stop();
                button1_pressed_mode2 = true;
            }
        }
        else{
            button1_pressed_mode2 = false;
        }

        if(button2.read() == 0){
            if(!button2_pressed_mode2){
                uint8_t ack = 0;
                I2C_Start();
                ack |= I2C_Output(SI4735_ADDRESS | W);
                ack |= I2C_Output(0x20);
                ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x00);
                ack |= I2C_Output(0x00);
                I2C_Stop();
                button2_pressed_mode2 = true;
            }
        }
        else{
            button2_pressed_mode2 = false;
        }

        // Update LED bar based on signal quality
        int signal_quality_value = signal_quality.read_u16() / 6553; // scale to 0-10
        int num_leds = (signal_quality_value * 8) / 10;
        if(num_leds > 8) num_leds = 8;
        if(num_leds < 0) num_leds = 0;

        int led_value = led[num_leds];
        pc.printf("LED Value: %d\r\n", led_value);
        // Send LED value to LED driver
        uint8_t ack = 0;
        I2C_Start();
        ack |= I2C_Output(0xC0);
        ack |= I2C_Output(0x00);
        ack |= I2C_Output(0x00);
        ack |= I2C_Output(led_value);
        I2C_Stop();

        if(button4.read() == 0){
            if(!button4_pressed){
                modeSwitch();
                button4_pressed = true;
            }
        }
        else{
            button4_pressed = false;
        }
    }
}

int main(){
    Ticker ticker;
    i2c_init();
    si4735_init();

    ticker.attach(&onTick, 0.1);

    while(1){
        // do something else
    }
}



// **************************************************************************
//
//               Demo program for APPS labs
//
// Subject:      Computer Architectures and Parallel systems
// Author:       Petr Olivka, petr.olivka@vsb.cz, 02/2022
// Organization: Department of Computer Science, FEECS,
//               VSB-Technical University of Ostrava, CZ
//
// File:         Main program for I2C bus
//
// **************************************************************************

#include <mbed.h>
#include <iostream>

#include "i2c-lib.h"
#include "si4735-lib.h"

//************************************************************************

// Direction of I2C communication
#define R	0b00000001
#define W	0b00000000

#define HWADR_PCF8574 0x40
#define A012 0

uint8_t l_S1, l_S2, l_RSSI, l_SNR, l_MULT, l_CAP;
uint8_t l_ack = 0;

#pragma GCC diagnostic ignored "-Wunused-but-set-variable"

DigitalOut g_led_PTA1( PTA1, 0 );
DigitalOut g_led_PTA2( PTA2, 0 );

DigitalIn g_but_PTC9( PTC9 );
DigitalIn g_but_PTC10( PTC10 );
DigitalIn g_but_PTC11( PTC11 );
DigitalIn g_but_PTC12( PTC12 );

int b_PTC9 = 1;
int b_PTC10 = 1;
int b_PTC11 = 1;
int b_PTC12 = 1;
int b_PTC12_timer = 0;

int mode = 1;
int freq = 10140;
int volume = 30;
int led = 0b00000001;

int stations [8] = {10140};
int ind = 0;

void mode_func () {
	if (g_but_PTC9 == 0) {
		if (b_PTC9 == 1) {
			mode++;
			if (mode == 5) {
				mode = 1;
			}
			g_led_PTA1 = 0;
			g_led_PTA2 = 0;
			b_PTC9 = 0;
		}
	} else {
		b_PTC9 = 1;
	}

	if (mode == 2 || mode == 4) {
		g_led_PTA1 = 1;
	}

	if (mode == 3 || mode == 4) {
		g_led_PTA2 = 1;
	}
}

void basic () {
	if (mode == 1) {
		if (g_but_PTC10 == 0) {
			if (b_PTC10 == 1) {
				volume--;
				if (volume == 0) {
					volume = 63;
				}

				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W );
				l_ack |= i2c_output(0x12);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(0x40);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(volume);
				i2c_stop();

				printf ("Volume changed, new volume = %d\n", volume);

				b_PTC10 = 0;
			}
		} else {
			b_PTC10 = 1;
		}

		if (g_but_PTC11 == 0) {
			if (b_PTC11 == 1) {
				volume++;
				if (volume == 63) {
					volume = 1;
				}

				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W );
				l_ack |= i2c_output(0x12);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(0x40);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(0x00);
				l_ack |= i2c_output(volume);
				i2c_stop();

				printf ("Volume changed, new volume = %d\n", volume);

				b_PTC11 = 0;
			}
		} else {
			b_PTC11 = 1;
		}

		if (g_but_PTC12 == 0) {
			while (g_but_PTC12 == 0) {
				b_PTC12_timer += 1;
			}

			if (b_PTC12 == 1 && b_PTC12_timer < 50000) {

				i2c_start();
				l_ack |= i2c_output (SI4735_ADDRESS | W );
				l_ack |= i2c_output (0x21);
				l_ack |= i2c_output (0b00001100);
				i2c_stop();

				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W );
				l_ack |= i2c_output( 0x22 );			// FM_TUNE_STATUS
				l_ack |= i2c_output( 0x00 );			// ARG1
				// repeated start
				i2c_start();
				// change direction of communication
				l_ack |= i2c_output( SI4735_ADDRESS | R );
				// read data
				l_S1 = i2c_input();
				i2c_ack();
				l_S2 = i2c_input();
				i2c_ack();
				freq = ( uint32_t ) i2c_input() << 8;
				i2c_ack();
				freq |= i2c_input();
				i2c_ack();
				l_RSSI = i2c_input();
				i2c_ack();
				l_SNR = i2c_input();
				i2c_ack();
				l_MULT = i2c_input();
				i2c_ack();
				l_CAP = i2c_input();
				i2c_nack();
				i2c_stop();

				if ( l_ack != 0 )
					printf( "Communication error!\r\n" );
				else
					printf( "Tuned frequency: %d.%dMHz\r\n", freq / 100, freq % 100 );

				b_PTC12 = 0;
			} else {
				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W);
				l_ack |= i2c_output( 0x20 );			// FM_TUNE_FREQ
				l_ack |= i2c_output( 0x00 );			// ARG1
				l_ack |= i2c_output( stations [ind] >> 8 );		// ARG2 - FreqHi
				l_ack |= i2c_output( stations [ind] & 0xff );	// ARG3 - FreqLo
				l_ack |= i2c_output( 0x00 );			// ARG4
				i2c_stop();

				printf ("Tuned station from slot %d\n", ind);
			}

			b_PTC12_timer = 0;

		} else {
			b_PTC12 = 1;
		}
	}
}

void tune () {
	if (mode == 2) {
		if (g_but_PTC10 == 0) {
			if (b_PTC10 == 1) {

				freq -= 10;

				if (freq < 8750) {
					freq = 10800;
				}

				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W);
				l_ack |= i2c_output( 0x20 );			// FM_TUNE_FREQ
				l_ack |= i2c_output( 0x00 );			// ARG1
				l_ack |= i2c_output( freq >> 8 );		// ARG2 - FreqHi
				l_ack |= i2c_output( freq & 0xff );	// ARG3 - FreqLo
				l_ack |= i2c_output( 0x00 );			// ARG4
				i2c_stop();

				printf( "Frequency changed, Tuned frequency: %d.%dMHz\r\n", freq / 100, freq % 100 );

				b_PTC10 = 0;
			}
		} else {
			b_PTC10 = 1;
		}

		if (g_but_PTC11 == 0) {
			if (b_PTC11 == 1) {

				freq += 10;

				if (freq > 10800) {
					freq = 8750;
				}

				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W);
				l_ack |= i2c_output( 0x20 );			// FM_TUNE_FREQ
				l_ack |= i2c_output( 0x00 );			// ARG1
				l_ack |= i2c_output( freq >> 8 );		// ARG2 - FreqHi
				l_ack |= i2c_output( freq & 0xff );	// ARG3 - FreqLo
				l_ack |= i2c_output( 0x00 );			// ARG4
				i2c_stop();

				printf( "Frequency changed, Tuned frequency: %d.%dMHz\r\n", freq / 100, freq % 100 );

				b_PTC11 = 0;
			}

		} else {
			b_PTC11 = 1;
		}


				i2c_start();
				l_ack |= i2c_output( SI4735_ADDRESS | W );
				l_ack |= i2c_output( 0x22 );			// FM_TUNE_STATUS
				l_ack |= i2c_output( 0x00 );			// ARG1
				// repeated start
				i2c_start();
				// change direction of communication
				l_ack |= i2c_output( SI4735_ADDRESS | R );
				// read data
				l_S1 = i2c_input();
				i2c_ack();
				l_S2 = i2c_input();
				i2c_ack();
				freq = ( uint32_t ) i2c_input() << 8;
				i2c_ack();
				freq |= i2c_input();
				i2c_ack();
				l_RSSI = i2c_input();
				i2c_ack();
				l_SNR = i2c_input();
				i2c_ack();
				l_MULT = i2c_input();
				i2c_ack();
				l_CAP = i2c_input();
				i2c_nack();
				i2c_stop();

				if (l_RSSI < 3) {
					led = 0b00000001;
				} else if (l_RSSI < 5) {
					led = 0b00000011;
				} else if (l_RSSI < 10) {
					led = 0b00000111;
				} else if (l_RSSI < 20) {
					led = 0b00001111;
				} else {
					led = 0b00011111;
				}

				i2c_start();
				l_ack |= i2c_output( HWADR_PCF8574 | A012 | W );
				l_ack |= i2c_output( led );
				i2c_stop();
	}
}

void save () {
	if (mode == 3) {

		if (g_but_PTC11 == 0) {
			if (b_PTC11 == 1) {

				ind++;
				if (ind > 7) {
					ind = 0;
				}

				b_PTC11 = 0;
			}
		} else {
			b_PTC11 = 1;
		}


		if (g_but_PTC10 == 0) {
			if (b_PTC10 == 1) {
				stations [ind] = freq;
				printf ("Station saved to slot %d\n", ind);

				b_PTC10 = 0;
			}
		} else {
			b_PTC10 = 1;
		}

		led = 0b00000001;
		for (int i = 0; i < ind; i++) {
			led = led << 1;
		}

		i2c_start();
		l_ack |= i2c_output( HWADR_PCF8574 | A012 | W );
		l_ack |= i2c_output( led );
		i2c_stop();

	}
}


int main( void )
{
	printf( "K64F-KIT ready...\r\n" );

	i2c_init();

	if ( ( l_ack = si4735_init() ) != 0 )
	{
		printf( "Initialization of SI4735 finish with error (%d)\r\n", l_ack );
		return 1;
	}
	else
		printf( "SI4735 initialized.\r\n" );

	printf( "\nTunig of radio station...\r\n" );

	// Required frequency in MHz * 100

	// Tuning of radio station
	i2c_start();
	l_ack |= i2c_output( SI4735_ADDRESS | W);
	l_ack |= i2c_output( 0x20 );			// FM_TUNE_FREQ
	l_ack |= i2c_output( 0x00 );			// ARG1
	l_ack |= i2c_output( freq >> 8 );		// ARG2 - FreqHi
	l_ack |= i2c_output( freq & 0xff );	// ARG3 - FreqLo
	l_ack |= i2c_output( 0x00 );			// ARG4
	i2c_stop();
	// Check l_ack!
	// if...

	// Tuning process inside SI4735
	wait_us( 100000 );
	printf( "... station tuned.\r\n\n" );

	if ( l_ack != 0 )
		printf( "Communication error!\r\n" );
	else
		printf( "Tuned frequency: %d.%dMHz, volume: %d\n", freq / 100, freq % 100, volume );

	Ticker t1;
	t1.attach_us(callback (&mode_func), 100);

	Ticker t2;
	t2.attach_us(callback (&basic), 10000);

	Ticker t3;
	t3.attach_us(callback (&tune), 10000);

	Ticker t4;
	t4.attach_us(callback (&save), 10000);

	while(1);

	return 0;
}

