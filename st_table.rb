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
    DbgScript.execute_command("da #{entry.key.value.to_s(16)}")
    entry = entry.next
  end
end
