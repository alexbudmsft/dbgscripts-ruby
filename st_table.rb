require_relative 'config'
require_relative 'rubyval'

ST_TABLE_TYPE = "#{RUBYMOD}!st_table"
tbl = DbgScript.create_typed_object(ST_TABLE_TYPE, 0x000000000464b040)
num_bins = tbl.num_bins.value

if tbl.entries_packed.value != 0
  raise NotImplementedError
end

for i in 0...num_bins
  bin = tbl.as.big.bins[i]
  entry = bin
  while entry.value != 0
    puts DbgScript.read_string(entry.key.value)
    rec_val = entry.record.value
    rbval = RubyVal.new(rec_val)
    val = rbval.value
    puts "Raw VALUE: #{rec_val}, Type: #{rbval.type}, Value: #{val}"
    if val.class == RArray
      puts "Array"
      puts val.to_a
    end
    entry = entry.next
  end
end
