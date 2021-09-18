package repository

import (
	"log"
	//"time"
	"errors"
	"database/sql"
	"context"
	"fmt"
	"alphaindosoft/config"
	"alphaindosoft/models"
)

const (
	table          = "artists"
	layoutDateTime = "2006-01-02 15:04:05"
)

// GetAll
func GetAll(ctx context.Context) ([]models.MyData, error) {

	var datalist []models.MyData

	db, err := config.MySQL()

	if err != nil {
		log.Fatal("Cant connect to MySQL", err)
	}

	queryText := fmt.Sprintf("SELECT * FROM %v Order By ReleaseDate DESC", table)

	rowQuery, err := db.QueryContext(ctx, queryText)

	if err != nil {
		log.Fatal(err)
	}

	for rowQuery.Next() {
		var dataview models.MyData

		if err = rowQuery.Scan(&dataview.ArtistID,
			&dataview.ArtistName,
			&dataview.AlbumName,
			&dataview.ImageURL,
			&dataview.ReleaseDate,
			&dataview.Price,
			&dataview.SampleURL); err != nil {
			return nil, err
		}

		datalist = append(datalist, dataview)

	}

	return datalist, nil

}


func Insert(ctx context.Context, dataConn models.MyData) error {
	db, err := config.MySQL()

	if err != nil {
		log.Fatal("Can't connect to MySQL", err)
	}

	queryText := fmt.Sprintf("INSERT INTO %v (ArtistName, AlbumName, ImageURL, ReleaseDate, Price, SampleURL) values('%v','%v','%v','%v','%v','%v')", table,
		dataConn.ArtistName,
		dataConn.AlbumName,
		dataConn.ImageURL,
		dataConn.ReleaseDate,
		dataConn.Price,
		dataConn.SampleURL)
	
	fmt.Println(queryText)

	_, err = db.ExecContext(ctx, queryText)

	if err != nil {
		return err
	}
	return nil
}

// Update
func Update(ctx context.Context, dataConn models.MyData) error {

	db, err := config.MySQL()

	if err != nil {
		log.Fatal("Can't connect to MySQL", err)
	}

	queryText := fmt.Sprintf("UPDATE %v set ArtistName = '%v', AlbumName = '%v', ImageURL = '%v', ReleaseDate = '%v', Price = '%v', SampleURL = '%v' where ArtistID = '%d'",
		table,
		dataConn.ArtistName,
		dataConn.AlbumName,
		dataConn.ImageURL,
		dataConn.ReleaseDate,
		dataConn.Price,
		dataConn.SampleURL,
		dataConn.ArtistID,
	)
	fmt.Println(queryText)

	_, err = db.ExecContext(ctx, queryText)

	if err != nil {
		return err
	}

	return nil
}


// Delete
func Delete(ctx context.Context, dataConn models.MyData) error {

	db, err := config.MySQL()

	if err != nil {
		log.Fatal("Can't connect to MySQL", err)
	}

	queryText := fmt.Sprintf("DELETE FROM %v where ArtistID = '%d'", table, dataConn.ArtistID)

	s, err := db.ExecContext(ctx, queryText)

	if err != nil && err != sql.ErrNoRows {
		return err
	}

	check, err := s.RowsAffected()
	fmt.Println(check)
	if check == 0 {
		return errors.New("id tidak ada")
	}

	return nil
}