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
