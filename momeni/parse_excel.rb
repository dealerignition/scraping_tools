require 'rubygems'
require 'roo'
require 'iconv'

workbook = Excel.new("momeni.xls")
workbook.default_sheet = workbook.sheets.first

@rugs = {}
@style = ""

@cur_rug = nil
@new_rug = {:name => "", :details => "", :warranty => "", :room_image_url => "", :colors => [], :styles => [], :shapes => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }
@new_shape = {:shape_name => "", :height => "", :width => "", :shape_image_url => "" }

14.upto(workbook.last_row) do |line|
  name = workbook.cell(line, 'G')

  if @rugs[name]
    @cur_rug = @rugs[name]
  else
    @cur_rug = @new_rug.clone
    @cur_rug[:styles] = []
    @cur_rug[:colors] = []
    @cur_rug[:shapes] = []
    @cur_rug[:name] = name
    @cur_rug[:warranty] = "1 Year"
    @cur_rug[:details] = workbook.cell(line, 'H') + (workbook.cell(line, 'I') ? workbook.cell(line, 'I') : "")
    begin
      @cur_rug[:room_image_url] = "http://momeni.s3.amazonaws.com/" + Dir.glob("ROOM SHOTS/#{workbook.cell(line, 'J')}*")[0]
    rescue
      # no room image found
      @cur_rug[:room_image_url] = ""
    end
  end
  
  if not @cur_rug[:styles].include?({:style_name => workbook.cell(line, 'E')})
    @cur_rug[:styles] << {
      :style_name => workbook.cell(line, 'E')
    }
  end

  if not @cur_rug[:colors].include?({
    :color_name => workbook.cell(line, 'K'),
    :color_category => "Momeni Custom",
    :color_image_url => ""
  })
    @cur_rug[:colors] << {
      :color_name => workbook.cell(line, 'K'),
      :color_category => "Momeni Custom",
      :color_image_url => ""
    }
  end
      
  begin
    image = "http://momeni.s3.amazonaws.com/"
    if (workbook.cell(line, 'O') ? workbook.cell(line, 'O') : "Rectangle") == "Round"
      image += Dir.glob("ROUNDS/#{workbook.cell(line, 'G').scan(/^([^ ]*)/)[0][0]}*/#{workbook.cell(line, 'D')}*")[0]
    elsif (workbook.cell(line, 'O') ? workbook.cell(line, 'O') : "Rectangle") == "Runner"
      image += Dir.glob("RUNNERS/#{workbook.cell(line, 'G').scan(/^([^ ]*)/)[0][0]}*/#{workbook.cell(line, 'D')}*")[0]
    else
      image += Dir.glob("HIGHRES IMAGES/#{workbook.cell(line, 'G').scan(/^([^ ]*)/)[0][0]}*/#{workbook.cell(line, 'D')}*")[0]
    end

    if !@cur_rug.include?({
      :shape_name => (workbook.cell(line, 'O') ? workbook.cell(line, 'O') : "Rectangle"),
      :height => workbook.cell(line, 'T'),
      :width => workbook.cell(line, 'S'),
      :shape_image_url => image
    })
      @cur_rug[:shapes] << {
        :shape_name => (workbook.cell(line, 'O') ? workbook.cell(line, 'O') : "Rectangle"),
        :height => workbook.cell(line, 'T'),
        :width => workbook.cell(line, 'S'),
        :shape_image_url => image
      }
    end
  rescue
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
