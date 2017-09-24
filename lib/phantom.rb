class Phantom

  @@browser = Watir::Browser.start("http://nutritiondata.self.com", :phantomjs)

  def self.run
    @@browser
  end

  def self.goto(url)
    @@browser.goto(url)
  end

  def self.url
    @@browser.url
  end

  def self.html
    @@browser.html
  end

  def self.set(searched_food)
    @@browser.text_field(name: "freetext").set(searched_food)
  end

  def self.click(css_element)
    @@browser.element(css_element).click
  end

  def self.exists?(css_element)
    @@browser.element(css_element).exists?
  end
end
