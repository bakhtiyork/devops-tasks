package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func index(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "<p>DEVOPS=%s</p>", os.Getenv("DEFOPS"))
}

func main() {
	log.Println("Local server has started ...")
	http.HandleFunc("/", index)
	http.ListenAndServe(":80", nil)
}
