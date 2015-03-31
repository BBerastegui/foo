package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"sync"
	"time"
)

func random(min, max int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(max-min) + min
}

// Channel of simultaneous tasks
var simul = make(chan string, 5)

// Array of strings with finished tasks
var finished_tasks []string

// Waitgroup... or something...
var wg sync.WaitGroup

func main() {
	wg.Add(1)
	task_queue := make(chan string)
	//var task_run chan string

	go consume(task_queue, simul)
	go feed(task_queue)
	wg.Wait()
	fmt.Println(len(finished_tasks), " tareas finalizadas: ", finished_tasks)
}

// This function will feed the task channel
func feed(task_queue chan string) {
	for i := 0; i < 3; i++ {
		fmt.Println("Adding 10 more tasks...")
		for x := 0; x < 10; x++ {
			task_queue <- strconv.FormatInt(time.Now().UnixNano()/int64(time.Microsecond), 10)
		}
		fmt.Println("Waiting 10 seconds to add more tasks...")
		time.Sleep(time.Second * 10)
	}
	wg.Done()
}

// This will run in a loop 4evah, feeding as simultaneous goroutines
// as the simul channel buffer is set.
func consume(task_queue chan string, simul chan string) {
	for {
		id := <-task_queue
		simul <- id
		go scan(id, simul)
	}
}

func scan(id string, simul chan string) {
	fmt.Println("Scan commenced...", id)
	wait := random(1, 5)
	fmt.Println("Waiting for ", wait, " seconds.")
	time.Sleep(time.Second * time.Duration(wait))
	fmt.Println("Task ", id, " finished.")
	fin_task := <-simul
	finished_tasks = append(finished_tasks, fin_task)
}
