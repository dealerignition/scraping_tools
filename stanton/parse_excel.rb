require 'rubygems'
require 'roo'
require 'iconv'
require 'facets/string/titlecase'

workbook = Excel.new("Prod Spec Listing.xls")
workbook.default_sheet = workbook.sheets.first

carpets = {}

cur_carpet = nil
new_carpet = {:name => "", :details => "", :warranty => "", :brand_name => "", :fiber_name => "", :texture_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => "",:high_resolution_carpet_image_url => ""}

3.upto(workbook.last_row) do |line|
  if carpets[workbook.cell(line, 'B')]
    cur_carpet = carpets[workbook.cell(line, 'B')]
  else
    cur_carpet = new_carpet.clone
    cur_carpet[:styles] = []
    cur_carpet[:colors] = []
    cur_carpet[:name] = workbook.cell(line, 'B').downcase.titlecase
    cur_carpet[:warranty] = ""
    cur_carpet[:details] = ""
    cur_carpet[:brand_name] = "Stanton"
    cur_carpet[:room_image_url] = ""
    cur_carpet[:fiber_name] = workbook.cell(line, 'O')
    cur_carpet[:texture_name] = "Stanton Custom"
  end

  if not cur_carpet[:styles].include?({:style_name => "Stanton Custom"})
    cur_carpet[:styles] << {
      :style_name => "Stanton Custom"
    }
  end

  if not cur_carpet[:colors].include?({
    :color_name => workbook.cell(line, 'D').downcase.titlecase,
    :color_category => "Stanton Custom",
    :color_image_url => Dir.glob("Images/#{workbook.cell(line, 'B').downcase.titlecase.gsub(" ", "")}*#{workbook.cell(line, 'D').downcase.titlecase.gsub(" ", "")}*")[0]
  })
    cur_carpet[:colors] << {
      :color_name => workbook.cell(line, 'D').downcase.titlecase,
      :color_category => "Stanton Custom",
      :color_image_url => Dir.glob("Images/#{workbook.cell(line, 'B').downcase.titlecase.gsub(" ", "")}*#{workbook.cell(line, 'D').downcase.titlecase.gsub(" ", "")}*")[0]
    }
  end

  carpets[workbook.cell(line, 'B')] = cur_carpet
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

