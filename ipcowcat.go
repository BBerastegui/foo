package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	fmt.Fprintf(w, "%s\n", r.Header["X-Real-Ip"][0])
}

func handlerAll(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	var response string
	response = r.Header["X-Real-Ip"][0] + "\n\n"
	delete(r.Header, "X-Real-Ip")
	reqDump, err := httputil.DumpRequest(r, true)
	if err != nil {
		log.Fatal(err)
	}
	// Append dump to response
	response += string(reqDump)
	fmt.Fprintf(w, "%s\n", response)
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/all", handlerAll)
	http.ListenAndServe(":8012", nil)
}
