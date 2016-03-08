require "use_arguments"

using UseArguments


=begin
	Implicitly defined parameters in block.
	_1, _2..._N : Argument value.
	_           : _1
	_args       : Argument array.
	_self       : self Proc object.
	_yield      : block argument.
=end

#--------------------------------------
# Proc#use_args
#--------------------------------------

p proc { _args }.use_args.call 1, 2, 3
# => [1, 2, 3]

plus = proc { _1 + _2 }.use_args
p plus.call 1, 2
# => 3

fact = proc { _1 == 1 ? 1 : _1 * _self.(_1 - 1); }.use_args
p fact.call 5
# => 120

f = proc { _yield 1, 2 }.use_args
p f.call { |a, b| a - b }
# => -1

p f.call &plus
# => 3

# Array argument is splatted in proc.
p proc { _1 + _1 }.use_args.call [1, 2]
# => 2

# Array argument is no splatted in lambda.
p lambda { _1 + _1 }.use_args.call [1, 2]
# => [1, 2, 1, 2]

#--------------------------------------
# Object#use_args
#--------------------------------------

# receiver#use_args#{any receiver method.}
p [1, 2, 3].use_args.map { _1 * _1 }
# => [1, 4, 9]

p [[1, 2], [3, 4]].use_args.map &proc{ _1 + _1 }
# => [2, 6]

p [[1, 2], [3, 4]].use_args.map &lambda{ _1 + _1 }
# => [[1, 2, 1, 2], [3, 4, 3, 4]]

#--------------------------------------
# Class method use args.
#--------------------------------------

# UseArguments::{Use args class name}
using UseArguments::Array
# or
# using UseArguments.usable Array

p [1, 2, 3].map { _1 + _1 }
# => [2, 4, 6]

using UseArguments::Hash
p ({homu: 13, mami: 14, mado: 13}).select { _2 < 14 }
# => {:homu=>13, :mado=>13}

