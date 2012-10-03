require 'savon'

client = Savon.client("http://www.laticrete.com/desktopmodules/laticrete.products/productsservice.asmx?WSDL")
client.config.log = false
HTTPI.log = false

response = client.request :get_product_list
response = response.to_hash[:get_product_list_response][:get_product_list_result][:product]

categories = client.request(:get_cat_list).to_hash[:get_cat_list_response][:get_cat_list_result][:category]

floors = []

response.each do |floor|
  temp_floor = {}
  floor = client.request(:get_product_details) do |soap|
    soap.body = { "product_id" => floor[:product_id] }
  end.to_hash[:get_product_details_response][:get_product_details_result]
  temp_floor["name"] = floor[:model_name]
  temp_floor["brand"] = "Laticrete"
  temp_floor["description"] = floor[:description].gsub(/\n/, "")
  temp_floor["colors"] = [{ "color_name" => floor[:model_name], "color_category" => floor[:model_name], "image" => floor[:product_image] }]
  x = "Laticrete"
  begin
    x = categories.find { |x| x[:category_id] == floor[:category_id] }[:category_name]
  rescue
  end
  temp_floor["styles"] = [{ "style_name" => x }]
  floors << temp_floor
end

i = 1
floors.each do |floor|
  puts "#{floor["brand"]}\t#{i}\t#{floor["name"]}\t#{floor["description"]}\t\t"
  i = i + 1
end

i = 1
floors.each do |floor|
  floor["colors"].each do |color|
    puts "#{i}\t#{color["color_name"]}\t#{color["image"]}\t#{color["color_category"]}"
  end
  i = i + 1
end

i = 1
floors.each do |floor|
  floor["styles"].each do |style|
    puts "#{i}\t#{style["style_name"]}"
  end
  i = i + 1
end
