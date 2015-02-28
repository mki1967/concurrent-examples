/* kierunki kanałów */
package main

import "fmt"
import "time"
import "math/rand"

func w(from string, cout chan<- int) {
	var interval time.Duration
	var value int

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		value = rand.Intn(100)
		fmt.Println(from, ": writing ", value)
		cout <- value // zapis do kanału

	}
}

func r(from string, cin <-chan int) {
	var interval time.Duration
	var value int

	for i := 0; i < 1000; i++ {
		interval = time.Duration((100 + rand.Intn(3000)))
		time.Sleep(time.Millisecond * interval)
		value = <-cin // odczyt z kanału
		fmt.Println(from, ": read ", value)
	}
}

func main() {
	ch := make(chan int)

	go w("w1", ch)
	go w("w2", ch)

	go r("r1", ch)
	go r("r2", ch)

	var input string
	fmt.Scanln(&input) // blokuje main()
	fmt.Println("done")
}
