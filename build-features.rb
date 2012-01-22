require 'csv'

csv = CSV.read('dji.csv')
csv = csv.reverse # most recent date is at top, we want to build the features from oldest to newest
csv.pop# pop header line
#closes = csv.map{|x| [x[0], x[-1]]} # all we're interested in is the date and the closing value.
closes = csv.map{|x| x[-1]} # all we're interested in is the date and the closing value.

#puts closes.inspect

features = {}
cow = []

closes.each_with_index do |x, idx|
  e = idx + 29 # val to end at

  date = csv[idx][0]
  feats = closes[idx..e]  
  next_day = closes[e+1]
  
  features[date] = {}
  features[date][:date] = date
  features[date][:features] = feats
  features[date][:y] = next_day
  
  cow << [date, feats, next_day]
  
  
  
end

# remove records without a next day value, can't train or check without that.
cow.reject!{|x| x[2].nil?}

#puts features.inspect
puts
puts cow.first.inspect, cow.last.inspect
puts


# puts features["2010-01-04"]
# puts
# puts features["2011-12-06"]
# 

File.open("output.txt", 'w+') do |f|
  cow.each do |line|
    f.write(line[0] + "\t" + line[1].join(' '))
    f.write("\n")
  end
end