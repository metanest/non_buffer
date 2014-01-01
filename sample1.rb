require_relative "non_buffer"

ch = NonBuffer.new

Thread.new {
    sleep 10
    p "entering read"
    p ch.read
    p "leaving read"
    sleep 5
    p "entering read"
    p ch.read
    p "leaving read"
    sleep 5
    p "entering write"
    ch.write "piyo"
    p "leaving write"
}

Thread.new {
    sleep 5
    p "entering write"
    ch.write "hoge"
    p "leaving write"
    sleep 10
    p "entering write"
    ch.write "fuga"
    p "leaving write"
    sleep 10
    p "entering read"
    p ch.read
    p "leaving read"
}

while true do
    p "main loop"
    sleep 1
end
