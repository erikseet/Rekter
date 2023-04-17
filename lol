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
