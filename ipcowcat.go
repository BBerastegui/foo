package main

import (
	"fmt"
	"net"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	rA, err := net.ResolveTCPAddr("tcp", r.RemoteAddr)
	if err != nil {
		http.Error(w, "Oops.", http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, "%s", rA.IP)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8012", nil)
}
