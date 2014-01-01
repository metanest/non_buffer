require_relative "non_buffer"

# This is porting of sample of section 1.3.4 of
# "Verification and Implementation of Concurrent Systems"
# ( ISBN 978-4-7649-0435-4 )

class SRconc
    def main
        ch = NonBuffer.new

        sender = Sender.new ch
        receiver = Receiver.new ch

        sender.run
        receiver.run

        sleep
    end
end

class Sender
    def initialize ch
        @ch = ch
    end

    def run
        Thread.new {
            n = 0

            while true do
                print "send.#{n}\n"
                @ch.write n
                n = (n + 1) % 10
            end
        }
    end
end

class Receiver
    def initialize ch
        @ch = ch
    end

    def run
        Thread.new {
            m = 0

            while true do
                m = @ch.read
                print "  receive.#{m}\n"
            end
        }
    end
end

SRconc.new.main
