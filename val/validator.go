package val

import (
	"fmt"
	"net/mail"
	"regexp"
)

var (
	isValidUsername = regexp.MustCompile(`^[a-z0-9_]+$`).MatchString
	isValidFullName = regexp.MustCompile(`^[a-zA-Z\s]+$`).MatchString
)

func ValidateString(value string, minLength int, maxLength int) error {
	n := len(value)

	if n < minLength || n > maxLength {
		return fmt.Errorf("must contains %d-%d characters", minLength, maxLength)
	}

	return nil
}

func ValidateInteger(value int, minValue int, maxValue int) error {
	if value < minValue || value > maxValue {
		return fmt.Errorf("must contains %d-%d numbers", minValue, maxValue)
	}

	return nil
}

func ValidateUsername(value string) error {
	if err := ValidateString(value, 3, 100); err != nil {
		return err
	}

	if !isValidUsername(value) {
		return fmt.Errorf("must containonly lowercase letters, digits or underscore")
	}

	return nil
}

func ValidateFullName(value string) error {
	if err := ValidateString(value, 3, 100); err != nil {
		return err
	}

	if !isValidFullName(value) {
		return fmt.Errorf("must containonly letters or spaces")
	}

	return nil
}

func ValidatePassword(value string) error {
	return ValidateString(value, 6, 16)
}

func ValidateEmail(value string) error {
	if err := ValidateString(value, 3, 36); err != nil {
		return err
	}

	if _, err := mail.ParseAddress(value); err != nil {
		return fmt.Errorf("is not a valid email address")
	}

	return nil
}

func ValidateEmailId(value int64) error {
	if value <= 0 {
		return fmt.Errorf("must be a positive integer")
	}

	return nil
}

func ValidateSecretCode(value int) error {
	return ValidateInteger(value, 100000, 999999)
}
