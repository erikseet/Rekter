#include <mbed.h>
#include "si4735-lib.h"
#include "pcf8574-lib.h"
#include "i2c-lib.h"

#define PCF8574_ADDRESS 0x40
#define RADIO_ADDRESS SI4735_ADDRESS

// Function declarations
uint8_t set_freq(uint16_t freq);
uint8_t set_volume(uint8_t volume);
void search_freq(void);
uint8_t get_tune_status(void);
void display_freq(uint16_t freq);

// Main function
int main()
{
    // Initialize I2C bus
    i2c_init();
    
    // Initialize Si4735 radio module
    si4735_init();
    
    // Initialize PCF8574 expander for LCD display
    pcf8574_init(PCF8574_ADDRESS);
    
    // Set initial frequency and volume
    set_freq(1000);
    set_volume(10);
    
    // Loop forever
    while(1) {
        // Display current frequency on LCD
        uint16_t freq = get_tune_status();
        display_freq(freq);
        
        // Wait for 1 second
        wait_ms(1000);
    }
}

// Function definitions
uint8_t set_freq(uint16_t freq)
{
    uint8_t data_out[5] = {0x20, 0x00, (uint8_t)(freq >> 8), (uint8_t)(freq & 0xFF), 0};
    return i2c(RADIO_ADDRESS, data_out, 5, nullptr, 0);
}

uint8_t set_volume(uint8_t volume)
{
    uint8_t data_out[4] = {0x12, 0x40, volume, 0x00};
    return i2c(RADIO_ADDRESS, data_out, 4, nullptr, 0);
}

void search_freq(void)
{
    uint8_t data_out[6] = {0x20, 0x01, 0x00, 0x00, 0x00, 0x00};
    i2c(RADIO_ADDRESS, data_out, 6, nullptr, 0);
}

uint8_t get_tune_status(void)
{
    uint8_t data_out[5] = {0x22, 0x00, 0x00, 0x00, 0x00};
    uint8_t data_in[8];
    uint8_t result = i2c(RADIO_ADDRESS, data_out, 5, data_in, 8);
    if (result != 0) {
        return 0;
    }
    uint16_t freq = ((uint16_t)data_in[2] << 8) | (uint16_t)data_in[3];
    return freq;
}

void display_freq(uint16_t freq)
{
    char buffer[17];
    snprintf(buffer, 17, "Freq: %d.%d MHz", freq / 1000, freq % 1000);
    pcf8574_write_string(PCF8574_ADDRESS, buffer);
}



#include <mbed.h>
#include "i2c-lib.h"

#define PCF8574_ADDRESS 0x40

class Expander {
public:
    Expander() {
        // Initialize the I2C bus and PCF8574 expander
        i2c_init();
        i2c_start();
        i2c_output(PCF8574_ADDRESS << 1);
        i2c_output(0x00);
        i2c_stop();
    }

    void voidbar(uint8_t t_level) {
        if (t_level > 8) {
            t_level = 8;
        }

        uint8_t level_mask = 0xFF << (8 - t_level);

        i2c_start();
        i2c_output(PCF8574_ADDRESS << 1);
        i2c_output(~level_mask);
        i2c_stop();
    }
};

int main() {
    Expander expander;

    while (1) {
        for (int i = 0; i < 9; i++) {
            expander.voidbar(i);
            wait(0.5);
        }
    }
}




#include <mbed.h>

#include "i2c-lib.h"
#include "si4735-lib.h"

//************************************************************************

// Direction of I2C communication
#define R	0b00000001
#define W	0b00000000
#define HWADR_PCF8574 0b01000000

#pragma GCC diagnostic ignored "-Wunused-but-set-variable"

DigitalOut g_led_PTA1( PTA1, 0 );
DigitalOut g_led_PTA2( PTA2, 0 );

DigitalIn g_but_PTC9( PTC9 );
DigitalIn g_but_PTC10( PTC10 );
DigitalIn g_but_PTC11( PTC11 );
DigitalIn g_but_PTC12( PTC12 );

int main( void )
{
	uint8_t l_S1, l_S2, l_RSSI, l_SNR, l_MULT, l_CAP;
	uint8_t l_ack = 0;

	printf( "K64F-KIT ready...\r\n" );

	i2c_init();

	i2c_start();

	l_ack = i2c_output( HWADR_PCF8574 | W );


	l_ack = i2c_output( 0b0000010);

	// stop communication
	i2c_stop();
return 0;
}
