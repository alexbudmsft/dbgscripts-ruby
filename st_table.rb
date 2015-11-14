require_relative 'rubyval'

MOD = "rubyprov_lockdown"
ST_TABLE_TYPE = "#{MOD}!st_table"
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
    val = entry.record.value
    rbval = RubyVal.new(val)
    puts "Raw VALUE: #{val}, Type: #{rbval.type}, Value: #{rbval.value}"
    entry = entry.next
  end
end
