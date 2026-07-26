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
  "title": "Dzhokhar Dudayev",
  "short_description": "First President of the Chechen Republic of Ichkeria",
  "url": "https://en.wikipedia.org/wiki/Dzhokhar_Dudayev",
  "sections": [
    {
      "id": 0,
      "heading": null,
      "content": [
        "**Dzhokhar Musayevich Dudayev** (born **Dudin Musa-Khant Dzhokhar**;[a][b] 15 February 1944 – 21 April 1996) was a Chechen politician, revolutionary and military leader of the 1990s Chechen independence movement from Russia...",
        ...
      ]
    },
    {
      "id": 1,
      "heading": "Early life and military career",
      "content": [
        "Dudayev was born in [Yalkhoroy](https://en.wikipedia.org/wiki/Yalkhoroy) from the Tsechoy [teip](https://en.wikipedia.org/wiki/Teip) in the [Checheno-Ingush Autonomous Soviet Socialist Republic](https://en.wikipedia.org/wiki/Checheno-Ingush_Autonomous_Soviet_Socialist_Republic) (ASSR)...",
        ...
      ]
    },
    ...
    {
      "id": 6,
      "heading": "Commemoration",
      "content": [
        "There is a memorial plaque made of granite attached to the house on 8 [Ülikooli street](https://en.wikipedia.org/wiki/Ülikooli_street), [Tartu](https://en.wikipedia.org/wiki/Tartu), Estonia, in which Dudayev used to work.[18] The house now hosts Hotel Barclay, and the former office of Dudayev has been converted into Dudayev's Room.[19]",
        "Places named in honor of Dudayev include:",
        [
          " [Georgia](https://en.wikipedia.org/wiki/Georgia_(country)) – There is a street in the Georgian capital [Tbilisi](https://en.wikipedia.org/wiki/Tbilisi) named after Dzokhar Dudayev.[20]",
          " [Latvia](https://en.wikipedia.org/wiki/Latvia) – In 1996, a street in the Latvian capital [Riga](https://en.wikipedia.org/wiki/Riga) was named **Džohara Dudajeva gatve** (Dzhokhar Dudaev Street). In the light of the upcoming Parliamentary elections in Latvia, several initiatives have been undertaken to lobby for the renaming or preserving the name of the street by pro-Russian and [anti-Russian](https://en.wikipedia.org/wiki/Russophobia#Latvia) political parties respectively.[21][22]",
          " [Lithuania](https://en.wikipedia.org/wiki/Lithuania) – **Džocharo Dudajevo skveras** (Dzhokhar Dudaev Square) in the [Žvėrynas](https://en.wikipedia.org/wiki/Žvėrynas) district of [Vilnius](https://en.wikipedia.org/wiki/Vilnius).[23]",
          " [Poland](https://en.wikipedia.org/wiki/Poland) – On 17 March 2005, a [roundabout](https://en.wikipedia.org/wiki/Roundabout) in the Polish capital [Warsaw](https://en.wikipedia.org/wiki/Warsaw) was named **Rondo Dżochara Dudajewa** (Dzhokhar Dudayev Roundabout).[24]",
          " [Turkey](https://en.wikipedia.org/wiki/Turkey) – After Dudayev's death, various locations in Turkey were renamed after him, such as **Şehit Cahar Dudayev Caddesi** (Martyr Dzhokhar Dudayev Avenue) and **Şehit Cahar Dudayev Parkı** (Martyr Dzhokhar Dudayev Park) in Istanbul/Ataşehir-Örnek, **Cahar Dudayev Meydanı** (Dzhokhar Dudayev Square) in [Ankara](https://en.wikipedia.org/wiki/Ankara), **Şehit Cahar Dudayev Parkı** (Martyr Dzhokhar Dudaev Park) in Adapazarı, [Sakarya](https://en.wikipedia.org/wiki/Sakarya_Province) and **Şehit Cevher Dudayev Parkı** in [Sivas](https://en.wikipedia.org/wiki/Sivas).[25]",
          " [Ukraine](https://en.wikipedia.org/wiki/Ukraine) – In 1996, a street in [Lviv](https://en.wikipedia.org/wiki/Lviv) was named *вулиця Джохара Дудаєва* (Dzhokhar Dudayev Street)..."
        ],
        [
          [
            "https://en.wikipedia.org/wiki/File:Dzokhar_Dudayev_monument_Vilnius.jpg",
            "Dzhokhar Dudayev Monument in Vilnius, Lithuania."
          ],
          [
            "https://en.wikipedia.org/wiki/File:Džohara_Dudajeva_gatve.jpg",
            "House number on *Dzhokhar Dudayev avenue* in Riga, Latvia."
          ],
          [
            "https://en.wikipedia.org/wiki/File:Dzhokhar_Dudayev_roundabout.jpg",
            "Dzhokhar Dudayev Roundabout in Warsaw, Poland."
          ],
          [
            "https://en.wikipedia.org/wiki/File:Початок_вулиці_Д._Дудаєва.jpg",
            "Dzhokhar Dudayev Street in Ivano-Frankivsk, Ukraine."
          ],
          [
            "https://en.wikipedia.org/wiki/File:Vilnius_-_Dudayev_Square.jpg",
            "Dzhokhar Dudayev Square in Vilnius, Lithuania."
          ],
          [
            "https://en.wikipedia.org/wiki/File:Galeria_czeczeńska_mural.jpg",
            "*Chechen Gallery* murals in Warsaw, Poland. Dzhokhar Dudayev on the left."
          ]
        ]
      ]
    },
    {
      "id": 9,
      "heading": "References",
      "content": [
        "1994–1998 [Encyclopædia Britannica](https://en.wikipedia.org/wiki/Encyclopædia_Britannica)",
        [
          "1. [\"Конец мятежного генерала Джохара Дудаева\"](https://www.km.ru/news/konecz_myatezhnogo_generala_dzho). *KM.RU Новости – новости дня, новости России, последние новости и комментарии*. 2010.",
          "2. [Milyon Birinci – Cahar Dudayev](https://www.gzt.com/mecra/milyon-birinci-cahar-dudayev-3401067) (in Turkish)",
          "3. Dunlop, John (1998). [*Russia Confronts Chechnya: Roots of a Separatist Conflict*](https://books.google.com/books?id=AxwpDAAAQBAJ). Cambridge University Press. pp. 97–98. [ISBN](https://en.wikipedia.org/wiki/ISBN_(identifier)) [9780521636193](https://en.wikipedia.org/wiki/Special:BookSources/9780521636193).",
          ...
        ]
      ]
    },
    {
      "id": 10,
      "heading": "Sources",
      "content": [
        "Khaustov, V. N. (2007). [\"ДУДА́ЕВ ДЖОХАР МУСАЕВИЧ\"](https://old.bigenc.ru/domestic_history/text/3822404) [DUDÁYEV DZHOKHAR MUSAYEVICH]..."
      ]
    },
    {
      "id": 11,
      "heading": "External links",
      "content": [
        "[Wikimedia Commons logo](https://en.wikipedia.org/wiki/File:Commons-logo.svg)Media related to[Dzhokhar Dudayev](https://commons.wikimedia.org/wiki/Category:Dzhokhar%20Dudayev)at Wikimedia Commons"
      ]
    },
    {
      "id": 12,
      "heading": "See also",
      "content": [
        "[Russism](https://en.wikipedia.org/wiki/Rashism), his description of the [state ideology](https://en.wikipedia.org/wiki/State_ideology) of the [Russian Federation](https://en.wikipedia.org/wiki/Russian_Federation), which he made during the [First Chechen War](https://en.wikipedia.org/wiki/First_Chechen_War). Since then many scholars, publicists, politicians have built upon his concept."
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
      Dzhokhar_Dudayev.html
      Dzhokhar_Dudayev.json
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
