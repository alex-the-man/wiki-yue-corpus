# Cantonese Wiki Corpus - 粵語維基語料庫
Text corpus of articles on Cantonese Wikipedia snapshotted on 2021-09-01

## Format
Articles are stored as a row in the corpus.csv file.
The schema of the csv:

### key
An unique key to identify the row/article.

### title
The title of the article.

### url
The url of the article.

### revid
The revision number of the article.

### text
The text of the article. Line endings are not preserved.

## Build
Makefile is included to rebuild the corpus from [wiki dump](https://dumps.wikimedia.org/zh_yuewiki/latest/).

To build the corpus:

1. Visit [wiki dump](https://dumps.wikimedia.org/zh_yuewiki/latest/) and find the date of the latest wiki dump.
2. Open `Makefile` and change variable `WIKI_DUMP_DATE` to the last wiki dump date.
3. Run `make all` to download and  build the corpus.
   It requires Python3.7, wikiextractor 3.0.5 and csvkit.
4. `corpus.csv` is the generated corpus.

## Sample using the corpus
Spark notebook and derived dataset are included in the sample folder.

ngram.ipynb
List all frequently appeared word combos in the corpus.

## License
Wikipedia licenses their articles under the CC BY-SA 3.0 license.

Derived works under sample are released under the CC BY 4.0 license.
