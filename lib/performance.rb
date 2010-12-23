require 'benchmark'

include Benchmark

test_string = "hello world"
lm = test_string.method(:length)
n = 1000000
bm(12) { |x|
  x.report('call') {n.times{lm.call}}
  x.report('send') {n.times{test_string.send(:length)}}
  x.report('eval') {n.times{eval "test_string.length"}}
}