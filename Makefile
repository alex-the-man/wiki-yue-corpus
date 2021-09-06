WIKI_DUMP_DATE=20210901
WIKI_DUMP_URL=https://dumps.wikimedia.org/zh_yuewiki/$(WIKI_DUMP_DATE)/zh_yuewiki-$(WIKI_DUMP_DATE)-pages-articles.xml.bz2
DATA_PATH=data
OUTPUT_PATH=corpus.csv
BUILD_DIR=build
BZ2_PATH=$(BUILD_DIR)/wiki.xml.bz2
WIKI_JSON_PATH=$(BUILD_DIR)/wiki-json
TMP_CORPUS_TABLE_NAME=corpus-tmp
TMP_CORPUS_PATH=$(BUILD_DIR)/$(TMP_CORPUS_TABLE_NAME).csv

all: $(BZ2_PATH)  $(OUTPUT_PATH)

$(BZ2_PATH):
	@echo "Downloading wiki dump from $(WIKI_DUMP_URL) to $($(BZ2_PATH)..."
	@mkdir build || true
	@curl $(WIKI_DUMP_URL) -o $(BZ2_PATH)

$(OUTPUT_PATH):
	# The following script requires Python 3.7. Python 3.8 doesn't work.
	# Please install wikiextractor 3.0.5 and csvkit. Note: wikiextractor 3.0.5 isn't available on pip. Please git clone https://github.com/attardi/wikiextractor.git
	# pip install csvkit
	@rm -rf $(WIKI_JSON_PATH) || true
	@echo "Extracting articles from wiki dump..."
	@wikiextractor $(BZ2_PATH) -o $(WIKI_JSON_PATH) --json -b 1000G
	@echo "Converting extracted articles into csv."
	@in2csv -f ndjson $(WIKI_JSON_PATH)/AA/wiki_00 > $(TMP_CORPUS_PATH)
	@echo "Cleaning csv."
	@csvsql --query "select cast(id as integer) as key, title, url, cast(revid as integer) as revid, replace(text, X'0A', '') as text from '$(TMP_CORPUS_TABLE_NAME)' where length(text) > 0" $(TMP_CORPUS_PATH) 1> $(OUTPUT_PATH)

clean:
	@rm -rf build $(OUTPUT_PATH)
