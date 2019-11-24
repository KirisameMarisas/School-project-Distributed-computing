
require "time"

$sum = 0

MIN = 60
HOUR = 60 * MIN

fp_input = nil
fp_names = Dir::entries(Dir::pwd)

$mutex_hash = Mutex.new
$mutex_sum = Mutex.new

$mutex_test = Mutex.new

fp_names.delete(".")
fp_names.delete("..")
fp_names.delete("cars2.txt")
fp_names.delete("test.rb")
fp_names.delete("log.txt")
fp_names.delete("testLog.txt")
fp_names.delete("Parking.rb")

$fp_log = File.open("log.txt", "w")
$car_hash = {}
#month hash
$month_hash = {}

@fp_test_log = File.open("testLog.txt", "w")
temp_time ||= Time.now

def calculate_cost(time_cost)
  if time_cost <= (30 * MIN)
    return 0
  end

  if time_cost <= (2 * HOUR)
    return 10
  end

  temp_more = time_cost - 2 * HOUR
  temp_more = temp_more.to_i
  temp_hour = temp_more / HOUR + temp_more % HOUR
  return 10 + (temp_hour * 2)
end

def split_time(array1, array2)
  #puts array1.inspect
  #puts array2.inspect
  if array1 == nil
    return 0
  end

  if array2 == nil
    return 0
  end

  time1 = get_time(array1)
  time2 = get_time(array2)

  return calculate_cost([time1, time2].max - [time1, time2].min)
end

def get_time(array)
  time = array[0] + " " + array[1]
  time = Time.parse(time)
  return time
end

def get_time_to_s(array)
  temp = get_time(array)
  #puts temp.inspect
  time = temp.year.to_s + " " + temp.month.to_s
  #puts time.inspect
  return time
end

def calculate_time(array1, array2)
  io1 = array1[array1.length - 1]
  io2 = array2[array2.length - 1]

  if io1 == "out"
    return get_time_to_s(array1)
  end

  if io2 == "out"
    return get_time_to_s(array2)
  end

  return nil
end

def solve_file(file_name)
  if file_name == nil
    return
  end

  temp_fp_input = File.open(file_name, "r")
  if temp_fp_input == nil
    return
  end

  now ||= Time.now
  sum = 0
  temp_hash = {}
  temp_fp_input.each do |each_line|
    each_line = each_line.split(%r[\s|,])
    if each_line[2] == "201430320216"
      if temp_hash.include?(each_line[3])
        sum += split_time(temp_hash[each_line[3]], each_line)
      else
        temp_hash[each_line[3]] = each_line
      end
    end
  end

  temp_hash.each do |each_key, each_value|
    if $car_hash.include?(each_key)
      current = calculate_time($car_hash[each_key], each_value)

      if $month_hash.include?(current)
        $mutex_sum.lock
        $month_hash[current] += split_time($car_hash[each_key], each_value)
        $mutex_sum.unlock
      else
        $mutex_sum.lock
        $month_hash[current] = 0
        $mutex_sum.unlock
      end

      $mutex_hash.lock
      $car_hash.delete(each_key)
      $mutex_hash.unlock
    else
      $mutex_hash.lock
      $car_hash[each_key] = each_value
      $mutex_hash.unlock
    end
  end

  current = nil
  temp_fp_input = File.open(file_name, "r")
  if temp_fp_input == nil
    return
  end

  temp_fp_input.each do |each_line|
    each_line = each_line.split(%r[\s|,])
    #puts each_line.inspect
    if each_line == []
      next
    else
      current = get_time_to_s(each_line)
      break
    end
  end

  #puts current.inspect
  if $month_hash.include?(current)
    $mutex_sum.lock
    $month_hash[current] += sum
    $mutex_sum.unlock
  else
    $mutex_sum.lock
    $month_hash[current] = sum
    $mutex_sum.unlock
  end
end

i = 0
while i <= (fp_names.length - 1)
  thread1 = Thread.new { solve_file(fp_names[i]) }
  thread2 = Thread.new { solve_file(fp_names[i + 1]) }
  thread3 = Thread.new { solve_file(fp_names[i + 2]) }
  thread4 = Thread.new { solve_file(fp_names[i + 3]) }

  thread1.join
  thread2.join
  thread3.join
  thread4.join

  i += 4
  puts i.inspect
end

puts
puts $month_hash.inspect
#puts $temp_sum.inspect
#puts fp_names.length.inspect
puts "#{Time.now - temp_time}"
