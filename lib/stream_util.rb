#encoding=utf-8
require 'logger'
class StreamUtil	
	class ObjType
		NULL = 0
		INT  = 1
		LONG = 2
		STRING = 3
		BYTEARRAY = 4
		SHORTARRAY = 5
		INTARRAY = 6
		LONGARRAY = 7
		VECTOR = 8
		HASHTABLE = 9
		OBJECTARRAY = 10
		BOOLEAN = 11
		BOOLEANARRAY = 12
		POINT = 13
	end
	
	def initialize(io)
		@io = io
		@log = Logger.new(STDOUT)
		@log.formatter = proc { |severity, datetime, progname, msg|
    					"#{datetime}: #{msg}\n"
 						 }
	end
	
	def read_byte
		@io.readbyte
	end
	
	def read_int16
		@io.read(2).unpack('n')[0]
	end
	def read_int32
		@io.read(4).unpack('N')[0]
	end
	def read_int64
		@io.read(2).pack('Q')
	end
	
	def read_bytes(num)
		@io.read num
	end
	
	def write_byte(byte)
		@io.write [byte].pack("c")
	end
	
	def write_int16(num)
		@io.write [num].pack('n')
	end
	def write_int32(num)
		@io.write [num].pack('N')
	end
	def write_int64(num)
		@io.write [num].pack('Q')
	end
	
	def write_bytes(nums)
		@io.write nums.pack('c'*nums.size)
	end
	
	def write_utf(s)
	  len = s.bytesize
    write_int16 len
	  write_bytes s.bytes.to_a
	end
	
	def read_utf
		len = read_int16
		s = read_bytes(len)
		#s = s.encode('GBK','UTF-8')
		return s
	end
	
	def read_long
	end
	
	def read_array(type)
		obj = []
		len = read_int32
		
		len.times do
			obj << self.send("read_"+type)
		end
		
	end
	
	def write_array(a,type)
	  len = a.size
	  write_int32 len
	  
	  len.times do |i|
	    self.send("write_"+type, a[i])
    end
  end
	
	def read_from_stream()		
		c = read_byte
		@log.debug("read byte = "+c.to_s)
		case c
		when ObjType::NULL			
			return nil
		when ObjType::INT
			return read_int32
		when ObjType::LONG
			return read_int32
		when ObjType::STRING
			return read_utf
		when ObjType::BYTEARRAY
			return read_array("byte")
		when ObjType::SHORTARRAY
			return read_array("int16")
		when ObjType::INTARRAY
			return read_array("int32")
		when ObjType::LONGARRAY
			return read_array("int32")
		when ObjType::VECTOR
			obj = []
			obj << read_from_stream
		when ObjType::HASHTABLE
			len = read_int32
			@log.debug("obj hash len = "+len.to_s)
			obj = {}
			len.times do
				key = read_from_stream
				value = read_from_stream
				obj[key] = value
			end
			return obj
		when ObjType::OBJECTARRAY
			obj = []
			len =  read_int32
			@log.debug("obj array len = "+len.to_s)
			len.times do
			  obj << read_from_stream
		  end
			return obj
		when ObjType::BOOLEAN
			return read_int32
		when ObjType::BOOLEANARRAY
			return read_array("int32")
		when ObjType::POINT
			return read_int32
		else
			print c
		end
	end
	
	def write_to_stream(obj)		
		if obj.nil?		
		  write_byte ObjType::NULL
		elsif obj.kind_of? Fixnum
		  write_byte ObjType::INT
		  write_int32 obj
	  elsif obj.kind_of? String
		  write_byte ObjType::STRING
			write_utf obj
		elsif obj.kind_of? Array
		  write_byte ObjType::OBJECTARRAY
			len =  obj.size
			write_int32 len
			len.times do |i|
			  write_to_stream obj[i]
		  end
		elsif obj.kind_of? Hash
		  write_byte ObjType::HASHTABLE
			len = obj.length
			write_int32 len
			obj.each do |key,value|
				write_to_stream key.to_s
				write_to_stream value
			end
		else
			print "unknow type =" + obj.inspect
		end
	end
	
end

if _DEBUG
  o = [{:name => "222", :fuck => 111 },
      {:name => "1111", :fuck => 333 }]
  in_o = StreamUtil.new("/tmp/APP.INF")
  #in_o.write_to_stream (o)
  obj = in_o.read_from_stream
  puts obj.inspect
end