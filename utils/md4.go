package main

import (
	"flag"
	"fmt"
	"unicode/utf16"

	// nolint:staticcheck
	"golang.org/x/crypto/md4"
)

func utf16le(s string) []byte {
	codes := utf16.Encode([]rune(s))
	b := make([]byte, len(codes)*2)
	for i, r := range codes {
		b[i*2] = byte(r)
		b[i*2+1] = byte(r >> 8)
	}
	return b
}

func hash(item string) (string, error) {
	if item == "" {
		return "", fmt.Errorf("no password given")
	}
	h := md4.New()
	if _, err := h.Write(utf16le(item)); err != nil {
		return "", err
	}
	return fmt.Sprintf("%x", string(h.Sum(nil))), nil
}

func main() {
	s := flag.String("password", "", "password to create an MD4 for hostapd")
	flag.Parse()
	h, err := hash(*s)
	if err != nil {
		fmt.Printf("error: %v\n", err)
		panic("failed to hash")
	}
	fmt.Println(h)
}
