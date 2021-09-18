package main

import (
	"log"
	"fmt"
	"net/http"
	"context"
	"encoding/json"
	"strconv"
	"html/template"
	"alphaindosoft/config"
	"alphaindosoft/repository"
	"alphaindosoft/utils"
	"alphaindosoft/models"
	"github.com/gorilla/mux"
)

// GetData
func GetData(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {

		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		datalist, err := repository.GetAll(ctx)

		if err != nil {
			fmt.Println(err)
		}
		
		utils.ResponseJSON(w, datalist, http.StatusOK)
		return
	}

	http.Error(w, "Tidak di ijinkan", http.StatusNotFound)
	return
}

func PostData(w http.ResponseWriter, r *http.Request) {
	
	if r.Method == "POST" {

		if r.Header.Get("Content-Type") != "application/json" {
			http.Error(w, "Gunakan content type application / json", http.StatusBadRequest)
			return
		}

		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		var dataConn models.MyData

		if err := json.NewDecoder(r.Body).Decode(&dataConn); err != nil {
			utils.ResponseJSON(w, err, http.StatusBadRequest)
			return
		}

		if err := repository.Insert(ctx, dataConn); err != nil {
			utils.ResponseJSON(w, err, http.StatusInternalServerError)
			return
		}

		res := map[string]string{
			"status": "Succesfully",
		}

		utils.ResponseJSON(w, res, http.StatusCreated)
		return
	}

	http.Error(w, "Tidak di ijinkan", http.StatusMethodNotAllowed)
	return
}

// UpdateData
func UpdateData(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {

		if r.Header.Get("Content-Type") != "application/json" {
			http.Error(w, "Gunakan content type application / json", http.StatusBadRequest)
			return
		}

		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		var dataConn models.MyData

		if err := json.NewDecoder(r.Body).Decode(&dataConn); err != nil {
			utils.ResponseJSON(w, err, http.StatusBadRequest)
			return
		}

		fmt.Println(dataConn)

		if err := repository.Update(ctx, dataConn); err != nil {
			utils.ResponseJSON(w, err, http.StatusInternalServerError)
			return
		}

		res := map[string]string{
			"status": "Succesfully",
		}

		utils.ResponseJSON(w, res, http.StatusCreated)
		return
	}

	http.Error(w, "Tidak di ijinkan", http.StatusMethodNotAllowed)
	return
}


//DeleteData
func DeleteData(w http.ResponseWriter, r *http.Request) {

	if r.Method == "POST" {

		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		var dataConn models.MyData

		id := r.URL.Query().Get("id")

		if id == "" {
			utils.ResponseJSON(w, "id tidak boleh kosong", http.StatusBadRequest)
			return
		}
		dataConn.ArtistID, _ = strconv.Atoi(id)

		if err := repository.Delete(ctx, dataConn); err != nil {

			kesalahan := map[string]string{
				"error": fmt.Sprintf("%v", err),
			}

			utils.ResponseJSON(w, kesalahan, http.StatusInternalServerError)
			return
		}

		res := map[string]string{
			"status": "Succesfully",
		}

		utils.ResponseJSON(w, res, http.StatusOK)
		return
	}

	http.Error(w, "Tidak di ijinkan", http.StatusMethodNotAllowed)
	return
}


func GETDataID(w http.ResponseWriter, r *http.Request){
	if r.Method == "GET" {
	
		var dataConn models.MyData

		id := r.URL.Query().Get("id")

		if id == "" {
			utils.ResponseJSON(w, "id tidak boleh kosong", http.StatusBadRequest)
			return
		}

		db, err := config.MySQL()
	
		if err != nil {
			log.Fatal("Can't connect to MySQL", err)
		}

		rows, err := db.Query("select * from Artists where ArtistID = ? ", id)
		if err != nil {
			log.Fatal(err)
		}

		defer rows.Close()

		if rows.Next() {
			rows.Scan(&dataConn.ArtistID, &dataConn.ArtistName, &dataConn.AlbumName, &dataConn.ImageURL, &dataConn.ReleaseDate, &dataConn.Price, &dataConn.SampleURL)
			json.NewEncoder(w).Encode(dataConn)
		}
		return
	}
	http.Error(w, "Tidak di ijinkan", http.StatusMethodNotAllowed)
	return
}


type M map[string]interface{}

func main() {

	router := mux.NewRouter()

	router.HandleFunc("/jsview", GetData)
	router.HandleFunc("/jscreate/create", PostData)
	router.HandleFunc("/jsupdate/update", UpdateData)
	router.HandleFunc("/jsedit/edit", GETDataID).Methods("GET")
	router.HandleFunc("/jsdelete/delete", DeleteData)

	db, e := config.MySQL()
	if e != nil {
		log.Fatal(e)
	}

	eb := db.Ping()
	if eb != nil {
		panic(eb.Error()) 
	}

	fs := http.FileServer(http.Dir("./assets/"))
	router.PathPrefix("/assets/").Handler(http.StripPrefix("/assets/", fs))
	
	var tmpl = template.Must(template.ParseGlob("views/*"))

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		tmpl.ExecuteTemplate(w, "index", 200)
	})

	router.HandleFunc("/deldata", func(w http.ResponseWriter, r *http.Request) {
		tmpl.ExecuteTemplate(w, "DELdata", 200)
	})
	router.HandleFunc("/playdata", func(w http.ResponseWriter, r *http.Request) {
		tmpl.ExecuteTemplate(w, "PLAYdata", 200)
	})

	router.HandleFunc("/addnew", func(w http.ResponseWriter, r *http.Request) {
		tmpl.ExecuteTemplate(w, "entrydata", nil)
	})

	router.HandleFunc("/chdata", func(w http.ResponseWriter, r *http.Request) {
		tmpl.ExecuteTemplate(w, "editdata", nil)
	})

	log.Println("Success")
		

	err := http.ListenAndServe(":7000", router)
	if err != nil {
		log.Fatal(err)
	}


	http.Handle("/", router)
}