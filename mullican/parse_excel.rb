require 'roo'

@floors = {}
@style = ""

@cur_floor = nil
@new_floor = {:name => "", :details => "", :warranty => "", :brand_name => "", :room_image_url => "", :colors => [], :styles => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }

workbook = Excelx.new("floors.xlsx")
workbook.default_sheet = workbook.sheets.first

3.upto(workbook.last_row) do |line|
  if @floors[workbook.cell(line, 'D')]
    @cur_floor = @floors[workbook.cell(line, 'D')]
  else
    @cur_floor = @new_floor.clone
    @cur_floor[:styles] = []
    @cur_floor[:colors] = []
    @cur_floor[:name] = workbook.cell(line, 'D')
  end

  @cur_floor[:warranty] = "Mullican Flooring warrants that the products have been manufactured in compliance with the grading rules of Mullican Flooring, and will be free from manufacturing defects for as long as the original purchaser owns the floor. Manufacturing defects do not include natural wood characteristics such as mineral streaks, knots, grain variations, normal minor differences between color of samples and the color of installed floors, color variations from board to board, or minor width variation. Due to the nature of wide width plank (3 and wider), some minor width variation is to be expected and is not considered a defect."
  @cur_floor[:brand_name] = workbook.cell(line, 'A')
  @cur_floor[:room_image_url] = ""

  if not @cur_floor[:styles].include?({:style_name => workbook.cell(line, 'J')})
    @cur_floor[:styles] << {
      :style_name => workbook.cell(line, 'J')
    }
  end

  if workbook.cell(line, 'Z') != nil
    if not @cur_floor[:colors].include?({
      :color_name => workbook.cell(line, 'G'),
      :color_category => "Mannington Custom",
      :color_image_url => "http://mullican.s3.amazonaws.com/images/" + workbook.cell(line, 'Z')
    })
      @cur_floor[:colors] << {
        :color_name => workbook.cell(line, 'G'),
        :color_category => "Mannington Custom",
        :color_image_url => "http://mullican.s3.amazonaws.com/images/" + workbook.cell(line, 'Z')
      }
    end
  end

  @floors[workbook.cell(line, 'D')] = @cur_floor
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
