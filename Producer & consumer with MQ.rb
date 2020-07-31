
module MQ
  require "rubygems"
  require "bunny"
  require "time"

  NUMBERS = (1e5).to_i
  MAX_NUMBER = (2 * 1e10).to_i
  OFFSET = (1e3).to_i

  $flag_P1 = false
  $flag_P2 = false

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

  puts "Hello World" #flag the program is started

  $start_time = Time.new

  STDOUT.sync = true

  $connection ||= Bunny.new
  $connection.start

  channel = $connection.create_channel

  $exchange = channel.topic("P&C", :auto_delete => true)

  channel.queue("consumer1", :auto_delete => true).bind($exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
    judge(payload.to_i)
  end

  channel.queue("consumer2", :auto_delete => true).bind($exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
    judge(payload.to_i)
  end

  #=begin
  channel.queue("consumer3", :auto_delete => true).bind($exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
    judge(payload.to_i)
  end

  channel.queue("consumer4", :auto_delete => true).bind($exchange, :routing_key => "Producer").subscribe do |delivery_info, metadata, payload|
    judge(payload.to_i)
  end
  #=end

end
