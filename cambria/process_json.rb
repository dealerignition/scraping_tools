require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json/pure'

countertops = open('http://www.cambriausa.com/default/includes/themes/default/javascripts/data_colors.js').read.gsub(/(Desert[^"]*Collection &trade;)/, "Desert Collection").gsub("&trade;", "")
countertops = countertops.scan(/\(function\(\$, global\)\{global\.CAMBRIA = global\.CAMBRIA \|\| \{\}; CAMBRIA\.tiles = (.*)\}\(jQuery, this\)\);/)[0][0]
countertops = JSON.parse(countertops)

countertop_arr = []
new_countertop = {:name => "", :details => "", :warranty => "", :collection_name => "", :room_image_url => "", :styles => [], :colors => []}
new_countertop_style = {:style_name => ""}
new_countertop_color = {:color_name => "", :color_type => "", :color_image_url => "", :high_resolution_color_image_url => ""}

countertops.each_key do |k|
  countertop = new_countertop.clone
  countertop[:name] = countertops[k]["name"]
  countertop[:warranty] = "At Cambria, we offer a Lifetime Limited Warranty against manufacturing defects. Feel the confidence and freedom of living with your Cambria, knowing we stand firmly behind every product we make and every customer we earn. For more information, <a href='http://www.cambriausa.com/linkservid/456DD93C-6643-45F8-B79BC2A1669C13A1/showMeta/0/'>download the Lifetime Limited Warranty</a>. To register your Cambria for our Lifetime Limited Warranty, simply complete the online <a href='http://www.cambriausa.com/living-with-cambria/warranty-registration/warranty-registration-form/'>Warranty Registration Form</a>."
  countertop[:collection_name] = countertops[k]["collection"]
  countertop[:details] = Nokogiri::HTML(open("http://www.cambriausa.com"+countertops[k]["detailURL"])).xpath("//div[@class='main-primary color-detail detail-#{countertops[k]["name"].downcase.gsub(" ", "-")}']/p")[0].inner_text
  
  countertop[:styles] = []
  countertop[:colors] = []

  countertops[k]["qualities"].each do |quality|
    if quality.scan('Colors') != []
      countertop[:colors] << {
        :color_name => countertops[k]["name"],
        :color_type => quality.gsub("_"," "),
        :color_image_url => "http://cambriausa.com"+countertops[k]["detailImage"],
        :high_resolution_color_image_url => "http://cambriausa.com"+countertops[k]["largeImage"],
      }
    else
      countertop[:styles] << {
        :style_name => quality.gsub("_"," ")
      }
    end
  end

  countertop_arr << countertop
end

i = 1
countertop_arr.each do |countertop|
  puts "#{i}\t#{countertop[:name]}\t#{countertop[:details]}\t#{countertop[:warranty]}\t#{countertop[:collection_name]}\t#{countertop[:room_image_url]}\t5"
  i = i + 1
end

i = 1
countertop_arr.each do |countertop|
  countertop[:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
countertop_arr.each do |countertop|
  countertop[:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_type]}\t#{color[:color_image_url]}"
  end
  i = i + 1
end
