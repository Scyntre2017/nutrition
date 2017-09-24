class Scraper

  def self.scrape_food_list(list_url)
    Phantom.goto(list_url)
    doc = Nokogiri::HTML.parse(Phantom.html)
    foods = []

    if Phantom.exists?(css: ".foodUrl a")
      doc.css(".foodUrl a").each do |food|
        url = "http://nutritiondata.self.com" + food.attribute("href").value.gsub(" ", "")
        name = food.text
        foods << {name: name, url: url}
      end
    elsif Phantom.exists?(css: ".menuaddOptions a")
      doc.css(".note2 > a").each do |food|
        url = "http://nutritiondata.self.com" + food.attribute("href").value.gsub(" ", "")
        name = food.text
        foods << {name: name, url: url}
      end
    end

    foods
  end

  def self.scrape_nutrition_information(url)
    Phantom.goto(url)
    if Phantom.exists?(css: ".mediumSummary")
      doc = Nokogiri::HTML.parse(Phantom.html)
      info = {}
      info[:serving_size] = doc.css("form.size select option").select { |option| option.first.first == "selected" }.first.text
      info[:carbs] = doc.css("td.carbs").text
      info[:fats] = doc.css("td.fats").text
      info[:protein] = doc.css("td.protein").text
      doc.css("div.c01").each do |title|
        symbol = title.text.strip.to_sym
        info[symbol] = {}
        title.css("+ div .clearer").each do |n|
          sym = n.css("div").first.text.strip.to_sym
          info[symbol][sym] = []
          n.css("div").drop(1).each { |d| info[symbol][sym] << d.text }
        end
      end
      info
    end
  end

end
