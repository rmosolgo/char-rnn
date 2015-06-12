require 'json'

INPUT_FILE = File.expand_path("../AllCards.json", __FILE__)
OUTPUT_FILE = File.expand_path("../input.txt", __FILE__)
DIVIDER = "\n------------------------\n"

all_cards_raw = File.read(INPUT_FILE)
all_cards = JSON.parse(all_cards_raw)

def format_card(card)
name = card["name"]
text = (card["text"] || "").gsub(name, "~")
flavor = card["flavor"] ? "_#{card["flavor"]}_" : ""
"
#{name}

#{card["manaCost"] || "-"} (#{card["cmc"] || 0}; #{(card["colors"] || ["colorless"]) .join(",")})
#{card["rarity"]}
#{card["type"]} #{card["power"] ? "(#{card["power"]}/#{card["toughness"]})" : ""}

#{text}
#{flavor}"
end

all_cards_as_text = all_cards.map do |name, card|
  format_card(card)
end

contents = DIVIDER + all_cards_as_text.join(DIVIDER) + DIVIDER
File.write(OUTPUT_FILE, contents)