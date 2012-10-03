=begin
require 'rubygems'
require 'parseexcel'
require 'facets/string/titlecase'

workbook = Spreadsheet::ParseExcel.parse('product names colors total.xls')
worksheet = workbook.worksheet(0)

carpets = []

cur_carpet = {:colors => []}
new_carpet = {:name => "", :details => "", :warranty => "", :fiber_type => "", :texture_type => "", :brand_name => "", :room_image_url => "", :colors => [], :styles => []}
new_style = {:style_name => ""}
new_color = {:color_name => "", :color_category => "", :color_image_url => "", :high_res_color_image_url => ""}

worksheet.each(439) do |row|
  #if row and row[0] and row[0].to_s('latin1') == "Style Name:"
  #  puts "found carpet"
  #  if cur_carpet != nil
  #    cur_carpet[:texture_type] = cur_carpet[:styles] != [] ? cur_carpet[:styles][0][:style_name] : "---"#

  #    carpets << cur_carpet
  #  end
  #  cur_carpet = new_carpet.clone
  #  cur_carpet[:colors] = []
  #  cur_carpet[:styles] = []

  #  cur_carpet[:name] = row[1].to_s('latin1').titlecase
  #end
  #if cur_carpet and row and row[3]
  #  puts "found style"
  #  cur_style = new_style.clone
  #  cur_style[:style_name] = row[3].to_s('latin1').titlecase
  #  cur_carpet[:styles] << cur_style
  #end
  if cur_carpet and row and row[1] and row[2]
    puts "found color row"
    i = 7
    while i <= 24
      if row[i]
        cur_color = new_color.clone
        cur_color[:color_name] = row[2].to_s('latin1').titlecase
        if row[i].to_s('latin1').titlecase != "Yes"
          cur_color[:color_category] = row[i].to_s('latin1').titlecase
        else
          cur_color[:color_category] = worksheet.row(3).at(i).to_s('latin1').titlecase
        end
       
        cur_carpet[:colors] << cur_color
      end
      i = i + 1
    end
  end
end

carpets << cur_carpet

#i = 1
#carpets.each do |carpet|
#  puts "#{i}\t#{carpet[:name]}\t\t\t\t#{carpet[:texture_type]}\t\t"
#  i = i + 1
#end

i = 43
carpets.each do |carpet|
  carpet[:colors].each do |color|
    puts "#{i}\t#{color[:color_name]}\t#{color[:color_category]}\t\t"
  end
  i = i + 1
end

#i = 1
#carpets.each do |carpet|
#  carpet[:styles].each do |style|
#    puts "#{i}\t#{style[:style_name]}"
#  end
#  i = i + 1
#end
=end
