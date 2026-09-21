<p align="center">
  <a href="https://rubygems.org/gems/wikipedia_scraper">
    <img src="https://img.shields.io/gem/v/wikipedia_scraper.svg" alt="Gem Version"></img></a>
  <a href="https://rubygems.org/gems/wikipedia_scraper">
    <img src="https://img.shields.io/gem/dt/wikipedia_scraper.svg" alt="Downloads"></img></a>
  <img src="https://img.shields.io/github/license/rocketdey/wikipedia_scraper.svg" alt="License"></img>
</p>

# Wikipedia Scraper

This library can be used for scraping Wikipedia articles into a structured JSON format.

Unlike traditional scrapers that simply extract plain text, this project preserves the structure of a Wikipedia page by converting it into nested sections, Markdown-formatted text, lists and tables.

## Features

- Scrape any public Wikipedia article
- Convert article content into structured JSON
- Preserve nested sections
- Convert formatting to Markdown
  - **Bold**
  - *Italic*
  - Links from anchors
- Extract
  - Paragraphs
  - Ordered & unordered lists
  - References
  - Tables (including rowspan/colspan support)
- Skip Wikipedia navigation, metadata and styling elements
- Simple CLI interface
- Can also be used as a Ruby library

---

## Installation

Clone the repository:

```bash
git clone https://github.com/rocketdey/wikipedia_scraper.git
cd wikipedia_scraper
```

Install dependencies:

```bash
bundle install
```

### Gem installation

```bash
gem install wikipedia_scraper
```

## Usage

### Command Line

```bash
wikipedia_scraper # This will scrape https://en.wikipedia.org/wiki/special:random to current dir
```

```bash
wikipedia_scraper https://en.wikipedia.org/wiki/Apple_Inc. ./output/
```

This will create

```
output/
└── Apple_Inc..json
```

---

### Ruby Library

```ruby
require "wikipedia_scraper"

page = WikipediaScraper::Page.fetch(
  "https://en.wikipedia.org/wiki/Alan_Turing"
)

puts page.title

page.save_json("./output")
```

---

## Example JSON

