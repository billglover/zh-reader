package skritter

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

// Request represents the API request your are batching.
// Source Documentation: https://www.skritter.com/api/v0/docs/entities/requests
type Request struct {
	Created   int                    `json:"created,omitempty"`
	ID        string                 `json:"id,omitempty"`
	Spawner   bool                   `json:"spawner,omitempty"`
	SpawnedBy int64                  `json:"spawnedBy,omitempty"`
	Done      interface{}            `json:"done,omitempty"` // this is either an int or bool
	Params    map[string]interface{} `json:"params,omitempty"`
	Path      string                 `json:"path,omitempty"`
	Method    string                 `json:"method,omitempty"`

	ResponseStatusCode int      `json:"responseStatusCode"`
	Response           Response `json:"response"`
	ResponseSize       int      `json:"responseSize"`
}

type Response struct {
	Cursor     string  `json:"cursor"`
	Items      []Item  `json:"Items"`
	Vocabs     []Vocab `json:"Vocabs"`
	StatusCode int     `json:"statusCode"`
}

// BatchResponse is the response received when creating a batch.
type BatchResponse struct {
	Batch      Batch `json:"Batch"`
	StatusCode int   `json:"statusCode"`
}

// Batch is a collection of Requests for batching.
// Source Documentation: https://www.skritter.com/api/v0/docs/entities/batches
type Batch struct {
	TotalRequests   int       `json:"totalRequests"`
	Requests        []Request `json:"Requests"`
	RunningRequests int       `json:"runningRequests"`
	ID              string    `json:"id"`
	Created         int       `json:"created"`
}

// VocabBatched requests all items in a batched request.
func (c *Client) VocabBatched() (<-chan Vocab, error) {
	ch := make(chan Vocab)
	go c.vocabBatched(context.TODO(), ch)
	return ch, nil
}

func (c *Client) vocabBatched(ctx context.Context, ch chan<- Vocab) {
	defer close(ch)

	url := c.BaseURL.String() + "/api/v0/batch"

	requests := []Request{
		{
			Path:   "api/v0/items",
			Method: "GET",
			Params: map[string]interface{}{
				"include_vocabs":  "true",
				"include_heisigs": "true",
			},
			Spawner: true,
		},
	}

	jsonValue, _ := json.Marshal(requests)
	body := bytes.NewBuffer(jsonValue)

	req, err := http.NewRequest(http.MethodPost, url, body)
	if err != nil {
		fmt.Println(err)
	}

	req.Header.Add("Authorization", "Bearer "+c.token)

	bResp, err := c.httpClient.Do(req)
	if err != nil {
		fmt.Println(err)
	}
	defer bResp.Body.Close()

	batchResp := new(BatchResponse)
	err = json.NewDecoder(bResp.Body).Decode(batchResp)
	if err != nil {
		fmt.Println(err)
	}

	if batchResp.StatusCode != 200 {
		fmt.Println(fmt.Errorf("Unable to create batch: HTTP %d", batchResp.StatusCode))
	}

	batchID := batchResp.Batch.ID
	if batchID == "" {
		fmt.Println(fmt.Errorf("Unable to parse Batch.id: %s", batchResp.Batch.ID))
	}

	runningRequests := batchResp.Batch.RunningRequests

	fmt.Println("Batch ID:", batchResp.Batch.ID)

	// TODO: this feels like it needs to be protected from spinning in the
	// event we are unable to update the number of running requests.
	for runningRequests > 0 {
		time.Sleep(5 * time.Second)

		// Fetch the results of the batch
		req, err = http.NewRequest(http.MethodGet, url+"/"+batchID, nil)
		if err != nil {
			fmt.Println(err)
		}

		req.Header.Add("Authorization", "Bearer "+c.token)

		rResp, err := c.httpClient.Do(req)
		if err != nil {
			fmt.Println(err)
		}
		defer rResp.Body.Close()

		batchResp = new(BatchResponse)
		err = json.NewDecoder(rResp.Body).Decode(batchResp)
		if err != nil {
			fmt.Println(err)
		}

		if batchResp.StatusCode != 200 {
			fmt.Println(fmt.Errorf("Unable to request results: HTTP %d", batchResp.StatusCode))
		}

		runningRequests = batchResp.Batch.RunningRequests
		fmt.Println("Total Requests:", batchResp.Batch.TotalRequests)
		fmt.Println("Running Request:", runningRequests)

		seen := map[string]bool{}

		// a batch can contain multiple requests
		for _, r := range batchResp.Batch.Requests {

			// each request should contain vocab and items
			for _, v := range r.Response.Vocabs {

				// don't send the vocab item if we've already seen it in this batch
				if _, ok := seen[v.ID]; ok == true {
					continue
				}

				ch <- v
				seen[v.ID] = true
			}

		}
	}
}
