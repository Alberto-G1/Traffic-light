// Define Slave LED pins
#define RED_LED_PIN_SLAVE 5
#define YELLOW_LED_PIN_SLAVE 6
#define GREEN_LED_PIN_SLAVE 7

const char slaveID = '2'; // Unique ID for this slave

void turnOnRedSlave() {
    PORTD |= (1 << RED_LED_PIN_SLAVE);
    PORTD &= ~(1 << YELLOW_LED_PIN_SLAVE);
    PORTD &= ~(1 << GREEN_LED_PIN_SLAVE);
}

void turnOnYellowSlave() {
    PORTD &= ~(1 << RED_LED_PIN_SLAVE);
    PORTD |= (1 << YELLOW_LED_PIN_SLAVE);
    PORTD &= ~(1 << GREEN_LED_PIN_SLAVE);
}

void turnOnGreenSlave() {
    PORTD &= ~(1 << RED_LED_PIN_SLAVE);
    PORTD &= ~(1 << YELLOW_LED_PIN_SLAVE);
    PORTD |= (1 << GREEN_LED_PIN_SLAVE);
}

void setup() {
    DDRD |= (1 << RED_LED_PIN_SLAVE) | (1 << YELLOW_LED_PIN_SLAVE) | (1 << GREEN_LED_PIN_SLAVE);
    Serial.begin(9600);
}

void loop() {
    if (Serial.available() > 1) {
        char receivedID = Serial.read();
        char command = Serial.read();
        if (receivedID == slaveID) {
            if (command == 'R') turnOnRedSlave();
            else if (command == 'Y') turnOnYellowSlave();
            else if (command == 'G') turnOnGreenSlave();
        }
    }
}