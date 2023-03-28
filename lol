#include "mbed.h"

#define WAIT_TIME_US 500000

DigitalOut led[] = {PTC0, PTC1, PTC2, PTC3, PTC4, PTC5, PTC7, PTC8};
int i = 0;
float intensity = 1.0;

bool kontra = false;
DigitalIn but0(PTC9);
DigitalIn but1(PTC10);
DigitalIn but2(PTC11);

int main()
{
    while (true)
    {
        if (but1 != 1 && but2 != 1) {
            led[i] = intensity;
            wait_us(WAIT_TIME_US);
        }
        else {
            led[i] = 1.0;
        }

        if (but0 != 1 && !kontra) {
            kontra = true;
            led[i] = 0;
            i++;

            if (i == 8) {
                i = 0;
            }

            intensity = 1.0;
            led[i] = intensity;
        }

        if (but0 == 1 && kontra) {
            kontra = false;
        }

        if (but1 == 0) {
            intensity -= 0.1;
            if (intensity < 0.0) {
                intensity = 1.0;
            }
            led[i] = intensity;
            wait_us(100000);
        }
    }
}








#include "mbed.h"

#define WAIT_TIME_US 500000

//DigitalOut led0( PTC0, 0 );

DigitalOut led[] = {(PTC0),(PTC1),(PTC2),(PTC3),(PTC4),(PTC5),(PTC7),(PTC8)};
int i = 0;

bool kontra = false;
DigitalIn but0( PTC9 );
DigitalIn but1( PTC10 );
DigitalIn but2( PTC11 );


int main()
{

    while (true)
    {



        if (but1 != 1 && but2 != 1){
            led[i] = !led[i];
            wait_us( WAIT_TIME_US );
        } else {
            led[i] = 1;
        }
        if (but0 != 1 && kontra == false){
            kontra = true;
            led[i] = 0;
            i++;
            if (i == 8)
                i = 0;
            led[i] = 1;
        }
        if (but0 == 1 && kontra == true)
            kontra = false;



        //wait_us( WAIT_TIME_US );
    }
}







#include "mbed.h"

#define WAIT_TIME_US 500000

DigitalOut led[] = {PTC0, PTC1, PTC2, PTC3, PTC4, PTC5, PTC7, PTC8};
int i = 0;

bool kontra = false;
DigitalIn but0(PTC9);
DigitalIn but1(PTC10);
DigitalIn but2(PTC11);

int main()
{
    while (true)
    {
        if (but1 != 1 && but2 != 1) {
            led[i] = !led[i];
            wait_us(WAIT_TIME_US);
        }
        else {
            led[i] = 1;
        }

        if (but0 != 1 && !kontra) {
            kontra = true;
            led[i] = 0;
            i++;

            if (i == 8) {
                i = 0;
            }

            led[i] = 1;
        }

        if (but0 == 1 && kontra) {
            kontra = false;
        }
    }
}




#include "mbed.h"

#define WAIT_TIME_US 500000

// Define an array of PWM objects for the LEDs
PwmOut led_pwm[] = {PTC0, PTC1, PTC2, PTC3, PTC4, PTC5, PTC7, PTC8};

int i = 0;

bool kontra = false;
DigitalIn but0(PTC9);
DigitalIn but1(PTC10);
DigitalIn but2(PTC11);

int main()
{
    while (true)
    {
        if (but1 != 1 && but2 != 1){
            // Decrease the intensity of the current LED using PWM
            for (float duty_cycle = 1.0f; duty_cycle >= 0.01f; duty_cycle -= 0.01f) {
                led_pwm[i].write(duty_cycle);
                wait_us(WAIT_TIME_US / 100);
            }
            // Set the intensity of the current LED back to full using PWM
            led_pwm[i].write(1.0f);
        } else {
            // Turn on the current LED at full intensity using PWM
            led_pwm[i].write(1.0f);
        }

        if (but0 != 1 && kontra == false){
            kontra = true;
            led_pwm[i].write(0.0f);
            i++;
            if (i == 8)
                i = 0;
            led_pwm[i].write(1.0f);
        }

        if (but0 == 1 && kontra == true)
            kontra = false;

        wait_us(WAIT_TIME_US);
    }
}

#include "mbed.h"

#define WAIT_TIME_US 500000

PwmOut led[] = {PTC0, PTC1, PTC2, PTC3, PTC4, PTC5, PTC7, PTC8};
int i = 0;
float intensity = 1.0;

bool kontra = false;
DigitalIn but0(PTC9);
DigitalIn but1(PTC10);
DigitalIn but2(PTC11);

int main()
{
    while (true)
    {
        if (but1 != 1 && but2 != 1) {
            led[i].write(intensity);  // use PWM to set the LED brightness
            wait_us(WAIT_TIME_US);
        }
        else {
            led[i].write(1.0);  // set the LED to full brightness
        }

        if (but0 != 1 && !kontra) {
            kontra = true;
            led[i].write(0);  // turn off the current LED
            i++;

            if (i == 8) {
                i = 0;
            }

            intensity = 1.0;
            led[i].write(intensity);  // set the next LED to full brightness
        }

        if (but0 == 1 && kontra) {
            kontra = false;
        }

        if (but1 == 0) {
            intensity -= 0.1;
            if (intensity < 0.0) {
                intensity = 1.0;
            }
            led[i].write(intensity);  // use PWM to set the LED brightness
            wait_us(100000);
        }
    }
}
