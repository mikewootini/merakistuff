#!/usr/bin/env ruby

options = {
  count: 10
}

lines = `grep '^Swap' /proc/*/smaps 2>/dev/null`.split("\n")
pid2swap = {}

puts "Swap space   PID   Process"
puts "==========  =====  ======="
lines.each do |line|
  
## original line
##  if !line.match(//proc/(\d\+)/smaps:Swap:\s*(\d\+) kB/)
##  need forward slashes, fix the + as well
## 
## used https://rubular.com/ to troubleshoot I also don't think this line does
## what is expected as it shows every line 
  if !line.match(/\/proc\/(\d\+)\/smaps:Swap:\s*(\d\+) kB/)
## This line makes things very noisy so removing.     
##    puts "Bad line: " + line
    next
  end
  pid, kb = $1, $2
  pid2swap[pid] = pid2swap[pid].to_i + kb.to_i
end

pid2swap.sort {|a,b| -a[1] <=> -b[1] }.slice(0...options[:count]).each do |pid, kb|
## Something is wrong with this ps statement - the -o option columns are the key
  psout = `ps -p #{pid} -o args=`.strip
  if psout.empty?
    printf "%s kB (no longer running)\n", kb
  else
    printf "%s kB %s %s\n", kb, pid, psout
  end
end
