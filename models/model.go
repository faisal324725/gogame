package models

import (
	//"time"
)

type (
	MyData struct {
		ArtistID        int       `json:"ArtistID"`
		ArtistName       string       `json:"ArtistName"`
		AlbumName      string    `json:"AlbumName"`
		ImageURL  string       `json:"ImageURL"`
		ReleaseDate  string       `json:"ReleaseDate"`
		Price  string       `json:"Price"`
		SampleURL  string       `json:"SampleURL"`
	}
)
type ResponseData struct {
	Status int `json:"status"`
	Message string `json:"message"`
	Data   []MyData

}

//price problem
//untuk tipe data decimal akan bermasalah menggunakan float
//solusinya dilakukan di front end
//saat action dengan user: 1) lakukan auto format number, 2) saat submit lakukan string replace
//field type didatabase ttp gunakan decimal lenght 18,2
/*
		type student struct {
			ID    string
			Name  string
			Grade int
		}

*/