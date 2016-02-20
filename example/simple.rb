require "use_arguments"

using UseArguments


=begin
	Implicitly defined parameters in block.
	_1, _2..._N : argument value.
	_args       : argument array.
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


#--------------------------------------
# Object#use_args
#--------------------------------------

# receiver#use_args#{any receiver method.}
p [1, 2, 3].use_args.map { _1 * _1 }
# => [1, 4, 9]


#--------------------------------------
# Class method use args.
#--------------------------------------

# UseArguments::{Use args class name}
using UseArguments::Array

p [1, 2, 3].map { _1 + _1 }
# => [2, 4, 6]

using UseArguments::Hash
p ({homu: 13, mami: 14, mado: 13}).select { _2 < 14 }
# => {:homu=>13, :mado=>13}

