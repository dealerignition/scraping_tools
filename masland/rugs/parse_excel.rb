require 'rubygems'
require 'roo'
require 'iconv'

workbook = Roo::Excelx.new("MaslandRugs.xlsx")
workbook.default_sheet = workbook.sheets.first

@rugs = {}
@style = ""

@cur_rug = nil
@new_rug = {:name => "", :details => "", :warranty => "", :room_image_url => "", :colors => [], :styles => [], :shapes => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }
@new_shape = {:shape_name => "", :height => "", :width => "", :shape_image_url => "" }

2.upto(workbook.last_row) do |line|
  name = workbook.cell(line, 'E')

  if @rugs[name]
    @cur_rug = @rugs[name]
  else
    @cur_rug = @new_rug.clone
    @cur_rug[:styles] = []
    @cur_rug[:colors] = []
    @cur_rug[:shapes] = []
    @cur_rug[:name] = workbook.cell(line, 'E')
    @cur_rug[:warranty] = workbook.cell(line, 'P')
    @cur_rug[:details] = workbook.cell(line, 'L')
    @cur_rug[:room_image_url] = "http://s3.amazonaws.com/dealer_ignition/scraping_tools/masland/rugs/RoomScenes/" + workbook.cell(line, 'O') if workbook.cell(line, 'O')
  end
  
  if not @cur_rug[:styles].include?({:style_name => workbook.cell(line, 'J')})
    @cur_rug[:styles] << {
      :style_name => workbook.cell(line, 'J')
    }
  end

  image = "http://s3.amazonaws.com/dealer_ignition/scraping_tools/masland/rugs/Swatches/" + workbook.cell(line, 'M') if workbook.cell(line, 'M')

  if workbook.cell(line, 'D')
    rug_color_name = workbook.cell(line, 'D')
  else
    rug_color_name = "Custom"
  end

  if not @cur_rug[:colors].include?({
    :color_name => rug_color_name,
    :color_category => "Momeni Custom",
    :color_image_url => image
  })
    @cur_rug[:colors] << {
      :color_name => rug_color_name,
      :color_category => "Momeni Custom",
      :color_image_url => image
    }
  end

  if !@cur_rug.include?({
    :shape_name => "Rectangle",
    :height => 'unknown',
    :width => 'unknown',
    :shape_image_url => image
  })
    @cur_rug[:shapes] << {
      :shape_name => "Rectangle",
      :height => 'unknown',
      :width => 'unknown',
      :shape_image_url => image
    }
  end
  
  @rugs[name] = @cur_rug
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
