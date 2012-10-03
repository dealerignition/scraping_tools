# -*- coding: utf-8 -*-
require 'rubygems'
require 'roo'
require 'iconv'

workbook = Excel.new("untitled.xls")
workbook.default_sheet = workbook.sheets.first

holders = {}

zoroufy_folder_map = {
                      "Legacy" => "Legacy WH",
                      "Regency" => "Regency WH",
                      "Sovereign" => "Sovereign",
                      "Stair Jewel" => "Stair Jewel",
                      "Grand Dynasty" => "Grand Dynasty",
                      "Inspiration" => "Select",
                      "Select" => "Select",
                      "Heritage" => "Heritage",
                      "Grand Regency" => "Grand Regency WH",
                      "Dynasty" => "Dynasty",
                      "Classic" => "Classic WH"
                     }

finial_map = {
              "Pineapple" => "Pine",
              "Pyramid" => "{Pyramid.Pyr}",
              "Round" => "{Round,Rnd}",
              "Urn" => "Urn",
              "Acorn" => "{Acorn,Acn}",
              "Crown" => "{Crown,Crn}",
              "Ball" => "Ball"
             }

cur_holder = nil
new_holder = {:name => "", :brand_name => "", :details => "", :warranty => "", :styles => [], :colors => []}
new_style = {:style_name => ""}
new_color = {:finial_name => "", :finish => "", :finial_image_url => "", :rod_type => ""}

3.upto(workbook.last_row) do |line|
  temp_name = workbook.cell(line, 'B') 
  rod_type = ""
  finial_name = workbook.cell(line, 'B').include?("Finials") ? workbook.cell(line, 'B').scan(/([^ ]*) Finials/)[0][0] : "Addon Set"

  if temp_name
  if temp_name.include?(" Collection ")
    temp_name = "#{temp_name.scan(/" (.*) Collection/)[0][0]}"
  else
    temp_name = "#{temp_name.scan(/" (.*) Set/)[0][0]}"
  end

  if temp_name.include?(" Roped ")
    rod_type = "Roped"
    temp_name = "#{temp_name.scan(/(.*) Roped/)[0][0]}"
  elsif temp_name.include?(" Fluted ")
    rod_type = "Fluted"
    temp_name = "#{temp_name.scan(/(.*) Fluted/)[0][0]}"
  elsif temp_name.include?(" Smooth ")
    rod_type = "Smth"
    temp_name = "#{temp_name.scan(/(.*) Smooth/)[0][0]}"
  elsif temp_name.include?(" Tubular ")
    temp_name = "#{temp_name.scan(/(.*) Tubular/)[0][0]}"
  end

  if temp_name.include?(" Solid")
    temp_name = "#{temp_name.scan(/(.*) Solid/)[0][0]}"
  elsif temp_name.include?(" Tubular")
    temp_name = "#{temp_name.scan(/(.*) Tubular/)[0][0]}"
  end

  if temp_name.include?("®")
    temp_name = "#{temp_name.scan(/(.*)®/)[0][0]}"
  elsif temp_name.include?("™")
    temp_name = "#{temp_name.scan(/(.*)™/)[0][0]}"
  end

  if holders[temp_name]
    cur_holder = holders[temp_name]
  else
    cur_holder = new_holder.clone
    cur_holder[:styles] = []
    cur_holder[:colors] = []
    cur_holder[:name] = temp_name

    details = workbook.cell(line, 'Y')
    details = details.gsub("®", "")
    details = details.gsub("™", "")
    
    cur_holder[:brand_name] = "Zoroufy"
    cur_holder[:details] = details

    room_image_url = ""

    room_image_url = Dir.glob("Installation Staircase Images/#{zoroufy_folder_map[temp_name]}/*#{finial_map[finial_name]}*")[0]
    room_image_url = Dir.glob("Installation Staircase Images/#{zoroufy_folder_map[temp_name]}/**")[0] if not room_image_url

    if not cur_holder[:room_image_url]
      cur_holder[:room_image_url] = ("http://zoroufy.s3.amazonaws.com/" + room_image_url) if room_image_url
    end
  end

  if not cur_holder[:styles].include?({:style_name => workbook.cell(line, 'J')})
    cur_holder[:styles] << {
      :style_name => workbook.cell(line, 'J')
    }
  end

  finial_image = ""
  finish = workbook.cell(line, 'H')
  caps = finish.scan(/([A-Z])/).inject("") { |x,y| x += y[0] }

  finial_image = Dir.glob("Zoroufy Product Images/#{zoroufy_folder_map[temp_name]}/#{caps}/*#{finial_map[finial_name]}*")[0]
  finial_image = Dir.glob("Zoroufy Product Images/#{zoroufy_folder_map[temp_name]}/#{caps}/**")[0] if not finial_image
  finial_image = "" if not finial_image

  if not cur_holder[:colors].include?({
    :finial_name => finial_name,
    :finish => finish,
    :rod_type => rod_type,
    :finial_image_url => "http://zoroufy.s3.amazonaws.com/" + finial_image
  })
    cur_holder[:colors] << {
      :finial_name => finial_name,
      :finish => finish,
      :rod_type => rod_type,
      :finial_image_url => "http://zoroufy.s3.amazonaws.com/" + finial_image
    }
  end

  holders[temp_name] = cur_holder
  end
end


i = 1
holders.each_key do |key|
  puts "#{holders[key][:brand_name]}\t#{i}\t#{holders[key][:name]}\t#{holders[key][:details]}\t#{holders[key][:room_image_url].gsub(" ","%20") if holders[key][:room_image_url]}\t#{holders[key][:warranty]}"
  i = i + 1
end

i = 1
holders.each_key do |key|
  holders[key][:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
holders.each_key do |key|
  holders[key][:colors].each do |color|
    puts "#{i}\t#{color[:finial_name]}\t#{color[:finial_image_url].gsub(" ","%20") if color[:finial_image_url]}\t#{color[:rod_type]}\t#{color[:finish]}"
  end
  i = i + 1
end

