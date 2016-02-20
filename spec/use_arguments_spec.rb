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
		it "Use _args" do
			expect(proc { _args }.use_args.call 1, 2, 3).to eq [1, 2, 3]
		end
		it "Use _self" do
			f = proc { _self }.use_args
			expect( f.call == f ).to eq true
		end
		it "Use _block" do
			f = proc { _yield 1, 2 }.use_args
			expect( (f.call do |a, b| a + b end) ).to eq 3
		end
	end

	describe "Object#use_args" do
		it "Object#use_args#any method" do
			expect( [1, 2, 3].use_args.map{ _1 + _1 } ).to eq [2, 4, 6]
			expect( [1, 2, 3].use_args.map{ |a| a + a } ).to eq [2, 4, 6]
		end
	end
end
