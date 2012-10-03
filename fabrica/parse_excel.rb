require 'rubygems'
require 'roo'

workbook = Excelx.new("DI_FABCarpet.xlsx")
workbook.default_sheet = workbook.sheets.first

carpets = {}

cur_carpet = nil
new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => ""}

2.upto(workbook.last_row) do |line|
  if carpets[workbook.cell(line, 'D')]
    cur_carpet = carpets[workbook.cell(line, 'D')]
  else
    cur_carpet = new_carpet.clone
    cur_carpet[:styles] = []
    cur_carpet[:colors] = []
    cur_carpet[:name] = workbook.cell(line, 'D')
    cur_carpet[:warranty] = "Fabrica provides a two-year limited repair or replacement warranty. Fabrica warrants (to the original purchaser) that its carpets and rugs will be free from defects for a period of two (2) years from the date of delivery to the original seller."
    cur_carpet[:details] = ""
    cur_carpet[:brand_name] = workbook.cell(line, 'B')
    cur_carpet[:room_image_url] = workbook.cell(line, 'Q')
    cur_carpet[:fiber_name] = workbook.cell(line, 'L')
    cur_carpet[:texture_name] = workbook.cell(line, 'J')
  end

  if not cur_carpet[:styles].include?({:style_name => workbook.cell(line, 'K')})
    cur_carpet[:styles] << {
      :style_name => workbook.cell(line, 'K')
    }
  end

  if not cur_carpet[:colors].include?({
    :color_name => workbook.cell(line, 'G'),
    :color_category => "Fabrica Custom",
    :color_image_url => workbook.cell(line, 'R')
  })
    cur_carpet[:colors] << {
      :color_name => workbook.cell(line, 'G'),
      :color_category => "Fabrica Custom",
      :color_image_url => workbook.cell(line, 'R')
    }
  end

  carpets[workbook.cell(line, 'D')] = cur_carpet
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

