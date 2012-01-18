require 'csv'

sectors_file = File.open(Rails.root + 'db/sectors_export.csv','r')

line_number = 1

puts "Creating sectors..."

CSV.foreach(sectors_file, col_sep: ",") do |row|
  if line_number != 1
    # name = row[1]
    name = row[1].gsub("'","-") # TODO cartodb client chokes when inserting strings with "'" ??
    sector_code = row[2]        # TODO integers are converted to floats after inserting them ??

    puts "#{sector_code} #{name}"
    CartoDB::Connection.insert_row 'sectors', name: name, sector_code: sector_code
  end

  line_number += 1
end

