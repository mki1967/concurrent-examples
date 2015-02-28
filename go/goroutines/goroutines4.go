/* select z timeout-em */
package main

import "fmt"
import "time"
import "math/rand"

func w(from string, cout chan int) {
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

func server1(c1, c2 chan int) {

	for {
		select {
		case msg1 := <-c1:
			fmt.Println("from c1:", msg1)
		case msg2 := <-c2:
			fmt.Println("from c2", msg2)
		case <-time.After(time.Second * 1):
			fmt.Println("timeout!")
		}
	}
}

func main() {
	ch1 := make(chan int)
	ch2 := make(chan int)

	go w("w1", ch1)
	go w("w2", ch2)
	go server1(ch1, ch2)

	var input string
	fmt.Scanln(&input) // blokuje main()
	fmt.Println("done")
}
