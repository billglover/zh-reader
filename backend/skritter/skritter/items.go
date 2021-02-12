package skritter

// Item is the atomic unit of learning in Skritter. It is used to track
// reviews and learning. An item could be the writing for a character, or
// the tone of a word.
// Source Documentation: https://www.skritter.com/api/v0/docs/entities/items
type Item struct {
	Lang             string   `json:"lang"`
	Style            string   `json:"style"`
	Interval         int      `json:"interval"`
	Last             int      `json:"last"`
	Created          int      `json:"created"`
	Successes        int      `json:"successes"`
	TimeStudied      int      `json:"timeStudied"`
	Changed          int      `json:"changed"`
	Next             int      `json:"next"`
	Reviews          int      `json:"reviews"`
	PreviousInterval int      `json:"previousInterval,omitempty"`
	SectionIds       []string `json:"sectionIds"`
	VocabListIds     []string `json:"vocabListIds"`
	VocabIds         []string `json:"vocabIds"`
	Part             string   `json:"part"`
	PreviousSuccess  bool     `json:"previousSuccess"`
	ID               string   `json:"id"`
}

// Vocab is complementary to the Item entity. It and provides all the user-specific
// settings for a word, as well as all the information about the word.
// Source Documentation: https://www.skritter.com/api/v0/docs/entities/vocabs
type Vocab struct {
	Lang             string            `json:"lang"`
	Priority         int               `json:"priority"`
	Style            string            `json:"style"`
	Audio            string            `json:"audio"`
	Toughness        int               `json:"toughness"`
	DictionaryLinks  map[string]string `json:"dictionaryLinks"`
	HeisigDefinition string            `json:"heisigDefinition"`
	Created          int               `json:"created,omitempty"`
	Ilk              string            `json:"ilk"`
	Writing          string            `json:"writing"`
	Audios           []Audio           `json:"audios"`
	AudioURL         string            `json:"audioURL"`
	ToughnessString  string            `json:"toughnessString"`
	Definitions      map[string]string `json:"definitions"`
	Starred          bool              `json:"starred"`
	Reading          string            `json:"reading"`
	ID               string            `json:"id"`
}

// Audio contains links to the pronounciation of a vocab.
type Audio struct {
	Source  string `json:"source"`
	Reading string `json:"reading"`
	ID      string `json:"id"`
	Writing string `json:"writing"`
	Mp3     string `json:"mp3"`
}
