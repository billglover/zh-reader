package fs

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
)

// Client is a Google Cloud Firestore client.
type Client struct {
	fs *firestore.Client
}

// NewClient creates a default Client with a Background context.
func NewClient() (*Client, error) {
	client, err := createClient(context.Background())
	if err != nil {
		return nil, err
	}

	c := new(Client)
	c.fs = client
	return c, nil
}

func createClient(ctx context.Context) (*firestore.Client, error) {
	projectID := "zn-reader"
	client, err := firestore.NewClient(ctx, projectID)
	return client, err
}

// Vocab represents a single vocab entry in the Firestore Database.
type Vocab struct {
	Lang             string            `firestore:"lang,omitempty"`
	Writing          string            `firestore:"writing,omitempty"`
	Reading          string            `firestore:"reading,omitempty"`
	Definitions      map[string]string `firestore:"definitions,omitempty"`
	HeisigDefinition string            `firestore:"heisigDefinition,omitempty"`
	Source           string            `firestore:"source,omitempty"`
	Created          time.Time         `firestore:"created,serverTimestamp"`
}

// ID returns the ID of a given Vocab item. The ID is generated from the
// Writing property.
func (v *Vocab) ID() string {
	data := []byte(v.Writing)
	h := sha256.New()
	h.Write(data)
	return hex.EncodeToString(h.Sum(nil))
}

// CreatePublicVocab Sets a Vocab item within the given public List.
func (c *Client) CreatePublicVocab(ctx context.Context, l List, v Vocab) error {
	_, err := c.fs.Collection("public").Doc(l.ID()).Collection("vocab").Doc(v.ID()).Set(ctx, v)
	if err != nil {
		return err
	}

	return nil
}

// CreatePublicVocabBatch Sets a batch of Vocab items within the given public List.
func (c *Client) CreatePublicVocabBatch(ctx context.Context, l List, vs []Vocab) error {
	b := c.fs.Batch()

	for i, v := range vs {
		ref := c.fs.Collection("public").Doc(l.ID()).Collection("vocab").Doc(v.ID())
		b.Set(ref, v)

		// We can't make more than 500 field changes in a single batch
		fmt.Println(i, i%25)
		if i != 0 && i%25 == 0 {
			fmt.Println("batching")
			_, err := b.Commit(ctx)
			if err != nil {
				return err
			}

			b = c.fs.Batch()
		}
	}

	_, err := b.Commit(ctx)
	if err != nil {
		return err
	}

	return nil
}

// List represents a public List of Vocab items.
type List struct {
	Lang    string    `firestore:"lang,omitempty"`
	Title   string    `firestore:"title,omitempty"`
	Source  string    `firestore:"source,omitempty"`
	Created time.Time `firestore:"created,serverTimestamp"`
}

// ID returns the ID of a given List. The ID is generated from a combination
// of the title and source.
func (l *List) ID() string {
	data := []byte(l.Title + l.Source)
	h := sha256.New()
	h.Write(data)
	return hex.EncodeToString(h.Sum(nil))
}

// CreatePublicList creates a public List.
func (c *Client) CreatePublicList(ctx context.Context, l List) error {
	_, err := c.fs.Collection("public").Doc(l.ID()).Set(ctx, l)
	if err != nil {
		log.Println(err)
		return err
	}

	return nil
}
