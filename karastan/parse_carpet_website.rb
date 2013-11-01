require 'open-uri'
require 'nokogiri'

@carpets = {}
@cur_carpet = nil
@new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => ""}

def process_page(page)
  page.xpath("//div[@class='thumb_1']/div[@class='thumb_unit preview']/ul/li/i/a").each do |product|
    uri = URI::encode("http://www.karastan.com#{product.attributes["href"].value}").gsub("[","%5B")
    
    detail_page = nil
    begin
      detail_page = Nokogiri::HTML(open(uri))
    rescue
      next
    end
    
    name = detail_page.xpath("//span[@id='MainContent_lblStyleName']").inner_text.gsub(/\t/,"").gsub(/\r/,"").gsub(/\n/,"")
    description = detail_page.xpath("//span[@id='MainContent_lblSelectedDetail']").inner_text.gsub(/\t/,"").gsub(/\r/,"").gsub(/\n/,"")
    collection = nil
    fiber = detail_page.xpath("//span[@id='MainContent_lblFiberName']").inner_text.gsub(/\t/,"").gsub(/\r/,"").gsub(/\n/,"")
    room_url = detail_page.xpath("//div[@class='room_scene']/img")[0].attributes["src"].value
    warranty = detail_page.xpath("//div[@id='MainContent_pnlWarranty']/ul").to_s.gsub(/\t/,"").gsub(/\r/,"").gsub(/\n/,"")

    if @carpets[name]
      @cur_carpet = @carpets[name]
    else
      @cur_carpet = @new_carpet.clone
      @cur_carpet[:styles] = []
      @cur_carpet[:colors] = []
      @cur_carpet[:name] = name
      @cur_carpet[:warranty] = warranty
      @cur_carpet[:details] = description
      @cur_carpet[:brand_name] = "Karastan"
      @cur_carpet[:room_image_url] = room_url
      @cur_carpet[:fiber_name] = fiber
      @cur_carpet[:texture_name] = collection
    end

    if not @cur_carpet[:styles].include?({:style_name => collection})
      @cur_carpet[:styles] << {
        :style_name => collection
      }
    end
    
    detail_page.xpath("//div[@id='MainContent_ColorDisplay']/div[@class='thumb_4']").each do |color_page|
      color_name = color_page.children[1].xpath("ul/li/i").inner_text
      image_url = color_page.xpath("a").children[0].attributes["src"].value.gsub(/\?.*/,"")

      if not @cur_carpet[:colors].include?({
        :color_name => color_name,
        :color_category => "Karastan Custom",
        :color_image_url => image_url
      })
        @cur_carpet[:colors] << {
          :color_name => color_name,
          :color_category => "Karastan Custom",
          :color_image_url => image_url
        }
      end
    end

    @carpets[name] = @cur_carpet
  end
end

(1..2).each do |page|
  page = Nokogiri::HTML(open("http://www.karastan.com/product-gallery/carpet-result.aspx?xx=1&IsKarastan=1&pp=96&page=#{page}"))
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

