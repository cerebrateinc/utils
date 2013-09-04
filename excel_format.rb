require 'rubygems'
require 'roo'
require 'csv'

def is_valid_number?(num)
	begin
		Float(num)
		return true
	rescue
		return false
	end
end

file = ARGV[0]

unless File.exists?(file)
	puts "File not found!"
	exit(0)
end

spreadsheet = Roo::Excelx.new(file)
# spreadsheet.default_sheet = spreadsheet.sheets[1]

spreadsheet.default_sheet = spreadsheet.sheets[10]
csv_string = spreadsheet.to_csv


#lung_wt_spreadsheet = spreadsheet.to_csv
#puts lung_wt_spreadsheet.inspect
#exit

arr = CSV.parse(csv_string)

keys = arr[0]

lines = arr.map {|a| Hash[ keys.zip(a) ] }

records = []

# pivot_keys = ["Opening Balance", "Payments", "Receipts", "Closing Balance"]
# pivot_key_target = "Head"
# pivot_value_target = "Amount"
# copy_keys = ["Date", "Type", "GL", "BA", "description"]

#pivot_keys = ["day-1","day0","day1","day2","day3","day4","day5","day6","day7","day8","day9","day10","day11","day12","day13","day14"]
#pivot_key_target = "Day"
#pivot_value_target = "Weight"
#copy_keys = ["Trial","Group","Animal#"]

#target_file = "/tmp/A-063-13_body_weights.csv"

pivot_keys = ["Sriganganagar","Faridkot","Bhatinda","Abohar (Mahyco)","Hisar","Kanpur","Banswara","Surat","Talod","Rahuri","Nagpur (Ankur)","Bhawanipatna","Raichur","Siruguppa","Lam","Coimbatore","Srivilliputhur","B Gudi", "Kalakal (Nuziveedu)", "Nuziveedu (Prabhat)"]
pivot_key_target = "Location"
pivot_value_target = "Biological yield (t/ha)"
copy_keys = ["S. No.","Code No.","Entries"]
target_file = "/tmp/CICR_sheet10.csv"

lines.slice(1, lines.length - 1).each do |line|
	line.keys.each do |k|
		if(pivot_keys.include?(k))
			record = {}
			copy_keys.each do |ck|
				record[ck] = line[ck]
			end
			record[pivot_key_target] = k
			record[pivot_value_target] = line[k] #is_valid_number?(line[k]) ? line[k] : '-'
			records << record
		end
	end
end

target_keys = copy_keys.push(pivot_key_target)
target_keys = target_keys.push(pivot_value_target)

s = CSV.generate do |csv|
  csv << target_keys
  records.each do |x|
    csv << x.values
  end
end
File.write(target_file, s)



