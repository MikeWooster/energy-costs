package main

import "github.com/gorilla/mux"

// InitializeRouter - creates the routes for the project.
func InitializeRouter() *mux.Router {
	r := mux.NewRouter()

	r.HandleFunc("/", HomeHandler)
	r.HandleFunc("/health", HealthHandler)

	return r
}
