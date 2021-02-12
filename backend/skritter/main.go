package main

import (
	"context"
	"fmt"
	"os"
	"zhreader/fs"
	"zhreader/skritter"
)

func main() {
	err := run()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run() error {
	ds, err := fs.NewClient()
	if err != nil {
		return err
	}

	u := fs.User{ID: "Z8Q1xcOX3LR5PU6ZOl9lzFhfxxI3"}
	err = ds.CreateUser(context.Background(), u)
	if err != nil {
		return err
	}

	c := skritter.NewClient("")
	vocabCh, err := c.VocabBatched()
	if err != nil {
		return err
	}

	count := 0
	for v := range vocabCh {
		err := ds.CreateVocab(context.Background(), u, toFsVocab(v))
		if err != nil {
			return err
		}
		fmt.Println(v.ID, v.Writing, v.HeisigDefinition)
		count++
	}

	fmt.Println("Vocab Added:", count)
	return nil
}

func toFsVocab(v skritter.Vocab) fs.Vocab {
	fsV := fs.Vocab{
		Lang:             v.Lang,
		Priority:         v.Priority,
		Style:            v.Style,
		Audio:            v.Audio,
		Toughness:        v.Toughness,
		DictionaryLinks:  v.DictionaryLinks,
		HeisigDefinition: v.HeisigDefinition,
		Created:          v.Created,
		Ilk:              v.Ilk,
		Writing:          v.Writing,
		AudioURL:         v.AudioURL,
		ToughnessString:  v.ToughnessString,
		Definitions:      v.Definitions,
		Starred:          v.Starred,
		Reading:          v.Reading,
		ID:               v.ID,
	}

	return fsV
}
