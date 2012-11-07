require 'roo'
require 'iconv'
require 'json'

warranties =
{
 "Lifelong" => "
<h3>LIFELONG LIMITED WARRANTY</h3>

<table>
<tr><td>The Lifelong Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>Lifelong</td></tr>
<tr><td>will be free of manufacturing defects</td><td>Lifelong</td></tr>
<tr><td>will not fade</td><td>Lifelong</td></tr>
<tr><td>will not stain</td><td>Lifelong</td></tr>
</table>

DuraCeramic and DuraPlank II featuring Scotchgard Protector provides these additional warranty provisions:
<table>
<tr><td>will be easy to clean</td><td>15 Years</td></tr>
<tr><td>will repel dirt and grime</td><td>15 Years</td></tr>
</table>

The Lifelong Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "Five Star" => "
<h3>FIVE-STAR LIMITED WARRANTY<h3>

<table>
<tr><td>The Five-Star Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>Lifelong</td></tr>
<tr><td>will be free of manufacturing defects</td><td>Lifelong</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household items</td><td>25 Years</td></tr>
<tr><td>will not permanently scuff from shoe soles, including sneakers</td><td>25 Years</td></tr>
<tr><td>will not fade or discolor from heat or sunlight</td><td>25 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>25 Years</td></tr>
<tr><td>will not gouge, rip or tear from normal use</td><td>25 Years</td></tr>
<tr><td>will not permanently indent when proper floor protectors are used</td><td>25 Years</td></tr>
</table>

Ultima featuring Scotchgard Protector provides these additional warranty provisions:
<table>
<tr><td>will be easy to clean</td><td>15 Years</td></tr>
<tr><td>will repel dirt and grime</td><td>15 Years</td></tr>
</table>

The Five-Star Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "Four Star" => "
FOUR-STAR LIMITED WARRANTY

<table>
<tr><td>The Four-Star Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>Lifelong</td></tr>
<tr><td>will be free of manufacturing defects</td><td>Lifelong</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household item</td><td>10 Years</td></tr>
<tr><td>will not gouge, rip, tear or indent from normal use</td><td>10 Years</td></tr>
<tr><td>will not permanently scuff from shoe soles, including sneakers</td><td>10 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>10 Years</td></tr>
</table>

The Four-Star Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "Three Star" => "
THREE-STAR LIMITED WARRANTY

<table>
<tr><td>The Three-Star Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>12 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>12 Years</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household items</td><td>10 Years</td></tr>
<tr><td>will not gouge, rip, tear or indent from normal use</td><td>10 Years</td></tr>
<tr><td>will not permanently scuff from shoe soles, including sneakers</td><td>10 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>10 Years</td></tr>
</table>

The Three-Star Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "Two Star" => "
TWO-STAR LIMITED WARRANTY

<table>
<tr><td>The Two-Star Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>10 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>10 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>5 Years</td></tr>
</table>

The Two-Star Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "One Star" => "
ONE-STAR LIMITED WARRANTY

<table>
<tr><td>The One-Star Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will be free of manufacturing defects</td><td>5 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>5 Years</td></tr>
</table>

In addition, Prelude with its ArmorGuard Protection is covered for five years for the following:
<table>
<tr><td>will not wear out</td><td>5 Years</td></tr>
<tr><td>will not gouge, rip, tear or indent from normal use</td><td>5 Years</td></tr>
<tr><td>will not stain from asphalt tracking</td><td>5 Years</td></tr>
</table>

The One-Star Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for years one through three if professional installation was paid for when the original floor was installed. After three years and through five years, the warranty covers material only; labor will not be paid.",
 "1-Year Residential" => "
1-YEAR RESIDENTIAL LIMITED WARRANTY

<table>
<tr><td>The 1-Year Residential Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will be free of manufacturing defects</td><td>1 Year</td></tr>
</table>

The 1-Year Residential Limited Warranty provision covers material only for the period of the warranty; labor will not be paid.",
 "20-Year" => "
20-YEAR RESIDENTIAL LIMITED WARRANTY

<table>
<tr><td>The 20-Year Residential Limited Warranty provides that your floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>20 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>20 Years</td></tr>
<tr><td>will not fade</td><td>20 Years</td></tr>
<tr><td>will not stain</td><td>20 Years</td></tr>
</table>

The 20-Year Residential Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "25-Year Residential" => "
25-YEAR RESIDENTIAL LIMITED WARRANTY

<table>
<tr><td>The 25-Year Residential Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>25 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>25 Years</td></tr>
<tr><td>will not fade</td><td>25 Years</td></tr>
<tr><td>will not stain</td><td>25 Years</td></tr>
</table>

The 25-Year Residential Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "AirStep 20-Year" => "
AIRSTEP 20-YEAR LIMITED WARRANTY

<table>
<tr><td>The AirStep 20-Year Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>20 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>20 Years</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household items</td><td>20 Years</td></tr>
<tr><td>will not permanently scuff from shoe soles including sneaker</td><td>20 Years</td></tr>
<tr><td>will not fade or discolor from heat or sunlight</td><td>20 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>20 Years</td></tr>
<tr><td>will not gouge, rip or tear from normal use</td><td>20 Years</td></tr>
<tr><td>will not permanently indent when proper floor protectors are used</td><td>20 Years</td></tr>
</table>

AirStep Plus featuring Scotchgard Protector provides these additional warranty provisions which mean that your new floor:
<table>
<tr><td>will be easy to clean</td><td>15 Years</td></tr>
<tr><td>will repel dirt and grime</td><td>15 Years</td></tr>
</table>

Correct installation practices must be followed to ensure a trouble-free installation. While installation errors are the responsibility of your flooring installer and not covered by Congoleum's warranty, if the flooring is correctly installed following all guidelines in the AirStep installation instructions, your AirStep Plus floor will be warranted:
<table>
<tr><td>1. not to curl</td><td>20 Years</td></tr>
<tr><td>2. not to open at seams</td><td>20 Years</td></tr>
<tr><td>3. not to buckle</td><td>20 Years</td></tr>
<tr><td>4. not to release over joints in underlayment panels</td><td>20 Years</td></tr>
</table>

The conditions 1, 2, 3, and 4 above will be warranted as long as the flooring is installed in an occupied residence that maintains a temperature range of 55 to 100 F. Any of the above conditions will not be covered if caused by job site environmental conditions in new construction or renovation work.

The AirStep 20-Year Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "AirStep 10-Year" => "
AIRSTEP 10-YEAR LIMITED WARRANTY

<table>
<tr><td>The AirStep 10-Year Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>10 Years</td></tr>
<tr><td>will be free of manufacturing defects</td><td>10 Years</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household items</td><td>10 Years</td></tr>
<tr><td>will not permanently scuff from shoe soles including sneaker</td><td>10 Years</td></tr>
<tr><td>will not fade or discolor from heat or sunlight</td><td>10 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>10 Years</td></tr>
<tr><td>will not gouge, rip or tear from normal use</td><td>10 Years</td></tr>
<tr><td>will not permanently indent when proper floor protectors are used</td><td>10 Years</td></tr>
</table>

Correct installation practices must be followed to ensure a trouble-free installation. While installation errors are the responsibility of your flooring installer and not covered by Congoleum's warranty, if the flooring is correctly installed following all guidelines in the AirStep installation instructions, your AirStep Basix floor will be warranted:
<table>
<tr><td>1. not to curl</td><td>10 Years</td></tr>
<tr><td>2. not to open at seams</td><td>10 Years</td></tr>
<tr><td>3. not to buckle</td><td>10 Years</td></tr>
<tr><td>4. not to release over joints in underlayment panels</td><td>10 Years</td></tr>
</table>

The conditions 1, 2, 3, and 4 above will be warranted as long as the flooring is installed in an occupied residence that maintains a temperature range of 55 to 100 F. Any of the above conditions will not be covered if caused by job site environmental conditions in new construction or renovation work.

The AirStep 10-Year Limited Warranty provision covers material for the period of the warranty and reasonable labor costs during years one through two if professional installation was paid for when the original floor was installed. For years three through five, the warranty covers material and 50% of reasonable labor costs if professional installation was paid for when the original floor was installed. After the fifth year, the warranty covers material only; labor will not be paid.",
 "AirStep Lifelong" => "
AIRSTEP LIFELONG LIMITED WARRANTYON

<table>
<tr><td>The AirStep Lifelong Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will not wear out</td><td>Lifelong</td></tr>
<tr><td>will be free of manufacturing defects</td><td>Lifelong</td></tr>
<tr><td>will not stain including stains from asphalt tracking, rubber-backed mats and common household items</td><td>25 Year</td></tr>
<tr><td>will not permanently scuff from shoe soles including sneaker</td><td>25 Years</td></tr>
<tr><td>will not fade or discolor from heat or sunlight</td><td>25 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>25 Years</td></tr>
<tr><td>will not gouge, rip or tear from normal use</td><td>25 Years</td></tr>
<tr><td>will not permanently indent when proper floor protectors are used</td><td>25 Years</td></tr>
</table>

AirStep Evolution featuring Scotchgard Protector provides these additional warranty provisions which mean that your new floor:
<table>
<tr><td>will be easy to clean</td><td>15 Years</td></tr>
<tr><td>will repel dirt and grime</td><td>15 Years</td></tr>
</table>

Correct installation practices must be followed to ensure a trouble-free installation. While installation errors are the responsibility of your flooring installer and not covered by Congoleum's warranty, if the flooring is correctly installed following all guidelines in the AirStep installation instructions, your AirStep Evolution floor will be warranted:
<table>
<tr><td>1. not to curl</td><td>20 Years</td></tr>
<tr><td>2. not to open at seams</td><td>20 Years</td></tr>
<tr><td>3. not to buckle</td><td>20 Years</td></tr>
<tr><td>4. not to release over joints in underlayment panels</td><td>20 Years</td></tr>
</table>

The conditions 1, 2, 3, and 4 above will be warranted as long as the flooring is installed in an occupied residence that maintains a temperature range of 55 to 100 F. Any of the above conditions will not be covered if caused by job site environmental conditions in new construction or renovation work.

The AirStep Lifelong Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "10-Year" => "
10-YEAR RESIDENTIAL LIMITED WARRANTY

<table>
<tr><td>The 10-Year Residential Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will be free of manufacturing defects</td><td>10 Years</td></tr>
<tr><td>will not wear out</td><td>10 Years</td></tr>
</table>

The 10-Year Residential Limited Warranty provision covers material for the period of the warranty and reasonable labor costs for five years if professional installation was paid for when the original floor was installed.",
 "5-Year Residential" => "
FIVE-YEAR COMMERCIAL LIMITED WARRANTY

<table>
<tr><td>The Five-Year Commercial Limited Warranty means that your new floor:</td><td>Warranty Period</td></tr>
<tr><td>will be free of manufacturing defects</td><td>5 Years</td></tr>
<tr><td>will not discolor from mold, mildew or alkali</td><td>5 Years</td></tr>
</table>

The Five-Year Commercial Limited Warranty provision covers material for the warranty period and reasonable labor costs during year one if professional installation was paid for when the original floor was installed. For years two through three, the warranty covers material and 50% of reasonable labor costs if professional installation was paid for when the original floor was installed. After the third year, covers material only; labor will not be paid.
"
}


