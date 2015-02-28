/* wątki współbieżne
 zajrzeć na  https://gobyexample.com/goroutines */
package main

import "fmt"
import "time"
import "math/rand"

func f(from string) {
	var interval time.Duration

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		fmt.Println(from, ":", i)
	}
}

func main() {
	go f("Task1")
	go f("Task2")
	go f("Task3")

	var input string
	fmt.Scanln(&input) // blokuje main()
	fmt.Println("done")
}
