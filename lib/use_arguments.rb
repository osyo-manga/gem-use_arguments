# Original source code.
# http://qiita.com/supermomonga/items/b0576847b1b88e3cd400
require "use_arguments/version"


module UseArguments
	module ToUseArgs
		def use_args
			return self unless self.arity == 0
			self_ = self
			x = proc do |*args, &block|
				::Object.new.instance_eval do
					args = args[0] if !self_.lambda? && args.size == 1 && args[0].class == Array

					define_singleton_method(:_args) { args }
					define_singleton_method(:_) { args[0] }
					define_singleton_method(:_self) { x }
					define_singleton_method(:_yield) { |*args, &_block| block.call *args, &_block }
					args.size.times do |i|
						define_singleton_method("_#{i + 1}") { args[i] }
					end

					define_singleton_method(:method_missing) do |name, *args, &block|
						return nil if name.to_s =~ /^_\d+$/
						super(name, *args, &block)
					end unless self_.lambda?

					instance_exec &self_
				end
			end
		end
	end

	refine ::Proc do
		include ToUseArgs
	end

end


using UseArguments

module UseArguments
	module AsUseArgs
		def use_args
			self_ = self
			::Class.new(BasicObject) do
				define_singleton_method(:method_missing) do |name, *args, &block|
					return self_.__send__ name,*args, &block unless block && block.arity == 0
					self_.__send__ name, *args, &block.use_args
				end
			end
		end
	end

	refine ::Object do
		include AsUseArgs
	end

	def self.const_missing name
		self.usable ::ObjectSpace.each_object(::Class).find { |klass| klass.name == name.to_s }
	end

	def self.usable klass
		::Module.new do
			refine klass do
				prepend ::UseArguments::Usable
				class <<klass
					prepend ::UseArguments::Usable
				end
			end
		end
	end
end


module UseArguments
	module Usable
		def self.prepend_features mod
			mod.__send__ :prepend, (Module.new do
				for name in mod.instance_methods
					define_method name do |*args, &block|
						super *args, &(block ? block.use_args : nil)
					end
				end
			end)
		end
	end
end
