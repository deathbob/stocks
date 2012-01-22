require 'csv'


#csv = CSV.read('dji2009.csv')
#csv = CSV.read('dji2010.csv')
csv = CSV.read('dji2011.csv')

csv = csv.reverse # most recent date is at top, we want to build the features from oldest to newest
csv.pop# pop header line
#closes = csv.map{|x| [x[0], x[-1]]} # all we're interested in is the date and the closing value.
closes = csv.map{|x| x[-1]} # all we're interested in is the date and the closing value.
closes = closes.map{|x| x.to_i}
MIN = closes.min

#closes = closes.map{|x| x - MIN }
closes = closes.map{|x| x % 256 } # This seems to be much better, but does it make sense?

MIN = closes.min
MAX = closes.max
STEP = (MAX - MIN) / 11 # band size

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

File.open("features.txt", 'w+') do |f|
  cow.each do |line|
    f.write(line[1].join(' ')) # just the values
    f.write("\n")
  end
end

def map_val(val)
  foo = ((val.to_f - MIN) / STEP).to_i
  if foo == 0
#    return (MAX / STEP) 
    return 1 # lump the low end together.
  else
    foo
  end
end

File.open('classifications.txt', 'w+') do |f|
  cow.each do |line|
    f.write(map_val(line[2])) # just the next day
    f.write("\n")
  end
end











