class Food
  attr_accessor :name, :url, :serving_size, :carbs, :fats, :protein
  attr_writer :calorie_info, :carbohydrates, :fats_and_fatty_acids, :protein_and_amino_acids, :vitamins, :minerals, :sterols, :other

  @@all = []

  def initialize(food_hash)
    @name = food_hash.values_at(:name).join
    @url = food_hash.values_at(:url).join
    @@all << self unless Food.find_by_name(self.name)
  end

  def self.create_from_collection(food_array)
    food_array.each { |food| self.new(food) }
  end

  def self.all
    @@all
  end

  def self.list
    self.all.each.with_index(1) do |food, i|
      puts "#{i}. #{food.name}"
    end
  end

  def self.find_by_name(name)
    self.all.detect { |i| i.name == name }
  end

  def self.clear
    @@all.clear
  end

  def self.create_foods(url)
    food_array = Scraper.scrape_food_list(url)
    self.create_from_collection(food_array)
  end

  def self.top_foods
    self.clear
    self.create_foods("http://nutritiondata.self.com/foods-0.html")
  end

  def self.search(searched_food)
    self.clear
    Browser.set(searched_food)
    Browser.click(css: ".searchNow")
    self.create_foods(Browser.url)
    if Browser.exists?(css: "a[title =\"Next\"]")
      Browser.click(css: "a[title =\"Next\"]")
      self.create_foods(Browser.url)
    end
  end

  def nutrition_data(info)
    self.serving_size = info.values_at(:serving_size).join
    self.carbs = info.values_at(:carbs).join
    self.fats = info.values_at(:fats).join
    self.protein = info.values_at(:protein).join
    self.calorie_info = info.values_at(:"Calorie Information").first
    self.carbohydrates = info.values_at(:Carbohydrates).first
    self.fats_and_fatty_acids = info.values_at(:"Fats & Fatty Acids").first
    self.protein_and_amino_acids = info.values_at(:"Protein & Amino Acids").first
    self.vitamins = info.values_at(:Vitamins).first
    self.minerals = info.values_at(:Minerals).first
    self.sterols = info.values_at(:Sterols).first
    self.other = info.values_at(:Other).first
  end

  def basic_data
    puts "Basic Information"
    puts "================="
    puts "Serving size: #{self.serving_size}"
    puts "Carbs: #{self.carbs}"
    puts "Fats: #{self.fats}"
    puts "Protein: #{self.protein}"
    puts "========================="
  end

  def calorie_info
    keys = []
    @calorie_info.each_key { |key| keys << key }
    puts "Calorie Information"
    puts "==================="
    puts "Total Calories: #{@calorie_info[keys[0]][0]} | Daily Value: #{@calorie_info[keys[0]][2]}"
    puts "Calories From Carbohydrates: #{@calorie_info[keys[1]][0]}"
    puts "Calories From Fats: #{@calorie_info[keys[2]][0]}"
    puts "Calories From Protein: #{@calorie_info[keys[3]][0]}"
    puts "Calories From Alcohol: #{@calorie_info[keys[4]][0]}"
    puts "========================="
  end

  def carbohydrates
    puts "Carbohydrates"
    puts "============="
    puts "Total Carbohydrates: #{@carbohydrates[:"Total Carbohydrate"][0]}#{@carbohydrates[:"Total Carbohydrate"][1]} | Daily Value: #{@carbohydrates[:"Total Carbohydrate"][2]}"
    puts "Dietary Fiber: #{@carbohydrates[:"Dietary Fiber"][1]}#{@carbohydrates[:"Dietary Fiber"][2]}"
    puts "Starch: #{@carbohydrates[:Starch][1]}#{@carbohydrates[:Starch][2]}"
    puts "Sugars: #{@carbohydrates[:Sugars][1]}#{@carbohydrates[:Sugars][2]}"
    puts "Sucrose: #{@carbohydrates[:Sucrose][1]}#{@carbohydrates[:Sucrose][2]}"
    puts "Glucose: #{@carbohydrates[:Glucose][1]}#{@carbohydrates[:Glucose][2]}"
    puts "Fructose: #{@carbohydrates[:Fructose][1]}#{@carbohydrates[:Fructose][2]}"
    puts "Lactose: #{@carbohydrates[:Lactose][1]}#{@carbohydrates[:Lactose][2]}"
    puts "Maltose: #{@carbohydrates[:Maltose][1]}#{@carbohydrates[:Maltose][2]}"
    puts "Galactose: #{@carbohydrates[:Galactose][1]}#{@carbohydrates[:Galactose][2]}"
    puts "========================="
  end

  def fats_and_fatty_acids
    puts "Fats and Fatty Acids"
    puts "===================="
    puts "Total Fat: #{@fats_and_fatty_acids[:"Total Fat"][0]}#{@fats_and_fatty_acids[:"Total Fat"][1]} | Daily Value: #{@fats_and_fatty_acids[:"Total Fat"][2]}"
    puts "Saturated Fat: #{@fats_and_fatty_acids[:"Saturated Fat"][1]}#{@fats_and_fatty_acids[:"Saturated Fat"][2]}"
    puts "Monounsaturated Fat: #{@fats_and_fatty_acids[:"Monounsaturated Fat"][1]}#{@fats_and_fatty_acids[:"Monounsaturated Fat"][2]}"
    puts "Polyunsaturated Fat: #{@fats_and_fatty_acids[:"Polyunsaturated Fat"][1]}#{@fats_and_fatty_acids[:"Polyunsaturated Fat"][2]}"
    puts "Trans Fatty Acids: #{@fats_and_fatty_acids[:"Total trans fatty acids"][1]}#{@fats_and_fatty_acids[:"Total trans fatty acids"][2]}"
    puts "Omega-3 Fatty Acids: #{@fats_and_fatty_acids[:"Total Omega-3 fatty acids"][1]}#{@fats_and_fatty_acids[:"Total Omega-3 fatty acids"][2]}"
    puts "Omega-6 Fatty Acids: #{@fats_and_fatty_acids[:"Total Omega-6 fatty acids"][1]}#{@fats_and_fatty_acids[:"Total Omega-6 fatty acids"][2]}"
    puts "========================="
  end

  def protein_and_amino_acids
    puts "Protein and Amino Acids"
    puts "======================="
    puts "Total Protein: #{@protein_and_amino_acids[:Protein][0]}#{@protein_and_amino_acids[:Protein][1]} | Daily Value: #{@protein_and_amino_acids[:Protein][2]}"
    puts "Tryptophan: #{@protein_and_amino_acids[:Tryptophan][1]}#{@protein_and_amino_acids[:Tryptophan][2]}"
    puts "Threonine: #{@protein_and_amino_acids[:Threonine][1]}#{@protein_and_amino_acids[:Threonine][2]}"
    puts "Isoleucine: #{@protein_and_amino_acids[:Isoleucine][1]}#{@protein_and_amino_acids[:Isoleucine][2]}"
    puts "Leucine: #{@protein_and_amino_acids[:Leucine][1]}#{@protein_and_amino_acids[:Leucine][2]}"
    puts "Lysine: #{@protein_and_amino_acids[:Lysine][1]}#{@protein_and_amino_acids[:Lysine][2]}"
    puts "Methionine: #{@protein_and_amino_acids[:Methionine][1]}#{@protein_and_amino_acids[:Methionine][2]}"
    puts "Cystine: #{@protein_and_amino_acids[:Cystine][1]}#{@protein_and_amino_acids[:Cystine][2]}"
    puts "Phenylalanine: #{@protein_and_amino_acids[:Phenylalanine][1]}#{@protein_and_amino_acids[:Phenylalanine][2]}"
    puts "Tyrosine: #{@protein_and_amino_acids[:Tyrosine][1]}#{@protein_and_amino_acids[:Tyrosine][2]}"
    puts "Valine: #{@protein_and_amino_acids[:Valine][1]}#{@protein_and_amino_acids[:Valine][2]}"
    puts "Arginine: #{@protein_and_amino_acids[:Arginine][1]}#{@protein_and_amino_acids[:Arginine][2]}"
    puts "Histidine: #{@protein_and_amino_acids[:Histidine][1]}#{@protein_and_amino_acids[:Histidine][2]}"
    puts "Alanine: #{@protein_and_amino_acids[:Alanine][1]}#{@protein_and_amino_acids[:Alanine][2]}"
    puts "Aspartic Acid: #{@protein_and_amino_acids[:"Aspartic acid"][1]}#{@protein_and_amino_acids[:"Aspartic acid"][2]}"
    puts "Glutamic Acid: #{@protein_and_amino_acids[:"Glutamic acid"][1]}#{@protein_and_amino_acids[:"Glutamic acid"][2]}"
    puts "Glycine: #{@protein_and_amino_acids[:Glycine][1]}#{@protein_and_amino_acids[:Glycine][2]}"
    puts "Proline: #{@protein_and_amino_acids[:Proline][1]}#{@protein_and_amino_acids[:Proline][2]}"
    puts "Serine: #{@protein_and_amino_acids[:Serine][1]}#{@protein_and_amino_acids[:Serine][2]}"
    puts "Hydroxyproline: #{@protein_and_amino_acids[:Hydroxyproline][1]}#{@protein_and_amino_acids[:Hydroxyproline][2]}"
    puts "========================="
  end

  def vitamins
    puts "Vitamins"
    puts "========"
    puts "Vitamin A: #{@vitamins[:"Vitamin A"][0]}#{@vitamins[:"Vitamin A"][1]} | Daily Value: #{@vitamins[:"Vitamin A"][2]}"
    puts "Retinol: #{@vitamins[:Retinol][1]}#{@vitamins[:Retinol][2]}"
    puts "Retinol Activity Equivalent: #{@vitamins[:"Retinol Activity Equivalent"][1]}#{@vitamins[:"Retinol Activity Equivalent"][2]}"
    puts "Alpha Carotene: #{@vitamins[:"Alpha Carotene"][1]}#{@vitamins[:"Alpha Carotene"][2]}"
    puts "Beta Carotene: #{@vitamins[:"Beta Carotene"][1]}#{@vitamins[:"Beta Carotene"][2]}"
    puts "Beta Cryptoxanthin: #{@vitamins[:"Beta Cryptoxanthin"][1]}#{@vitamins[:"Beta Cryptoxanthin"][2]}"
    puts "Lycopene: #{@vitamins[:Lycopene][1]}#{@vitamins[:Lycopene][2]}"
    puts "Lutein + Zeaxanthin: #{@vitamins[:"Lutein+Zeaxanthin"][1]}#{@vitamins[:"Lutein+Zeaxanthin"][2]}"
    puts "Vitamin C: #{@vitamins[:"Vitamin C"][0]}#{@vitamins[:"Vitamin C"][1]} | Daily Value: #{@vitamins[:"Vitamin C"][2]}"
    puts "Vitamin D: #{@vitamins[:"Vitamin D"][0]}#{@vitamins[:"Vitamin D"][1]} | Daily Value: #{@vitamins[:"Vitamin D"][2]}"
    puts "Vitamin E (Alpha Tocopherol): #{@vitamins[:"Vitamin E (Alpha Tocopherol)"][0]}#{@vitamins[:"Vitamin E (Alpha Tocopherol)"][1]} | Daily Value: #{@vitamins[:"Vitamin E (Alpha Tocopherol)"][2]}"
    puts "Beta Tocopherol: #{@vitamins[:"Beta Tocopherol"][1]}#{@vitamins[:"Beta Tocopherol"][2]}"
    puts "Gamma Tocopherol: #{@vitamins[:"Gamma Tocopherol"][1]}#{@vitamins[:"Gamma Tocopherol"][2]}"
    puts "Delta Tocopherol: #{@vitamins[:"Delta Tocopherol"][1]}#{@vitamins[:"Delta Tocopherol"][2]}"
    puts "Vitamin K: #{@vitamins[:"Vitamin K"][0]}#{@vitamins[:"Vitamin K"][1]} | Daily Value: #{@vitamins[:"Vitamin K"][2]}"
    puts "Thiamin: #{@vitamins[:Thiamin][0]}#{@vitamins[:Thiamin][1]} | Daily Value: #{@vitamins[:Thiamin][2]}"
    puts "Riboflavin: #{@vitamins[:Riboflavin][0]}#{@vitamins[:Riboflavin][1]} | Daily Value: #{@vitamins[:Riboflavin][2]}"
    puts "Niacin: #{@vitamins[:Niacin][0]}#{@vitamins[:Niacin][1]} | Daily Value: #{@vitamins[:Niacin][2]}"
    puts "Vitamin B6: #{@vitamins[:"Vitamin B6"][0]}#{@vitamins[:"Vitamin B6"][1]} | Daily Value: #{@vitamins[:"Vitamin B6"][2]}"
    puts "Folate: #{@vitamins[:Folate][0]}#{@vitamins[:Folate][1]} | Daily Value: #{@vitamins[:Folate][2]}"
    puts "Food Folate: #{@vitamins[:"Food Folate"][1]}#{@vitamins[:"Food Folate"][2]}"
    puts "Folic Acid: #{@vitamins[:"Folic Acid"][1]}#{@vitamins[:"Folic Acid"][2]}"
    puts "Dietary Folate Equivalents: #{@vitamins[:"Dietary Folate Equivalents"][1]}#{@vitamins[:"Dietary Folate Equivalents"][2]}"
    puts "Vitamin B12: #{@vitamins[:"Vitamin B12"][0]}#{@vitamins[:"Vitamin B12"][1]} | Daily Value: #{@vitamins[:"Vitamin B12"][2]}"
    puts "Pantothenic Acid: #{@vitamins[:"Pantothenic Acid"][0]}#{@vitamins[:"Pantothenic Acid"][1]} | Daily Value: #{@vitamins[:"Pantothenic Acid"][2]}"
    puts "Choline: #{@vitamins[:Choline][0]}#{@vitamins[:Choline][1]}"
    puts "Betaine: #{@vitamins[:Betaine][0]}#{@vitamins[:Betaine][1]}"
    puts "========================="
  end

  def minerals
    puts "Minerals"
    puts "========"
    puts "Calcium: #{@minerals[:Calcium][0]}#{@minerals[:Calcium][1]} | Daily Value: #{@minerals[:Calcium][2]}"
    puts "Iron: #{@minerals[:Iron][0]}#{@minerals[:Iron][1]} | Daily Value: #{@minerals[:Iron][2]}"
    puts "Magnesium: #{@minerals[:Magnesium][0]}#{@minerals[:Magnesium][1]} | Daily Value: #{@minerals[:Magnesium][2]}"
    puts "Phosphorus: #{@minerals[:Phosphorus][0]}#{@minerals[:Phosphorus][1]} | Daily Value: #{@minerals[:Phosphorus][2]}"
    puts "Potassium: #{@minerals[:Potassium][0]}#{@minerals[:Potassium][1]} | Daily Value: #{@minerals[:Potassium][2]}"
    puts "Sodium: #{@minerals[:Sodium][0]}#{@minerals[:Sodium][1]} | Daily Value: #{@minerals[:Sodium][2]}"
    puts "Zinc: #{@minerals[:Zinc][0]}#{@minerals[:Zinc][1]} | Daily Value: #{@minerals[:Zinc][2]}"
    puts "Copper: #{@minerals[:Copper][0]}#{@minerals[:Copper][1]} | Daily Value: #{@minerals[:Copper][2]}"
    puts "Manganese: #{@minerals[:Manganese][0]}#{@minerals[:Manganese][1]} | Daily Value: #{@minerals[:Manganese][2]}"
    puts "Selenium: #{@minerals[:Selenium][0]}#{@minerals[:Selenium][1]} | Daily Value: #{@minerals[:Selenium][2]}"
    puts "Fluoride: #{@minerals[:Fluoride][0]}#{@minerals[:Fluoride][1]} | Daily Value: #{@minerals[:Fluoride][2]}"
    puts "========================="
  end

  def sterols
    puts "Sterols"
    puts "======="
    puts "Cholesterol: #{@sterols[:Cholesterol][0]}#{@sterols[:Cholesterol][1]} | Daily Value: #{@sterols[:Cholesterol][2]}"
    puts "Phytosterols: #{@sterols[:Phytosterols][0]}#{@sterols[:Phytosterols][1]}"
    puts "Campesterol: #{@sterols[:Campesterol][1]}#{@sterols[:Campesterol][2]}"
    puts "Stigmasterol: #{@sterols[:Stigmasterol][1]}#{@sterols[:Stigmasterol][2]}"
    puts "Beta-sitosterol: #{@sterols[:"Beta-sitosterol"][0]}#{@sterols[:"Beta-sitosterol"][1]}"
    puts "========================="
  end

  def other
    puts "Other"
    puts "====="
    puts "Alcohol: #{@other[:Alcohol][0]}#{@other[:Alcohol][1]}"
    puts "Water: #{@other[:Water][0]}#{@other[:Water][1]}"
    puts "Ash: #{@other[:Ash][0]}#{@other[:Ash][1]}"
    puts "Caffeine: #{@other[:Caffeine][0]}#{@other[:Caffeine][1]}"
    puts "Theobromine: #{@other[:Theobromine][0]}#{@other[:Theobromine][1]}"
    puts "========================="
  end
end
