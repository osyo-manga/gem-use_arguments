# Original source code.
# http://qiita.com/supermomonga/items/b0576847b1b88e3cd400
require "use_arguments/version"

module UseArguments
	module ToUseArgs
		def use_args
			return self unless self.parameters.size == 0
			self_ = self
			::Object.new.instance_eval do
				x = proc { |*args, &block|
					define_singleton_method(:_args) { args }
					define_singleton_method(:_) { args[0] }
					define_singleton_method(:_self) { x }
					define_singleton_method(:_yield) { |*args, &_block| block.call *args, &_block }
					args.size.times do |i|
						define_singleton_method("_#{i + 1}") { args[i] }
					end
					instance_exec *args, &self_
				}
			end
		end
	end

	refine ::Proc do
		include ToUseArgs
	end

	module AsUseArgs
		def use_args
			self_ = self
			::Class.new(::BasicObject) do
				define_singleton_method(:method_missing) do |name, *args, &block|
					return self_.__send__(name, *args, &block) unless block && block.parameters.size == 0
					self_.__send__(name, *args, &ToUseArgs.instance_method(:use_args).bind(block).())
				end
			end
		end
	end

	refine ::Object do
		include AsUseArgs
	end

	module Usable
		using ::UseArguments

		def self.usable klass, name
			m = klass.instance_method name
			klass.__send__(:define_method, name) do |*args, &block|
				m.bind(self).call *args, &(block ? block.use_args : nil)
			end
		end

		def self.included klass
			for name in klass.instance_methods
				self.usable klass, name
			end
		end
	end

	def self.const_missing name
		self.usable name
	end

	def self.usable name
		__send__ name if respond_to? name

		m = ::Module.new do
			refine ::ObjectSpace.each_object(::Class).find { |klass| klass.name == name.to_s } do
				include ::UseArguments::Usable
				extend  ::UseArguments::Usable
			end
		end

		define_singleton_method name do
			m
		end
		m

	# 	::UseArguments.const_set(name, Module.new do
	# 		refine ObjectSpace.each_object(Class).find { |klass| klass.name == name.to_s } do
	# 			include ::UseArguments::Usable
	# 			extend  ::UseArguments::Usable
	# 		end
	# 	end)
	# 	::UseArguments.const_get name

	end
end


# UseArguments.__send__ :define_singleton_method, :usable do |name|
# 	eval <<EOS
# 		module ::UseArguments::#{name}
# 			refine #{name} do
# 				include ::UseArguments::Usable
# 				extend  ::UseArguments::Usable
# 			end
# 		end
# EOS
# 	::UseArguments.const_get name
# end

