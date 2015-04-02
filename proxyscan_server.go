package main

import (
	"fmt"
	"log"
	"math/rand"
	"net"
	"net/http"
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
var task_queue = make(chan string)

// Array of strings with finished tasks
var finished_tasks []string

func main() {
	go feed(task_queue)
	serve()
	fmt.Println(len(finished_tasks), " tareas finalizadas: ", finished_tasks)
}

// This function will feed the task channel
func feed(task_queue chan string) {
	ip, ipnet, err := net.ParseCIDR("10.76.22.0/24")
	if err != nil {
		log.Fatal(err)
	}
	for ip := ip.Mask(ipnet.Mask); ipnet.Contains(ip); inc(ip) {
		task_queue <- ip.String()
	}
	fmt.Println("FEED FINISHED")
}

func serve() {
	for {
		http.HandleFunc("/", handler)
		http.ListenAndServe(":8011", nil)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	ip := <-task_queue
	fmt.Println("IP sent...", ip)
	fmt.Fprintf(w, "%s", ip)
	finished_tasks = append(finished_tasks, ip)
}
