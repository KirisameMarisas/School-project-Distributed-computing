
require "time"
require "thread"

NUMBERS = (1e6).to_i
MAX_NUMBER = (2 * 1e10).to_i
OFFSET = (1e3).to_i

#puts NUMBERS.inspect
#puts MAX_NUMBER.inspect

$mutex_queue = Mutex.new

$queue = Queue.new

producers = []
consumers = []

def produce
  for i in 1..NUMBERS
    #$mutex_queue.lock
    value = rand(OFFSET) + MAX_NUMBER
    $queue << value
    #puts value
    #$mutex_queue.unlock
  end
end

def judge(number)
  max = Math.sqrt(number).to_i
  flag = true
  for i in 2..max
    if (number % i == 0)
      flag = false
      break
    end
  end
  return flag
end

def consume
  while $queue.length > 0
    value = $queue.pop
    judge(value)
    #puts $queue.length
  end
end

start = Time.new

for i in 1..2
  producers << Thread.new do
    produce
  end
end

sleep 0.1

for i in 1..4
  consumers <<
    Thread.new do
      consume
    end
end

producers.each do |each_produce|
  each_produce.join
end

#puts $queue.length

consumers.each do |each_consumer|
  each_consumer.join
end

ended = Time.new

puts (ended - start).inspect
