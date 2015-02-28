/* wspólna zmienna */
package main

import "fmt"
import "time"
import "math/rand"

var shared int = 0

func w(from string) {
	var interval time.Duration
	var value int

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		value = rand.Intn(100)
		fmt.Println(from, ": writing ", value)
		shared = value

	}
}

func r(from string) {
	var interval time.Duration
	var value int

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		value = shared
		fmt.Println(from, ": read ", value)
	}
}

func main() {
	go w("Task1")
	go r("Task2")

	var input string
	fmt.Scanln(&input) // blokuje main()
	fmt.Println("done")
}
