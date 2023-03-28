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
