=begin
#!/usr/bin/env ruby
# encoding: utf-8
=end

=begin
require "rubygems"
require "bunny"
require "time"

NUMBERS = (1e2).to_i
MAX_NUMBER = (2 * 1e10).to_i
OFFSET = (1e3).to_i

@mutex_queue = Mutex.new

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

puts "Hello World"

start_time = Time.new

STDOUT.sync = true

connection = Bunny.new
connection.start

channel = connection.create_channel

=begin
x = channel.fanout("All queue")

channel.queue("consumer1", :auto_delete => true).bind(x).subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end

channel.queue("consumer2", :auto_delete => true).bind(x).subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end
=end

=begin
exchange = channel.default_exchange

queue.subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end
#=end

exchange = channel.topic("P&C", :auto_delete => true)

channel.queue("consumer1", :auto_delete => true).bind(exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end

=begin
channel.queue("consumer2", :auto_delete => true).bind(exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end

=begin
channel.queue("consumer3", :auto_delete => true).bind(exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end

channel.queue("consumer4", :auto_delete => true).bind(exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
  judge(payload.to_i)
end
=end

require_relative "Producer & consumer with MQ"

include MQ

sleep 1 #waiting for loading channels 

thread1 = Thread.new do
  for i in 1..NUMBERS
    value = rand(OFFSET) + MAX_NUMBER
    $exchange.publish(value.to_s, :routing_key => "Producer")
  end
end

sleep 1 #ensure it have published data 
thread1.join


end_time = Time.new

puts (end_time - $start_time).inspect

=begin
$flag_P1 = true
while ($flag_P2)
end
=end
#connection.close
