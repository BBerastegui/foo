package main

import (
	"fmt"
	"io/ioutil"
	"math/rand"
	"net"
	"net/http"
	"os"
	"sync"
	"time"
)

func random(min, max int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(max-min) + min
}

func inc(ip net.IP) {
	for j := len(ip) - 1; j >= 0; j-- {
		ip[j]++
		if ip[j] > 0 {
			break
		}
	}
}

// Channel of simultaneous tasks
var simul = make(chan string, 20)
var task_queue = make(chan string)

// Array of strings with finished tasks
var finished_tasks []string

// Add dummy waitgroup in order for all to be running forever
var wg sync.WaitGroup

func main() {
	consume(task_queue, simul)

	fmt.Println(len(finished_tasks), " tareas finalizadas: ", finished_tasks)
}

// This will run in a loop 4evah, feeding as simultaneous goroutines
// as the simul channel buffer is set.
func consume(task_queue chan string, simul chan string) {
	for {
		// Get IP from proxyscan_server
		response, err := http.Get("http://localhost:8011/")
		if err != nil {
			fmt.Printf("%s", err)
			//os.Exit(1)
			fmt.Println("Waiting for server to come online...")
			time.Sleep(time.Second * time.Duration(10))
		} else {
			defer response.Body.Close()
			contents, err := ioutil.ReadAll(response.Body)
			if err != nil {
				fmt.Printf("%s", err)
				os.Exit(1)
			}
			ip := string(contents)
			simul <- ip
			go scan(ip, simul)
		}
	}
}

func scan(ip string, simul chan string) {
	// Foo demo func.
	fmt.Println("Scan commenced...", ip)
	wait := random(1, 5)
	fmt.Println("Waiting for ", wait, " seconds.")
	time.Sleep(time.Second * time.Duration(wait))
	fmt.Println("Task ", ip, " finished.")
	finished_tasks = append(finished_tasks, <-simul)
}
