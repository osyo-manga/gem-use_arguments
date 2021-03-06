require 'spec_helper'

using UseArguments

describe UseArguments do
	it 'has a version number' do
		expect(UseArguments::VERSION).not_to be nil
	end

	describe "Proc#use_args" do
		it "Use _1" do
			expect(proc { _1 + _2 }.use_args.call 1, 2).to eq 3
		end
		it "Use _" do
			expect(proc { _ + _ }.use_args.call 1).to eq 2
		end
		it "Use _N" do
			expect(proc { [_1, _2] }.use_args.call 1).to eq [1, nil]
		end
		it "Use _args" do
			expect(proc { _args }.use_args.call 1, 2, 3).to eq [1, 2, 3]
		end
		it "Use _self" do
			f = proc { _self }.use_args
			expect( f.call == f ).to eq true
		end
		it "Use _yield" do
			f = proc { _yield 1, 2 }.use_args
			expect( (f.call do |a, b| a + b end) ).to eq 3
		end
		it "Use _receiver" do
			f = proc { _receiver }
			expect( (f.use_args.()) ).to eq f
		end
		it "Array argument" do
			expect(proc { _1.push(_2) }.use_args.call([1, 2], 3)).to eq [1, 2, 3]
			expr = proc { [_1, _2] }.use_args

			expect(expr.call([1, 2])).to eq [1, 2]
			expect(expr.call(1, 2)).to eq [1, 2]
			expect(expr.call([1])).to eq [1, nil]
			expect(expr.call(1)).to eq [1, nil]
		end
		it "use block" do
			expect(proc { |&block| block.() }.use_args.call { 42 }).to eq 42
		end
	end
	
	describe "Proc#use_args in lambda" do
		it "Array argument" do
			expect(lambda { _1.push(_2) }.use_args.call([1, 2], 3)).to eq [1, 2, 3]
			expect(lambda { _1 }.use_args.call([1, 2])).to eq [1, 2]

			expr = lambda { [_1, _2] }.use_args
			expect{expr.call([1, 2])}.to raise_error NameError
			expect(expr.call(1, 2)).to eq [1, 2]
			expect{expr.call([1])}.to raise_error NameError
			expect{expr.call(1)}.to raise_error NameError
		end
	end

	describe "Object#use_args" do
		it "Object#use_args#any method" do
			expect( [1, 2, 3].use_args.map{ _1 + _1 } ).to eq [2, 4, 6]
			expect( [1, 2, 3].use_args.map &proc { _1 + _1 } ).to eq [2, 4, 6]
			expect( [1, 2, 3].use_args.map{ |a| a + a } ).to eq [2, 4, 6]
			expect( [1, 2, 3].use_args.map.class ).to eq Enumerator
			expect( [[1, 2], [3, 4]].use_args.map{ _1 + _2 } ).to eq [3, 7]
			expect( [[1, 2], [3, 4]].use_args.map &proc{ _1 + _1 } ).to eq [2, 6]
		end

		it "use #lambda" do
			expect( [[1, 2], [3, 4]].use_args.map &lambda{ _1 + _1 } ).to eq [[1, 2, 1, 2], [3, 4, 3, 4]]
			expect{ [[1, 2], [3, 4]].use_args.map &lambda{ _1 + _2 } }.to raise_error NameError
		end
		it "use _receiver" do
			expect( [1, 2].use_args.map { _receiver } ).to eq [[1, 2], [1, 2]]
		end
	end

	describe "Usable" do
		it "failed" do
			expect{ [1, 2, 3].map { _1 + _1 } }.to raise_error NameError
		end
	end
end


using UseArguments::Array

module X
	class Y
		def func
			yield 1, 2
		end

		def self.func
			yield 1, 2
		end
	end
end

using UseArguments.usable X::Y


describe UseArguments do
	describe "Usable" do
		it "success" do
			expect( [1, 2, 3].map { _1 + _1 } ).to eq [2, 4, 6]
			expect( [1, 2, 3].map.class ).to eq Enumerator
			expect( X::Y.func { _1 + _2 } ).to eq 3
			expect( X::Y.new.func { _1 + _2 } ).to eq 3
			expect( X::Y.new.func { _1 + _2 } ).to eq 3
			expect( [1, 2].map { _receiver } ).to eq [[1, 2], [1, 2]]
		end
	end
end



