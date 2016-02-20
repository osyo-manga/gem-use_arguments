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
# 		it "Use _" do
# 			expect(proc { _ + _ }.use_args.call 1).to eq 2
# 		end
		it "Use _args" do
			expect(proc { _args }.use_args.call 1, 2, 3).to eq [1, 2, 3]
		end
		it "Use self" do
			f = proc { self_ }.use_args
			expect( f.call == f ).to eq true
		end
	end
end
