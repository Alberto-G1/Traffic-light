// Define Master LED pins
#define RED_LED_PIN 2
#define YELLOW_LED_PIN 3
#define GREEN_LED_PIN 4

bool emergencyMode = false;

void turnOnRed() {
    PORTD |= (1 << RED_LED_PIN);    // Turn on Red
    PORTD &= ~(1 << YELLOW_LED_PIN); // Turn off Yellow
    PORTD &= ~(1 << GREEN_LED_PIN);  // Turn off Green
}

void turnOnYellow() {
    PORTD &= ~(1 << RED_LED_PIN);    // Turn off Red
    PORTD |= (1 << YELLOW_LED_PIN);  // Turn on Yellow
    PORTD &= ~(1 << GREEN_LED_PIN);  // Turn off Green
}

void turnOnGreen() {
    PORTD &= ~(1 << RED_LED_PIN);    // Turn off Red
    PORTD &= ~(1 << YELLOW_LED_PIN); // Turn off Yellow
    PORTD |= (1 << GREEN_LED_PIN);   // Turn on Green
}

void setup() {
    // Set LED pins as outputs
    DDRD |= (1 << RED_LED_PIN) | (1 << YELLOW_LED_PIN) | (1 << GREEN_LED_PIN);

    // Initialize Serial Communication for debugging
    Serial.begin(9600);
    Serial.println("Master setup complete");
}

void loop() {
    // Check if emergency mode is active
    if (emergencyMode) {
        turnOnRed(); // Master stays red
        Serial.write("1R"); // Command Slave 1 to red
        Serial.write("2R"); // Command Slave 2 to red
        delay(100); // Wait briefly to ensure red light is stable
        return; // Wait for normal mode
    }

    // Normal traffic light sequence
    turnOnRed();
    Serial.write("1G"); // Instruct Slave 1 to turn on Green
    Serial.write("2Y"); // Instruct Slave 2 to turn on Red
    delay(10000);

    turnOnYellow();
    Serial.write("1R"); // Instruct Slave 1 to turn on Red
    Serial.write("2G"); // Instruct Slave 2 to turn on Green
    delay(5000);

    turnOnGreen();
    Serial.write("1Y"); // Instruct Slave 1 to turn on Yellow
    Serial.write("2R"); // Instruct Slave 2 to turn on Red
    delay(10000);
}

// Handle serial commands (e.g., emergency signals from Slave 3)
void serialEvent() {
    while (Serial.available()) {
        char command = Serial.read();
        Serial.print("Master received: ");
        Serial.println(command);

        if (command == 'E') { // Emergency mode activated
            emergencyMode = true;
            Serial.println("Emergency mode activated.");
        } else if (command == 'N') { // Resume normal mode
            emergencyMode = false;
            Serial.println("Resuming normal mode.");
        }
    }
}