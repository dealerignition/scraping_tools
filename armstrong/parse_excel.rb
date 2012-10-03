require 'rubygems'
require 'roo'

floors = {}

cur_floor = nil
new_floor = {:name => "", :details => "", :warranty => "", :brand_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => "" }

workbook = Excel.new("vinyl_consolidated.xls")
workbook.default_sheet = workbook.sheets.first

16.upto(workbook.last_row) do |line|
  if floors[workbook.cell(line, 'M')]
    cur_floor = floors[workbook.cell(line, 'M')]
  else
    cur_floor = new_floor.clone
    cur_floor[:styles] = []
    cur_floor[:colors] = []
    cur_floor[:name] = workbook.cell(line, 'M')
  end

  cur_floor[:warranty] = workbook.cell(line, 'Z')
  cur_floor[:brand_name] = workbook.cell(line, 'B')
  cur_floor[:room_image_url] = "scene7:///" + workbook.cell(line, 'J')

  if not cur_floor[:styles].include?({:style_name => "Vinyl"})
    cur_floor[:styles] << {
      :style_name => "Vinyl"
    }
  end

  if not cur_floor[:colors].include?({
    :color_name => workbook.cell(line, 'O'),
    :color_category => workbook.cell(line, 'E'),
    :color_image_url => "scene7:///" + workbook.cell(line, 'I')
  })
    cur_floor[:colors] << {
      :color_name => workbook.cell(line, 'O'),
      :color_category => workbook.cell(line, 'E'),
      :color_image_url => "scene7:///" + workbook.cell(line, 'I')
    }
  end

  floors[workbook.cell(line, 'M')] = cur_floor
end

workbook = Excelx.new("laminate_consolidated.xlsx")
workbook.default_sheet = workbook.sheets.first

16.upto(workbook.last_row) do |line|
  if floors[workbook.cell(line, 'F')]
    cur_floor = floors[workbook.cell(line, 'F')]
  else
    cur_floor = new_floor.clone
    cur_floor[:styles] = []
    cur_floor[:colors] = []
    cur_floor[:name] = workbook.cell(line, 'F')
  end

  cur_floor[:warranty] = workbook.cell(line, 'Y')
  cur_floor[:brand_name] = workbook.cell(line, 'B')
  cur_floor[:room_image_url] = "scene7:///" + workbook.cell(line, 'I')

  if not cur_floor[:styles].include?({:style_name => "Laminate"})
    cur_floor[:styles] << {
      :style_name => "Laminate"
    }
  end

  if not cur_floor[:colors].include?({
    :color_name => workbook.cell(line, 'M'),
    :color_category => workbook.cell(line, 'D'),
    :color_image_url => "scene7:///" + workbook.cell(line, 'H')
  })
    cur_floor[:colors] << {
      :color_name => workbook.cell(line, 'M'),
      :color_category => workbook.cell(line, 'D'),
      :color_image_url => "scene7:///" + workbook.cell(line, 'H')
    }
  end

  floors[workbook.cell(line, 'F')] = cur_floor
end

workbook = Excelx.new("wood_consolidated.xlsx")
workbook.default_sheet = workbook.sheets.first

15.upto(workbook.last_row) do |line|
  if floors[workbook.cell(line, 'S')]
    cur_floor = floors[workbook.cell(line, 'S')]
  else
    cur_floor = new_floor.clone
    cur_floor[:styles] = []
    cur_floor[:colors] = []
    cur_floor[:name] = workbook.cell(line, 'S')
  end

  cur_floor[:warranty] = workbook.cell(line, 'AF')
  cur_floor[:brand_name] = workbook.cell(line, 'B')
  cur_floor[:room_image_url] = "scene7:///" + workbook.cell(line, 'N')

  if not cur_floor[:styles].include?({:style_name => "Wood"})
    cur_floor[:styles] << {
      :style_name => "Wood"
    }
  end

  if not cur_floor[:colors].include?({
    :color_name => workbook.cell(line, 'D'),
    :color_category => workbook.cell(line, 'E'),
    :color_image_url => "scene7:///" + workbook.cell(line, 'M')
  })
    cur_floor[:colors] << {
      :color_name => workbook.cell(line, 'D'),
      :color_category => workbook.cell(line, 'E'),
      :color_image_url => "scene7:///" + workbook.cell(line, 'M')
    }
  end

  floors[workbook.cell(line, 'S')] = cur_floor
end

i = 1
floors.each_key do |key|
  puts "#{i}\t#{floors[key][:name]}\t#{floors[key][:details]}\t#{floors[key][:warranty]}\t#{floors[key][:brand_name]}\t#{floors[key][:room_image_url]}"
  i = i + 1
end

i = 1
floors.each_key do |key|
  floors[key][:styles].each do |style|
    puts "#{i}\t#{style[:style_name]}"
  end
  i = i + 1
end

i = 1
floors.each_key do |key|
  floors[key][:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_category]}\t#{color[:color_image_url]}\t"
  end
  i = i + 1
end

