
require "time"
require "thread"

NUMBERS = (1e6).to_i
MAX_NUMBER = (2 * 1e10).to_i
OFFSET = (1e3).to_i

puts NUMBERS.inspect
puts MAX_NUMBER.inspect

$mutex_queue = Mutex.new

#$queue = Queue.new

producers = []
consumers = []

class Resource
  attr_accessor :queue

  def initialize
    queue = Queue.new
  end

  def produce
    for i in 1..NUMBERS
      #$mutex_queue.lock
      value = rand(OFFSET) + MAX_NUMBER
      queue << value
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
    while queue.length > 0
      value = queue.pop
      judge(value)
      #puts queue.length.inspect
    end
  end
end

start = Time.new

resource = Resource.new
resource.queue = Queue.new
#puts resource.queue.inspect

for i in 1..2
  producers << Thread.new do
    resource.produce
  end
end

sleep 0.1

for i in 1..4
  consumers <<
    Thread.new do
      resource.consume
    end
end

producers.each do |each_produce|
  each_produce.join
end

consumers.each do |each_consumer|
  each_consumer.join
end

ended = Time.new

puts (ended - start).inspect