```json
{
  "title": "David Chase",
  "short_description": "American writer, director and producer (born 1945)",
  "url": "https://en.wikipedia.org/wiki/David_Chase",
  "sections": [
    {
      "id": 0,
      "heading": null,
      "content": [
        "**David Henry Chase**[1][2] (born August 22, 1945) is an American writer, producer, and director. ..."
      ]
    },
    {
      "id": 1,
      "heading": "Early life",
      "content": [
        "Chase was born as an only child to Norma ([née](https://en.wikipedia.org/wiki/Birth_name#Maiden_and_married_names) Bucco) and Enrico \"Henry\" Chase, both born in 1908 and hailing from Italian-American working-class families. ..."
        {
          "id": 2,
          "heading": "Mental health and education",
          "content": [
            "Chase struggled with [panic attacks](https://en.wikipedia.org/wiki/Panic_attacks) and [clinical depression](https://en.wikipedia.org/wiki/Clinical_depression) as a teenager, something that he dealt with into adulthood. ..."
          ]
        }
      ]
    },
    {
      "id": 3,
      "heading": "Career",
      "content": [
        "Chase started in Hollywood as a [story editor](https://en.wikipedia.org/wiki/Story_editor) for *[Kolchak: The Night Stalker](https://en.wikipedia.org/wiki/Kolchak:_The_Night_Stalker)* and then produced episodes of *[The Rockford Files](https://en.wikipedia.org/wiki/The_Rockford_Files)* and *[Northern Exposure](https://en.wikipedia.org/wiki/Northern_Exposure)*, among other series. ...",
        {
          "id": 4,
          "heading": "*The Sopranos*",
          "content": [
            "Chase worked in relative anonymity before *[The Sopranos](https://en.wikipedia.org/wiki/The_Sopranos)* debuted.[11] The story of *The Sopranos* was initially conceived as a feature film about \"a mobster in therapy having problems with his mother\".[23] Chase got some input from his manager [Lloyd Braun](https://en.wikipedia.org/wiki/Lloyd_Braun_(media_executive)) and decided to adapt it into a television series.[23] ..."
            [
              "*The Sopranos* credits",
              [
                "Writer",
                [
                  "\"[The Sopranos](https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode))\" *(episode 1.01)*",
                  "\"[46 Long](https://en.wikipedia.org/wiki/46_Long)\" *(episode 1.02)*",
                  "..."
                ],
                "Director",
                [
                  "\"[The Sopranos](https://en.wikipedia.org/wiki/The_Sopranos_(pilot_episode))\" *(episode 1.01)*",
                  "\"[Made in America](https://en.wikipedia.org/wiki/Made_in_America_(The_Sopranos))\" *(episode 6.21)*"
                ],
                "Actor",
                "Chase appeared as a man sitting at an outdoor cafe in [Naples](https://en.wikipedia.org/wiki/Naples), Italy smoking a cigarette in the season two episode \"[Commendatori](https://en.wikipedia.org/wiki/Commendatori)\". He also appeared as an airline passenger en route to Italy in season six's \"[Luxury Lounge](https://en.wikipedia.org/wiki/Luxury_Lounge)\". His voice was also used over the phone in the episode \"The Test Dream\"."
              ]
            ]
          ]
        },
        {
          "id": 5,
          "heading": "*Not Fade Away*",
          "content": [
            "*[Not Fade Away](https://en.wikipedia.org/wiki/Not_Fade_Away_(film))* (2012), Chase's feature film debut, was released on December 21, 2012. It centers on the lead singer of a teenage [rock 'n' roll](https://en.wikipedia.org/wiki/Rock_and_roll) band (played by [John Magaro](https://en.wikipedia.org/wiki/John_Magaro)) in 1960s New Jersey.[38][39] ..."
          ]
        },
        {
          "id": 6,
          "heading": "*The Many Saints of Newark*",
          "content": [
            "Although Chase was \"against [the movie] for a long time\",[41] *[Deadline Hollywood](https://en.wikipedia.org/wiki/Deadline_Hollywood)* reported in March 2018 that [New Line Cinema](https://en.wikipedia.org/wiki/New_Line_Cinema) had purchased the script for *[The Many Saints of Newark](https://en.wikipedia.org/wiki/The_Many_Saints_of_Newark)* ..."
          ]
        }
      ]
    },
    {
      "id": 7,
      "heading": "Unrealized projects",
      "content": [
        {
          "id": 8,
          "heading": "*A Ribbon of Dreams*",
          "content": [
            "Chase has previously developed *A Ribbon of Dreams*, a [miniseries](https://en.wikipedia.org/wiki/Miniseries) for HBO. According to an HBO [press release](https://en.wikipedia.org/wiki/Press_release), the series' pilot would \"begin in 1913 and follow two men, one a college-educated mechanical engineer, the other a cowboy with a violent past, ..."
          ]
        }
      ]
    },
    {
      "id": 9,
      "heading": "Personal life",
      "content": [
        "After graduating from NYU in 1968, Chase moved to California and married his high school sweetheart Denise Kelly.[11] He is the father of actress Michele DeCesare, who appeared in six of *The Sopranos* episodes as [Hunter Scangarelo](https://en.wikipedia.org/wiki/Hunter_Scangarelo).[49]",
        "..."
      ]
    },
    {
      "id": 10,
      "heading": "Select filmography",
      "content": [
        {
          "id": 11,
          "heading": "Television",
          "content": [
            [
              [
                "Year",
                "Title",
                "Director",
                "Writer",
                "Producer",
                "Creator",
                "Notes"
              ],
              [
                "1971",
                "*[The Bold Ones: The Lawyers](https://en.wikipedia.org/wiki/The_Bold_Ones:_The_Lawyers)*",
                "No",
                "Yes",
                "No",
                "No",
                "Episode: \"In Defense of Ellen McKay\""
              ],
              "..."
            ]
          ]
        },
        {
          "id": 12,
          "heading": "Film",
          "content": [
            "..."
          ]
        },
        {
          "id": 13,
          "heading": "Other credits",
          "content": [
            "..."
          ]
        }
      ]
    },
    {
      "id": 14,
      "heading": "Awards and recognition",
      "content": [
        "..."
      ]
    },
    {
      "id": 15,
      "heading": "See also",
      "content": [
        "[List of Primetime Emmy Award winners](https://en.wikipedia.org/wiki/List_of_Primetime_Emmy_Award_winners)"
      ]
    },
    {
      "id": 16,
      "heading": "References",
      "content": [
        [
          "1. Chase says his name was not David DeCesare at birth in this interview: [https://interviews.televisionacademy.com/interviews/david-chase#](https://interviews.televisionacademy.com/interviews/david-chase#) [Archived](https://web.archive.org/web/20190331030349/https://interviews.televisionacademy.com/interviews/david-chase)March 31, 2019, at the[Wayback Machine](https://en.wikipedia.org/wiki/Wayback_Machine)",
          "2. Fleming, Mike Jr. (September 7, 2021). [\"David Chase On Reviving 'Sopranos' Spirit With 'The Many Saints Of Newark' And High Interest In Another Prequel Film\"](https://deadline.com/2021/09/david-chase-sopranos-revival-the-many-saints-of-newark-disdain-day-date-bow-interested-in-another-prequel-film-1234828184/). *Deadline*. Retrieved September 8, 2021.",
          "3. *[Wise Guy: David Chase and the Sopranos](https://en.wikipedia.org/wiki/Wise_Guy:_David_Chase_and_the_Sopranos)*",
          "..."
        ]
      ]
    },
    {
      "id": 17,
      "heading": "External links",
      "content": [
        [
          "[David Chase](https://www.imdb.com/name/nm0153740/)at[IMDb](https://en.wikipedia.org/wiki/IMDb_(identifier))",
          "[David Chase](https://interviews.televisionacademy.com/interviews/david-chase)at[The Interviews: An Oral History of Television](https://en.wikipedia.org/wiki/The_Interviews:_An_Oral_History_of_Television)"
        ]
      ]
    }
  ]
}
```

