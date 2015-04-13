package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"
)

func random(min, max int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(max-min) + min
}

// Channel of simultaneous tasks
var simul = make(chan string, 10)
var task_queue = make(chan string)

// Array of strings with finished tasks
var finished_tasks []string

// Array with directories found
var found_dir []string
var found_files []string

// Array with pending directories
var pending_dir []string

// Last word used
var lastword string

func main() {
	go feed(task_queue)
	consume(task_queue, simul)

	fmt.Println(len(finished_tasks), " tareas finalizadas: ", finished_tasks)
}

// This function will feed the task channel
func feed(task_queue chan string) {

	// First open file and for each line...
	file, err := os.Open(os.Args[2])
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		task_queue <- scanner.Text()
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("FEED FINISHED")
}

func consume(task_queue chan string, simul chan string) {
	for {
		select {
		case path := <-task_queue:
			simul <- path
			go scan(path, simul)
		}
	}
}

func scan(path string, simul chan string) {
	// Foo demo func.
	// Perform HTTP request
	response, err := http.Get(os.Args[1] + path)
	if err != nil {
		// Something happened.
		log.Fatal("[Request error] %s", err)
		os.Exit(1)
	} else {
		defer response.Body.Close()
		_, err := ioutil.ReadAll(response.Body)
		if err != nil {
			log.Fatal("ERROR While reading content: %s", err)
		}
		// Handle HTTP status
		switch {
		case response.StatusCode == 404:
			fmt.Printf("\r                                ")
			fmt.Printf("\r %s", path)
		default:
			switch {
			case response.StatusCode == 200:
				fmt.Println("Found: " + path)
			case response.StatusCode >= 300 && response.StatusCode <= 399:
				fmt.Println("30X on " + path)
			case response.StatusCode == 403:
				fmt.Println("403 on " + path)
			}
		}
	}

	//fmt.Println("Task ", path, " finished.")
	finished_tasks = append(finished_tasks, <-simul)
}
