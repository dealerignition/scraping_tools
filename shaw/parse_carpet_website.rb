require 'open-uri'
require 'nokogiri'

@carpets = {}
@cur_carpet = nil
@new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => ""}

def process_page(page)
  page.xpath("//span[@class='recordname']/a").each do |product|
    detail_page = nil
    begin
      detail_page = Nokogiri::HTML(open("http://shawfloors.com#{product.attributes["href"].value}"))
    rescue
      next
    end
    name = detail_page.xpath("//span[@class='productName']/span").inner_text
    description = detail_page.xpath("//span[@class='productDesc']").inner_text
    collection = detail_page.xpath("//tr[@id='ctl00_ConPlchldLogin1_CollectionRow']/td/span").inner_text
    fiber = detail_page.xpath("//span[@id='ctl00_ConPlchldLogin1_fiberType']").inner_text
    room_url = detail_page.xpath("//img[@id='ctl00_ConPlchldLogin1_sampleLarge']")[0].attributes["src"].value

    if @carpets[name]
      @cur_carpet = @carpets[name]
    else
      @cur_carpet = @new_carpet.clone
      @cur_carpet[:styles] = []
      @cur_carpet[:colors] = []
      @cur_carpet[:name] = name
      @cur_carpet[:warranty] = "Shaw's Residential Carpet Fiber Hierarchy makes our warranties easy to understand, and, even more importantly, easy to compare. We have three residential fiber brands that support the Shaw brand: Anso Nylon, EverTouch Nylon, and ClearTouch PET Polyester. Each brand includes exclusive features and benefits. Please refer to our Tips, Trends, & Care section for a complete list of warranties."
      @cur_carpet[:details] = description
      @cur_carpet[:brand_name] = "Shaw"
      @cur_carpet[:room_image_url] = room_url
      @cur_carpet[:fiber_name] = fiber
      @cur_carpet[:texture_name] = collection
    end

    if not @cur_carpet[:styles].include?({:style_name => collection})
      @cur_carpet[:styles] << {
        :style_name => collection
      }
    end

    detail_page.xpath("//ul[@id='ctl00_ConPlchldLogin1_ulImages']/li").each do |color_page|
      if not @cur_carpet[:colors].include?({
        :color_name => name,
        :color_category => "Shaw Custom",
        :color_image_url => color_page.children[0].attributes["src"].value.gsub(/\?.*/,"")
      })
        @cur_carpet[:colors] << {
          :color_name => name,
          :color_category => "Shaw Custom",
          :color_image_url => color_page.children[0].attributes["src"].value.gsub(/\?.*/,"")
        }
      end
    end

    @carpets[name] = @cur_carpet
  end
end

(1..16).each do |page|
  page = Nokogiri::HTML(open("http://shawfloors.com/carpet/viewall&Page=#{page}"))
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

