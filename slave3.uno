#include <avr/io.h>
#include <avr/interrupt.h>

#define RED_LED_PIN PB0 // Pin 8
#define GREEN_LED_PIN PD7 // Pin 7
#define BUTTON_PIN PD2 // Pin 2

volatile bool buttonPressed = false;

void setup() {
    // Set LED pins as outputs
    DDRB |= (1 << RED_LED_PIN);
    DDRD |= (1 << GREEN_LED_PIN);

    // Set BUTTON_PIN as input and enable pull-up resistor
    DDRD &= ~(1 << BUTTON_PIN);
    PORTD |= (1 << BUTTON_PIN);

    // Initialize Serial Communication for debugging
    Serial.begin(9600);
    Serial.println("Slave 3 setup complete");

    // Configure external interrupt on BUTTON_PIN
    EICRA |= (1 << ISC01); // Falling edge triggers interrupt
    EIMSK |= (1 << INT0);  // Enable INT0 interrupt

    sei(); // Enable global interrupts

    // Turn on Red LED initially
    PORTB |= (1 << RED_LED_PIN);
    PORTD &= ~(1 << GREEN_LED_PIN);
}

void loop() {
    if (buttonPressed) {
        buttonPressed = false;
        //Debounce delay
        delay(3000);

        // Notify master to activate emergency mode
        Serial.write('E');
        Serial.println("Sending emergency signal to master.");

        // Turn Red LED off and Green LED on
        PORTB &= ~(1 << RED_LED_PIN);
        PORTD |= (1 << GREEN_LED_PIN);
        delay(10000); // Green light duration

        // Turn Green LED off and Red LED on
        PORTD &= ~(1 << GREEN_LED_PIN);
        PORTB |= (1 << RED_LED_PIN);

        // Notify master to resume normal mode
        Serial.write('N');
        Serial.println("Sending normal mode signal to master.");
    }
}

// Interrupt Service Routine for button press
ISR(INT0_vect) {
    buttonPressed = true;
    Serial.println("Button pressed, triggering emergency mode.");
}