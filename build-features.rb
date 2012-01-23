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
MAX = closes.max

#closes = closes.map{|x| x - MIN }
# closes = closes.map{|x| (x - MIN) / 256  } # This seems to be much better, but does it make sense?
#closes = closes.map{|x| (x / MAX.to_f) * 256 } 
#closes = closes.map{|x| (x / MAX.to_f) * 256 } 

MIN = closes.min
puts MIN
MAX = closes.max
puts MAX
BANDS = 9
STEP = (MAX - MIN) / BANDS # band size
puts STEP
HISTORY = 5

#puts closes.inspect

features = {}
cow = []

closes.each_with_index do |x, idx|
  e = idx + HISTORY # val to end at

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

def map_val(val, prev = nil)
  if prev
    if val > prev
      1 # stocks went up
    else
      2 # stocks went down
    end
  else
    3 # should never see this
  end
  
  
end
# def map_val(val)
#   case val.to_i
#   when 0..7200
#     1
#   when 7200..7900
#     2
#   when 7900..8600
#     3
#   when 8600..9300
#     4
#   when 9300..10000
#     5
#   when 10000..10700
#     6
#   when 10700..11400
#     7
#   when 11400..12100
#     8
#   when 12100..12800
#     9
#   when 12800..14000
#     10
#   else
#     0
#   end
# end

length = cow.size
twenty = (length * 0.2).to_i
forty  = twenty * 2
sixty = forty + twenty
eighty = forty + forty

train = cow[0..sixty]
validation = cow[(sixty + 1)..eighty]
test = cow[(eighty + 1)..-1]

['train', 'validation', 'test'].each do |w|
  File.open("#{w}.txt", 'w+') do |f|
    (eval(w)).each do |line|
      f.write(line[1].join(' ')) # just the values
      f.write("\n")
    end
  end
  File.open("#{w}-ys.txt", 'w+') do |f|
    (eval(w)).each do |line|
      f.write(map_val(line[2], line[1][HISTORY])) # just the next day

#      f.write(map_val(line[2])) # just the next day
      f.write("\n")
    end
  end
end


File.open("features.txt", 'w+') do |f|
  cow.each do |line|
    f.write(line[1].join(' ')) # just the values
    f.write("\n")
  end
end

File.open('classifications.txt', 'w+') do |f|
  cow.each_with_index do |line, idx|

      # f.write(line[2])    
      # f.write " "
      # f.write  line[1][HISTORY]
      # f.write " "      
      f.write(map_val(line[2], line[1][HISTORY])) # just the next day
      f.write("\n")      


  end
end







