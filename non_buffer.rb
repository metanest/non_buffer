require "thread"

class NonBuffer
  def initialize
    @m = Mutex.new
    @stat = :INITIAL
    @buf = nil
    @cv = ConditionVariable.new
  end

  def read
    @m.synchronize {
      tmp = nil

      case @stat
      when :INITIAL then
        @stat = :READING
        while @stat != :FINAL do
          @cv.wait @m
        end
        tmp = @buf
        @buf = nil
        @stat = :INITIAL
        @cv.signal
      when :READING then
        raise NonBufferException.new("read after read")
      when :WRITING then
        @stat = :FINAL
        tmp = @buf
        @buf = nil
        @cv.signal
        while @stat == :FINAL do
          @cv.wait @m
        end
      else
        raise "assert"
      end

      case tmp.size
      when 0 then
        return nil
      when 1 then
        return tmp[0]
      else
        return tmp
      end
    }
  end

  def write *args
    @m.synchronize {
      case @stat
      when :INITIAL then
        @stat = :WRITING
        @buf = args
        while @stat != :FINAL do
          @cv.wait @m
        end
        @stat = :INITIAL
        @cv.signal
      when :READING then
        @stat = :FINAL
        @buf = args
        @cv.signal
        while @stat == :FINAL do
          @cv.wait @m
        end
      when :WRITING then
        raise NonBufferException.new("write after write")
      else
        raise "assert"
      end

      nil
    }
  end
end

class NonBufferException < Exception
end
