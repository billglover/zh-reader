package fs

import (
	"context"

	"cloud.google.com/go/firestore"
)

type Client struct {
	fs *firestore.Client
}

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

type User struct {
	ID string `firestore:"id"`
}

func (c *Client) CreateUser(ctx context.Context, u User) error {
	_, err := c.fs.Collection("users").Doc(u.ID).Set(ctx, u)
	if err != nil {
		return err
	}

	return nil
}

type Vocab struct {
	Lang             string            `firestore:"lang,omitempty"`
	Priority         int               `firestore:"priority,omitempty"`
	Style            string            `firestore:"style,omitempty"`
	Audio            string            `firestore:"audio,omitempty"`
	Toughness        int               `firestore:"toughness,omitempty"`
	DictionaryLinks  map[string]string `firestore:"dictionaryLinks,omitempty"`
	HeisigDefinition string            `firestore:"heisigDefinition,omitempty"`
	Created          int               `firestore:"created,omitempty"`
	Ilk              string            `firestore:"ilk,omitempty"`
	Writing          string            `firestore:"writing,omitempty"`
	AudioURL         string            `firestore:"audioURL,omitempty"`
	ToughnessString  string            `firestore:"toughnessString,omitempty"`
	Definitions      map[string]string `firestore:"definitions,omitempty"`
	Starred          bool              `firestore:"starred,omitempty"`
	Reading          string            `firestore:"reading,omitempty"`
	ID               string            `firestore:"id"`
}

func (c *Client) CreateVocab(ctx context.Context, u User, v Vocab) error {
	_, err := c.fs.Collection("users").Doc(u.ID).Collection("vocab").Doc(v.ID).Set(ctx, v)
	if err != nil {
		return err
	}

	return nil
}
