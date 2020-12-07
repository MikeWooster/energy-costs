package main

import (
	"net/http"
)

func main() {
	r := InitializeRouter()
	http.ListenAndServe(":8080", r)
}
