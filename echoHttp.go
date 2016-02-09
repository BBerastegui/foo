package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
)

var l = flag.String("l", "localhost:8008", "Where to listen.")

func main() {
	flag.Parse()
	http.HandleFunc("/", dumpReq)
	log.Println("[i] Listening on: " + *l)
	log.Fatal(http.ListenAndServe(*l, nil))
}

func dumpReq(w http.ResponseWriter, r *http.Request) {
	reqDump, err := httputil.DumpRequest(r, true)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Fprintf(w, "%#s", string(reqDump))
	log.Println("[i] Request received:")
	fmt.Println(string(reqDump))
}
