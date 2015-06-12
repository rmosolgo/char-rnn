require 'fileutils'
require 'json'

INPUT_FILE = File.expand_path("../AllSets-x.json", __FILE__)
OUTPUT_FILE = File.expand_path("../input.txt", __FILE__)
STARTCARD = "STARTCARD\n"
ENDCARD = "\nENDCARD\n"

all_cards_raw = File.read(INPUT_FILE)
all_cards = JSON.parse(all_cards_raw)

def format_card(card)
  name = card["name"]
  text =    (card["text"] || "").gsub(name, "~")
  flavor =  (card["flavor"] || "").gsub(name, "~")

  card = {
    name: name,
    cost: card["manaCost"] || "",
    cmc: card["cmc"] || 0,
    colors: card["colors"] || "Colorless",
    power: card["power"],
    toughness: card["toughness"],
    rarity: card["rarity"] || "",
    type: card["type"],
    text: text,
    flavor: flavor,
  }

  JSON.pretty_generate(card).gsub("—", "-")
end

OUTPUT_ARRAY = []

all_cards.each do |set_name, set|
  set["cards"].each do |card|
    OUTPUT_ARRAY << format_card(card)
  end
end

contents = STARTCARD + OUTPUT_ARRAY.join(ENDCARD + STARTCARD) + ENDCARD
File.write(OUTPUT_FILE, contents)

CACHE_FILES = File.expand_path("../*.t7", __FILE__)
Dir.glob(CACHE_FILES).each do |f|
  FileUtils.rm(f)
end
