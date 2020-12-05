package main

import (
	"net/http"
)

func main() {
	r := InitializeRouter()
	http.ListenAndServe(":80", r)
}
