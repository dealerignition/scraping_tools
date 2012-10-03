require 'open-uri'
require 'nokogiri'

@floors = {}
@style = ""

@cur_floor = nil
@new_floor = {:name => "", :details => "", :warranty => "", :brand_name => "", :room_image_url => "", :colors => [], :styles => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }

def process_page(page)
  page.xpath("//span[@class='recordname']/a").each do |product|
    detail_page = nil
    begin
      detail_page = Nokogiri::HTML(open("http://shawfloors.com#{product.attributes["href"].value}"))
    rescue
      next
    end
    name = detail_page.xpath("//span[@id='ctl00_ConPlchldLogin1_Name']").inner_text
    description = (@style == "Tile & Stone" ? "" : detail_page.xpath("//span[@class='productDesc']").inner_text)
    room_url = (@style == "Hardwood" ? detail_page.xpath("//img[@id='ctl00_ConPlchldLogin1_HardwoodDetailsImagery_sampleLarge']")[0].attributes["src"].value : (@style == "Laminate" ? detail_page.xpath("//img[@id='ctl00_ConPlchldLogin1_LaminateDetailsImagery_sampleLarge']")[0].attributes["src"].value : (@style == "Resilient" ? detail_page.xpath("//img[@id='ctl00_ConPlchldLogin1_ResilientDetailsImagery_sampleLarge']")[0].attributes["src"].value : nil)))

    if @floors[name]
      @cur_floor = @floors[name]
    else
      @cur_floor = @new_floor.clone
      @cur_floor[:styles] = []
      @cur_floor[:colors] = []
      @cur_floor[:name] = name
      @cur_floor[:warranty] = (@style == "Tile & Stone" ? "<a href='http://shawfloors.com/DOWNLOADS/WARRANTIES/Ceramic%20Tile%20Flooring%20Warranty.pdf'>CERAMIC TILE WARRANTY</a>" : (@style == "Hardwood" ? "With the warranty protection of Shaw Hardwoods, you can enjoy beautiful hardwood flooring and peace-of-mind for years to come." : (@style == "Resilient" ? "With the warranty protection of Shaw Hardwoods, you can enjoy beautiful hardwood flooring and peace-of-mind for years to come." : "")))
      @cur_floor[:details] = description.gsub(/\n/, "  ").gsub(/"/, "")
      @cur_floor[:brand_name] = "Shaw"
      @cur_floor[:room_image_url] = room_url
    end

    if not @cur_floor[:styles].include?({:style_name => @style})
      @cur_floor[:styles] << {
        :style_name => @style
      }
    end

    if @style == "Tile & Stone"
      detail_page.xpath("//table[@class='available_colors']/tr/td/input").each do |color_page|
        if not @cur_floor[:colors].include?({
          :color_name => name,
          :color_category => "Shaw Custom",
          :color_image_url => color_page.attributes["src"].value.gsub(/\?.*/,"") + "?$sf_w630$"
        })
          @cur_floor[:colors] << {
            :color_name => name,
            :color_category => "Shaw Custom",
            :color_image_url => color_page.attributes["src"].value.gsub(/\?.*/,"") + "?$sf_w630$"
          }
        end
      end
    else
      detail_page.xpath("//ul[@id='#{(@style == "Hardwood" ? "ctl00_ConPlchldLogin1_HardwoodDetailsImagery_ulImages" : (@style == "Laminate" ? "ctl00_ConPlchldLogin1_LaminateDetailsImagery_ulImages" : "ctl00_ConPlchldLogin1_ResilientDetailsImagery_ulImages"))}']/li").each do |color_page|
        if not @cur_floor[:colors].include?({
          :color_name => name.gsub(/"/, ""),
          :color_category => "Shaw Custom",
          :color_image_url => color_page.children[0].attributes["src"].value.gsub(/\?.*/,"") + "?$sf_w630$"
        })
          @cur_floor[:colors] << {
            :color_name => name.gsub(/"/, ""),
            :color_category => "Shaw Custom",
            :color_image_url => color_page.children[0].attributes["src"].value.gsub(/\?.*/,"") + "?$sf_w630$"
          }
        end
      end
    end

    @floors[name] = @cur_floor
  end
end

@style = "Tile & Stone"
(1..25).each do |page|
  page = Nokogiri::HTML(open("http://shawfloors.com/ceramic-flooring/viewall&Page=#{page}"))
  process_page(page)
end
@style = "Hardwood"
(1..16).each do |page|
  page = Nokogiri::HTML(open("http://shawfloors.com/hardwood-floors/viewall&Page=#{page}"))
  process_page(page)
end
@style = "Laminate"
(1..10).each do |page|
  page = Nokogiri::HTML(open("http://shawfloors.com/laminate-flooring/viewall&Page=#{page}"))
  process_page(page)
end
@style = "Resilient"
(1..13).each do |page|
  page = Nokogiri::HTML(open("http://shawfloors.com/resilient-flooring/viewall&Page=#{page}"))
  process_page(page)
end

i = 1
@floors.each_key do |key|
  puts "#{@floors[key][:brand_name]}\t#{i}\t#{@floors[key][:name]}\t#{@floors[key][:details]}\t#{@floors[key][:room_image_url]}\t#{@floors[key][:warranty]}"
  i = i + 1
end

i = 1
@floors.each_key do |key|
  @floors[key][:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
@floors.each_key do |key|
  @floors[key][:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_image_url]}\t#{color[:color_category]}"
  end
  i = i + 1
end
