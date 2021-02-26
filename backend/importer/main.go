package main

import (
	"context"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"zhimporter/fs"
)

func main() {

	var (
		source string
		title  string
		lang   string
		file   string
	)

	flag.StringVar(&source, "source", "", "provide a link to the source of vocab being imported")
	flag.StringVar(&title, "title", "", "provide a title for the vocab list being imported")
	flag.StringVar(&lang, "lang", "", "provide the language code for the vocab being imported")
	flag.StringVar(&file, "file", "", "provide the file to import")
	flag.Parse()

	if source == "" || title == "" || lang == "" || file == "" {
		fmt.Fprintln(os.Stderr, "please specify all command line flags")
		os.Exit(1)
	}

	ds, err := fs.NewClient()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	l := fs.List{
		Title:  title,
		Lang:   lang,
		Source: source,
	}
	ctx := context.Background()
	err = ds.CreatePublicList(ctx, l)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	in, err := os.Open(file)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	r := csv.NewReader(in)
	r.Comma = '\t'
	r.Comment = '#'

	vs := []fs.Vocab{}

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		if len(record) != 5 {
			continue
		}

		v := fs.Vocab{
			Lang:        l.Lang,
			Writing:     record[0],
			Reading:     record[3],
			Definitions: map[string]string{"en": record[4]},
			Source:      l.Source,
		}
		vs = append(vs, v)

		fmt.Printf("%s\t%s\t%s\n", v.Writing, v.Reading, v.Definitions["en"])
	}

	fmt.Println("Adding:", len(vs), "vocab items")

	err = ds.CreatePublicVocabBatch(ctx, l, vs)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	fmt.Println()
}
