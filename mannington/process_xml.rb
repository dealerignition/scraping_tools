require 'rubygems'
require 'nokogiri'

xml_doc = Nokogiri::XML(open('output.xml'))

products_length = xml_doc.xpath("//MfgCorporation/ProductBrand/Product").length

products = {}

i = 1
while i <= products_length
  product = {}
  color = {}
  style = {}

  product[:name] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/CustomAttributes/CustomAttribute[@AttributeName='StyleName']")[0].children[0].text
  product[:details] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/ProductDescription")[0].children[0].text
  product[:warranty] = '<a href="http://www.mannington.com/residential/downloads/warranties/resilient.pdf">View Warranty Infomartion</a>'
  product[:brand] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/ProductName")[0].children[0].text.split(',')[0]
  product[:room_image] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/ProductImages/ProductImage[2]")[0].children[0].text
  
  case product[:brand]
  when "Revolutions Plank Diamond Bay", "Longwood Collection", "Restoration Collection", "Coordinations", "Revolutions Plank", "Revolutions Tile", "Value Lock Collection"
    style[:name] = "Laminate"
  when "Acropolis", "La Jolla", "Slate Valley", "Strata", "Accent Gallery", "Babylon", "Antiquity", "Cairo", "Carmel", "Catalina", "Garda", "Metro", "Opera", "Patchwork", "Serengeti Slate", "Symphony", "Tempest"
    style[:name] = "Porcelain"
  when "Adura Tile", "Adura Plank", "Distinctive Plank"
    style[:name] = "Adura"
  when "Sobella Prime", "SobellaOmni HD", "Sobella Supreme", "Sobella Deluxe"
    style[:name] = "Sobella"
  when "Premium-Naturals", "Best-Realistique", "Better-Simplicity", "Better-Aurora", "Better-Jumpstart", "Good-Benchmark", "Good-Vega", "Good-Duration"
    style[:name] = "Resilient"
  when "Earthly Elements", "American Classics", "Exotics", "Hand Crafted"
    style[:name] = "Hardwood"
  else
    style[:name] = "Unknown"
  end

  color[:name] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/CustomAttributes/CustomAttribute[@AttributeName='ColorwayName']")[0].children[0].text
  
  begin
    color[:category] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/CustomAttributes/CustomAttribute[@AttributeName='ColorFamily']")[0].children[0].text
  rescue
    begin
      color[:category] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/CustomAttributes/CustomAttribute[@AttributeName='ColorShade']")[0].children[0].text
    rescue
      color[:category] = "custom"
    end
  end
  color[:image_url] = xml_doc.xpath("//MfgCorporation/ProductBrand/Product[#{i}]/ProductImages/ProductImage[1]")[0].children[0].text
  
  if products[product[:name]] == nil
    products[product[:name]] = product
    products[product[:name]][:colors] = [color]
    products[product[:name]][:styles] = [style]
  else
    products[product[:name]][:colors] << color
    products[product[:name]][:styles] << style
  end

  i = i + 1
end

i = 1
products.each_pair do |key, value|
  puts "#{value[:brand]}\t#{i}\t#{value[:name]}\t#{value[:details]}\t#{value[:room_image]}\t#{value[:warranty]}"

  i = i + 1
end

i = 1
products.each_pair do |key, value|
  value[:colors].each do |color|
    puts "#{i}\t#{color[:name]}\t#{color[:image_url]}\t#{color[:category]}\t"
  end

  i = i + 1  
end

i = 1
products.each_pair do |key, value|
  value[:styles].each do |style|
    puts "#{i}\t#{style[:name]}"
  end

  i = i + 1
end
