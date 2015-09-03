package main

import (
	"fmt"
	"net/http"
	"strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	fmt.Fprintf(w, "%s\n", r.Header["X-Real-Ip"][0])
}

func handlerAll(w http.ResponseWriter, r *http.Request) {
	var response string
	response = r.Header["X-Real-Ip"][0] + "\n"
	for k, v := range r.Header {
		if k != "X-Real-Ip" {
			values := strings.Join(v, ",")
			response = response + k + ":" + values + "\n"
		}
	}
	fmt.Fprintf(w, "%s\n", response)
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/all", handlerAll)
	http.ListenAndServe(":8012", nil)
}
