require 'spec_helper'
require 'stream_util'

describe 'obj <=> java' do
  
  before(:each) do
    @o = [{"name" => "111"},{"key" => 111}]
    @file_name = "/tmp/1.txt"
  end
  
  it 'should be obj=>stream' do
    File.open(@file_name,"wb+") do |f|
      in_o = StreamUtil.new(f)
      in_o.write_to_stream (@o)
    end
    
    out_o = nil
    File.open(@file_name,"rb") do |f|
      in_o = StreamUtil.new(f)
      out_o = in_o.read_from_stream
    end
    
    @o.should == out_o 
    
  end
end