@floors = {}
@style = ""

@cur_floor = nil
@new_floor = {:name => "", :details => "", :warranty => "", :brand_name => "", :room_image_url => "", :colors => [], :styles => []}
@new_style = {:style_name => ""}
@new_color = {:color_name => "", :color_category => "", :color_image_url => "" }

workbook = Excel.new("floors.xls")
workbook.default_sheet = workbook.sheets.first

2.upto(workbook.last_row) do |line|
  if @floors[workbook.cell(line, 'E')]
    @cur_floor = @floors[workbook.cell(line, 'E')]
  else
    @cur_floor = @new_floor.clone
    @cur_floor[:styles] = []
    @cur_floor[:colors] = []
    @cur_floor[:name] = workbook.cell(line, 'E')
  end

  @cur_floor[:warranty] = "\"#{warranties[workbook.cell(line, 'T')]}\""
  @cur_floor[:brand_name] = workbook.cell(line, 'D')
  @cur_floor[:room_image_url] = ""

  if not @cur_floor[:styles].include?({:style_name => workbook.cell(line, 'A')})
    @cur_floor[:styles] << {
                            :style_name => workbook.cell(line, 'A')
                           }
  end

  file = ""
  type = ""
  begin
  workbook.cell(line, 'G').floor
  type = workbook.cell(line, 'G').to_i
  file = Dir.glob("2013 Chips/**/**/*#{type}*")[0]
  rescue
  type = workbook.cell(line, 'G')
  file = Dir.glob("2013 Chips/**/**/*#{workbook.cell(line, 'G')}*")[0]
  end

  puts type
  puts file

  if file 
    if not @cur_floor[:colors].include?({
                                         :color_name => workbook.cell(line, 'F'),
                                         :color_category => workbook.cell(line, 'L'),
                                         :color_image_url => "http://congoleum.s3.amazonaws.com/" + file.gsub(" ", "%20")
                                        })
      @cur_floor[:colors] << {
                              :color_name => workbook.cell(line, 'F'),
                              :color_category => workbook.cell(line, 'L'),
                              :color_image_url => "http://congoleum.s3.amazonaws.com/" + file.gsub(" ", "%20")
                             }
    end
  end

  @floors[workbook.cell(line, 'E')] = @cur_floor
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
