
#ruby "Producer&consumerwithMQ2.rb" &
ruby "Producer&consumerwithMQ1.rb" &
wait
ruby "close_connect.rb"
echo "Complete" #flag all ruby program is completed