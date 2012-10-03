require 'json'
require 'open-uri'
require 'nokogiri'

@rugs = {}
@style = ""

@cur_rug = nil
@new_rug = {:name => "", :details => "", :warranty => "", :room_image_url => "", :colors => [], :styles => [], :shapes => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }
@new_shape = {:shape_name => "", :height => "", :width => "", :shape_image_url => "" }

def process_page(page)
    page.xpath("//span[@class='recordname']/a").each do |product|
      detail_page = nil
      begin
        detail_page = Nokogiri::HTML(open("http://shawfloors.com#{product.attributes["href"].value}"))
      rescue
        next
      end
      name = detail_page.xpath("//span[@id='ctl00_ConPlchldLogin1_Name']").inner_text
      description = detail_page.xpath("//span[@class='productDesc']").inner_text.gsub(/\n/,"")
      style = detail_page.xpath("//span[@id='ctl00_ConPlchldLogin1_DesignStyleLabel']").inner_text
      room_url = nil
      begin
        detail_page.xpath("//img[@id='ctl00_ConPlchldLogin1_sampleLarge' and @current='room']")[0].attributes["src"].value
      rescue
      end

      if @rugs[name]
        @cur_rug = @rugs[name]
      else
        @cur_rug = @new_rug.clone
        @cur_rug[:styles] = []
        @cur_rug[:colors] = []
        @cur_rug[:shapes] = []
        @cur_rug[:name] = name
        @cur_rug[:warranty] = "Shaw Living offers a one year warranty against manufacturing defects of area rug products."
        @cur_rug[:details] = description
        @cur_rug[:room_image_url] = room_url
      end
      
      if not @cur_rug[:styles].include?({:style_name => style})
        @cur_rug[:styles] << {
          :style_name => style
        }
      end

      if not @cur_rug[:colors].include?({
        :color_name => name,
        :color_category => "Shaw Custom",
        :color_image_url => ""
      })
        @cur_rug[:colors] << {
          :color_name => name,
          :color_category => "Shaw Custom",
          :color_image_url => ""
        }
      end
      
      i = 0
      detail_page.xpath("//table[@id='ctl00_ConPlchldLogin1_sizesTable']/tr").each do |shape_row|
        if i == 0
          i = i + 1
          next
        end

        shape_name = ""
        height = ""
        width = ""
        shape_image_url = ""

        if not shape_row.children[2].to_html.include?("<img ")
          if shape_row.children[2].children[0].to_html.include?("<a ") and not shape_row.children[2].children[0].to_html.include?("></a>")
            shape_name = shape_row.children[2].children[0].children[0].inner_text
            height = shape_row.children[1].children[0].inner_text.scan(/([^X])X/)[0][0]
            width = shape_row.children[1].children[0].inner_text.scan(/X([^X])/)[0][0]
            url = "http://shawfloors.com" + shape_row.children[1].children[0].attributes["href"]
            sub_detail_page = Nokogiri::HTML(open(url))
            shape_image_url = sub_detail_page.xpath("//input[@id='ctl00_ConPlchldLogin1_detail']")[0].attributes.select{ |x| x == "src" }["src"].value.gsub(/\?.*/,"") + "?$rotate90$" 
          else
            if shape_row.children[2].children[0].to_html.include?("<a ")
              shape_name = shape_row.children[2].children[0].inner_text
              height = shape_row.children[1].children[0].inner_text.scan(/([^X])X/)[0][0]
              width = shape_row.children[1].children[0].inner_text.scan(/X([^X])/)[0][0]
            else 
              shape_name = shape_row.children[2].children[0].inner_text
              height = shape_row.children[1].children[0].inner_text.scan(/([^X])X/)[0][0]
              width = shape_row.children[1].children[0].inner_text.scan(/X([^X])/)[0][0]
            end
            shape_image_url = detail_page.xpath("//input[@id='ctl00_ConPlchldLogin1_detail']")[0].attributes.select{ |x| x == "src" }["src"].value.gsub(/\?.*/,"") + "?$rotate90$"
          end
          height.strip!
          width.strip!
        else
          puts shape_row.to_html
        end
        
        if shape_name != "" and !@cur_rug.include?({
          :shape_name => shape_name,
          :height => height,
          :width => width,
          :shape_image_url => shape_image_url
        })
          @cur_rug[:shapes] << {
            :shape_name => shape_name,
            :height => height,
            :width => width,
            :shape_image_url => shape_image_url
          }
        end
      end
  
      @rugs[name] = @cur_rug
    end
end

(1..78).each do |page|
  page = Nokogiri::HTML(open("http://www.shawfloors.com/area-rug/viewall&Page=#{page}"))
  process_page(page)
end

i = 1
@rugs.each_key do |key|
  puts "#{i}\t#{@rugs[key][:name]}\t#{@rugs[key][:details]}\t#{@rugs[key][:room_image_url]}\t#{@rugs[key][:warranty]}"
  i = i + 1
end

i = 1
@rugs.each_key do |key|
  @rugs[key][:colors].each do |color|
    puts "#{i}\t#{color[:color_category]}\t#{color[:color_name]}\t#{color[:color_image_url]}"
  end
  i = i + 1
end

i = 1
@rugs.each_key do |key|
  @rugs[key][:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
@rugs.each_key do |key|
  @rugs[key][:shapes].each do |shape|
    puts "#{i}\t#{shape[:shape_image_url]}\t#{shape[:height]}\t#{shape[:width]}\t#{shape[:shape_name]}"
  end
  i = i + 1
end
