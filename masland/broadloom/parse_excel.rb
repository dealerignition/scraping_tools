require 'rubygems'
require 'roo'

workbook = Roo::Excel.new("MaslandBroadloom.xls")
workbook.default_sheet = workbook.sheets.first

carpets = {}

cur_carpet = nil
new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => ""}

2.upto(workbook.last_row) do |line|
  if carpets[workbook.cell(line, 'E')]
    cur_carpet = carpets[workbook.cell(line, 'E')]
  else
    cur_carpet = new_carpet.clone
    cur_carpet[:styles] = []
    cur_carpet[:colors] = []
    cur_carpet[:name] = workbook.cell(line, 'E')
    cur_carpet[:warranty] = workbook.cell(line, 'AO')
    cur_carpet[:details] = '"' + workbook.cell(line, 'U') + '"' if workbook.cell(line, 'U')
    cur_carpet[:brand_name] = workbook.cell(line, 'B')
    cur_carpet[:room_image_url] = 'http://s3.amazonaws.com/dealer_ignition/scraping_tools/masland/broadloom/RoomScenes/' + workbook.cell(line, 'K') if workbook.cell(line, 'K')
    cur_carpet[:fiber_name] = workbook.cell(line, 'O')
    cur_carpet[:texture_name] = workbook.cell(line, 'W')
  end

  if not cur_carpet[:styles].include?({:style_name => workbook.cell(line, 'AC')})
    cur_carpet[:styles] << {
      :style_name => workbook.cell(line, 'AC')
    }
  end

  if not cur_carpet[:colors].include?({
    :color_name => workbook.cell(line, 'G'),
    :color_category => "Masland Custom",
    :color_image_url => workbook.cell(line, 'J')
  })
    if workbook.cell(line, 'J')
      cur_carpet[:colors] << {
        :color_name => workbook.cell(line, 'G'),
        :color_category => "Masland Custom",
        :color_image_url => 'http://s3.amazonaws.com/dealer_ignition/scraping_tools/masland/broadloom/Swatches/' + workbook.cell(line, 'J')
      }
    end
  end

  carpets[workbook.cell(line, 'E')] = cur_carpet
end

i = 1
carpets.each_key do |key|
  puts "#{carpets[key][:brand_name]}\t#{i}\t#{carpets[key][:name]}\t#{carpets[key][:details]}\t#{carpets[key][:room_image_url]}\t#{carpets[key][:fiber_name]}\t#{carpets[key][:texture_name]}\t#{carpets[key][:warranty]}"
  i = i + 1
end

i = 1
carpets.each_key do |key|
  carpets[key][:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
carpets.each_key do |key|
  carpets[key][:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_image_url]}\t#{color[:color_category]}"
  end
  i = i + 1
end
