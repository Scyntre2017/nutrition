class CommandLineInterface

  def run
    Phantom.run
    puts "Welcome to Nutrition Information"
    puts "Enter 'list' to list the top foods."
    puts "Enter 'search' to search for your own food."
    puts "Please enter 'search' or 'list'."
    input = gets.strip.downcase
    if input == "list"
      top_foods
    elsif input == "search"
      puts "Please enter the food you would like to search for."
      i = gets.strip.downcase
      search(i)
    end
  end

  def top_foods
    Food.top_foods
    choice
  end

  def search(searched_food)
    Food.search(searched_food)
    choice
  end

  def choice
    Food.list
    puts "Please enter a number to get the nutrition information for the selected food, enter 'main' to go back to the main menu, or enter 'exit' to exit."
    input = gets.strip
    if input.downcase == "main"
      run
    elsif input.to_i > 0
      nutrition_information(input.to_i - 1)
    end
  end

  def nutrition_information(food_number)
    food = Food.all[food_number]
    info = Scraper.scrape_nutrition_information(food.url)
    if info == nil
      puts "The selected food has no information, please select a different food."
      choice
    elsif info != nil
      food.nutrition_data(info)
      food.basic_data
      puts "1. Calorie Information"
      puts "2. Carbohydrates"
      puts "3. Fats and Fatty Acids"
      puts "4. Protein and Amino Acids"
      puts "5. Vitamins"
      puts "6. Minerals"
      puts "7. Sterols"
      puts "8. Other"
      puts "Please enter a number to view more detailed nutrition information for your selected food, enter 'back' to go back, enter 'main' to go to the main menu, or enter 'exit' to exit."
      input = gets.strip
      if input.to_i > 0
        case input.to_i
        when 1
          food.calorie_info
          nutrition_information(food_number)
        when 2
          food.carbohydrates
          nutrition_information(food_number)
        when 3
          food.fats_and_fatty_acids
          nutrition_information(food_number)
        when 4
          food.protein_and_amino_acids
          nutrition_information(food_number)
        when 5
          food.vitamins
          nutrition_information(food_number)
        when 6
          food.minerals
          nutrition_information(food_number)
        when 7
          food.sterols
          nutrition_information(food_number)
        when 8
          food.other
          nutrition_information(food_number)
        end
      elsif input.downcase == "back"
        choice
      elsif input.downcase == "main"
        run
      end
    end
  end
end
