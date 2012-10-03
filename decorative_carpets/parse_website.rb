require 'nokogiri'
require 'open-uri'

@carpets = {}
@style = ""
@cur_carpet = nil
@new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => ""}

def process_page(page)
  page.xpath("//div[@id='gallery']/div[@class='product']").each do |product|
    link = product.children.find { |x| x.name == "a" }
    href = link.attributes["href"].value
    detail_page = Nokogiri::HTML(open("http://www.decorativecarpets.com#{href}"))
    name = detail_page.xpath("//div[@id='gallery']/h2").inner_text
    image_url = "http://www.decorativecarpets.com#{detail_page.xpath("//div[@id='gallery']/img")[0].attributes["src"].value}"
    description = detail_page.xpath("//div[@id='gallery']/p[@class='description']").inner_text

    if @carpets[name]
      @cur_carpet = @carpets[name]
    else
      @cur_carpet = @new_carpet.clone
      @cur_carpet[:styles] = []
      @cur_carpet[:colors] = []
      @cur_carpet[:name] = name
      @cur_carpet[:warranty] = ""
      @cur_carpet[:details] = description
      @cur_carpet[:brand_name] = "Decorative Carpets"
      @cur_carpet[:room_image_url] = ""
      @cur_carpet[:fiber_name] = "Decorative Carpets Custom"
      @cur_carpet[:texture_name] = "Decorative Carpets Custom"
    end

    if not @cur_carpet[:styles].include?({:style_name => @style})
      @cur_carpet[:styles] << {
        :style_name => @style
      }
    end

    if not @cur_carpet[:colors].include?({
      :color_name => name,
      :color_category => "Decorative Carpets Custom",
      :color_image_url => image_url
    })
      @cur_carpet[:colors] << {
        :color_name => name,
        :color_category => "Decorative Carpets Custom",
        :color_image_url => image_url
      }
    end

    @carpets[name] = @cur_carpet
  end
end

#process contemporary
@style = "Contemporary"
(1..7).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=442820205"))
  process_page(page)
end
#process floral
@style = "Floral"
(1..3).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=1092900264"))
  process_page(page)
end
#process geometric
@style = "Geometric"
(1..3).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=986866124"))
  process_page(page)
end
#process organic
@style = "Organic"
(1..3).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=1143950691"))
  process_page(page)
end
#process stripe
@style = "Stripe"
(1..1).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=430326217"))
  process_page(page)
end
#process textural
@style = "Textural"
(1..2).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=1143950693"))
  process_page(page)
end
#process traditional
@style = "Traditional"
(1..3).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=953125641"))
  process_page(page)
end
#process transitional
@style = "Transitional"
(1..4).each do |page|
  page = Nokogiri::HTML(open("http://www.decorativecarpets.com/products?page=#{page}&style=1143950692"))
  process_page(page)
end

i = 1
@carpets.each_key do |key|
  puts "#{@carpets[key][:brand_name]}\t#{i}\t#{@carpets[key][:name]}\t#{@carpets[key][:details]}\t#{@carpets[key][:room_image_url]}\t#{@carpets[key][:fiber_name]}\t#{@carpets[key][:texture_name]}\t#{@carpets[key][:warranty]}"
  i = i + 1
end

i = 1
@carpets.each_key do |key|
  @carpets[key][:styles].each do |style_i|
    puts "#{i}\t#{style_i[:style_name]}"
  end
  i = i + 1
end

i = 1
@carpets.each_key do |key|
  @carpets[key][:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_image_url]}\t#{color[:color_category]}"
  end
  i = i + 1
end
