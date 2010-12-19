#encoding=gbk
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
	
	def initialize(file_name)
		@io = File.open(file_name, "rb")
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
	
	def read_utf
		len = read_int16
		s = read_bytes(len)
		s = s.encode('GBK','UTF-8')
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
			obj = {}
			len.times do
				key = read_from_stream
				value = read_from_stream
				obj[key] = value
			end
			return obj
		when ObjType::OBJECTARRAY
			obj = []
			obj << read_from_stream
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
	
	def write_to_stream
	end
	
end

obj = StreamUtil.new("d:\\S60\\devices\\S60_3rd_FP2_SDK\\epoc32\\winscw\\c\\res\\PACKAGE_INF\\APP.INF").read_from_stream()

puts obj.inspect
