#include "mbed.h"

DigitalOut led(LED1,1);
DigitalOut led1(LED2,0);

DigitalOut leds[] = {p10, p11, p12, p13, p14, p15, p16, p17};

DigitalIn button1(p5);
DigitalIn button2(p6);

bool check = false;

Ticker t1,t2,t3;

void knightRider() {
    static int index = -3; // The position of the first LED in the group of 3
    static bool increasing = true; // Direction of movement: true for right, false for left

    // Turn off the last LED based on direction
    if (increasing) {
        if (index > -3) {
            leds[index - 1] = 0;
        }
    } else {
        if (index < 9) {
            leds[index + 2] = 0;
        }
    }

    // Turn on the current LED and update the index based on direction
    leds[index] = 1;

    if (increasing) {
        index = index + 1;
    } else {
        index = index - 1;
    }

    // Keep the next 2 LEDs in the group turned on
    leds[index] = 1;
    leds[index + 1] = 1;

    // Update the direction when reaching the ends of the array
    if (index == 9 || index == -3) {
        increasing = !increasing;
    }
}

void switcher() {
    if (button1.read() && !check) {
        led = !led;
        led1 = !led1;
        check = true;
    }
    if (!button1.read() && check) { 
        check = false;
    }
}

void lower_interval() {
    static float interval = 1.0f;
    if (button2.read()) {
        if (interval > 0.1f) {
            interval -= 0.1f;
        } else {
            interval = 1.0f;
        }
        t2.attach(callback(&knightRider), interval);
    }
}

void buttons() {
    switcher();
    lower_interval();
}

int main()
{
    t2.attach(callback(&knightRider), 1);
    t3.attach(callback(&buttons), 0.05);
    while (1) {
        lower_interval();
        printf("Blink! LED1 is now %d, LED2 is now %d\n", led.read(), led1.read());
        wait_ms(500);
    }
}
