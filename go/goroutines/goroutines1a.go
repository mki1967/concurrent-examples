/* tworzenie wielu wątków */
package main

import "fmt"
import "time"
import "math/rand"

const maxNr = 4

func f(from string, nr int) {
	var interval time.Duration

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		fmt.Println(from, nr, ":", i)
	}
}

func main() {
	for i := 0; i < maxNr; i++ {
		go f("Task", i)
	}
	var input string
	fmt.Scanln(&input) // blokuje main()
	fmt.Println("done")
}
