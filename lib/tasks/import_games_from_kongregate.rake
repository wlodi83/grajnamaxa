require 'net/http'
require 'open-uri'
require 'active_support/all'

namespace :kongregate do
  desc "Import games from Kongregate"
  task import: [:environment] do
    xml_feed = Net::HTTP.get(URI.parse('http://www.kongregate.com/games_for_your_site.xml'))
    data = Hash.from_xml(xml_feed)

    user = User.where(username: "Serwis GrajNaMaxa").first

    data["gameset"]["game"].each do |game|
      @category = nil
      @screenshot = nil
      if Game.where(title: game["title"]).first.present?
        puts "Gra *" + game["title"] + "* juz zostala dodana do serwisu."
        next
      end
      case game["category"]
          when "Adventure & RPG"
            @category = Category.where(name: "Gry Przygodowe").first.id
          when "Puzzle"
            @category = Category.where(name: "Puzzle").first.id
          when "Music & More"
            @category = Category.where(name: "Gry muzyczne").first.id
          when "Sports & Racing"
            @category = Category.where(name: "Gry sportowe").first.id
          when "Action"
            @category = Category.where(name: "Gry Akcji").first.id
          when "Shooter"
            @category = Category.where(name: "Strzelanie").first.id
          when "Strategy & Defense"
            @category = Category.where(name: "Gry Strategiczne").first.id
          when "Multiplayer"
            @category = Category.where(name: "Multiplayery").first.id
          else
            @category = nil
      end
      if game["screenshot"].nil?
        if game["featured_image"].nil?
          @screenshot = open(game["thumbnail"].gsub('http://','https://')) 
        else
          @screenshot = open(game["featured_image"].gsub('http://','https://'))
        end
      else
        if game["screenshot"].class == String
          @screenshot = open(game["screenshot"].gsub('http://','https://'))
        elsif game["screenshot"].class == Array
          @screenshot = open(game["screenshot"][0].gsub('http://','https://'))
        end
      end
      Game.create!(
        title: game["title"],
        description: game["description"].nil? ? "Opis gry do wpisania" : game["description"],
        instruction: game["instructions"].nil? ? "Instrukcja do wpisania" : game["instructions"],
        source: "<embed width=\"#{game["width"]}\" height=\"#{game["height"]}\" base=\"#{game["flash_file"].match(".*live\/")}\" src=\"#{game["flash_file"]}\" type=\"application\/x\-shockwave\-flash\"></embed><br/>Play free games at <a href=\"http:\/\/www.kongregate.com\/\">Kongregate</a>",
        screen: @screenshot,
        user_id: user.id,
        published: false,
        developer_name: game["developer_name"],
        category_id: @category,
        provider: "Kongregate"
      )
      puts game["title"]
    end
  end
end