---

## Supported Elements

| Element | Output |
|---------|--------|
| Paragraphs | Markdown text |
| Links | Markdown links |
| Bold | `**text**` |
| Italic | `*text*` |
| Lists | Ruby Arrays |
| References | Numbered Arrays |
| Tables | Nested Arrays |
| Nested Sections | Recursive Hashes |

---

## Project Structure

```
bin/
    wikipedia_scraper

lib/
    wikipedia_scraper/
        page.rb
        tag_scraper.rb
        version.rb
    wikipedia_scraper.rb

spec/
    fixtures/
      Chechen_language.html
      Chechen_language.json
      David_Chase.html
      David_Chase.json
      The_Off-Season.html
      The_Off-Season.json
    page_spec.rb
    spec_helper.rb
    tag_scraper_spec.rb
```

### `Page`

Responsible for

- downloading a Wikipedia page
- parsing the HTML
- walking through article sections
- building the final JSON structure
- saving the result

### `TagScraper`

Handles HTML parsing and conversion.

Responsibilities include:

- Markdown conversion
- List parsing
- Table parsing
- Reference extraction
- Link formatting

The module contains no network or file I/O, making it easy to test independently.

---

## Dependencies

- HTTParty
- Nokogiri
- JSON
- RSpec (development)

---

## Running Tests

```bash
rake spec
```

---

## Current Limitations

- Infobox parsing is currently disabled.
- Templates and navigation boxes are intentionally ignored.
- There may be unknown errors since this library is a WIP (Work in Progress).

---

## Future Improvements

- Infobox parsing
- Multi-thread operation
- Parallel page scraping

---

## Why this project?

The goal of this project is to provide a clean, structured representation of Wikipedia articles suitable for:

- LLM datasets
- Search indexing
- Knowledge extraction
- Data analysis
- Offline archives
- Markdown generation

Rather than scraping raw HTML, the library attempts to preserve the semantic structure of the article.

---

## License

MIT License
