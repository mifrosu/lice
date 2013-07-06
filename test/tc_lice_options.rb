#!/usr/bin/env ruby

require 'test/unit'
require 'shoulda'
require_relative '../lib/lice/lice_options'

class TestLiceOptions < Test::Unit::TestCase

    context "specifying no arguments" do
        should "trigger return help" do
        end
    end

    context "specifying a licence file only" do
        should "trigger return help and error" do
        end
    end

    context "specifying a licence file and source file(s)" do
        should "store licence file name and source names" do
            test_options = Lice::LiceOptions.new(["licence.txt", "src.rb"])
            assert_equal(["licence.txt", "src.rb"], 
                         test_options.fileNameArray)
        end
    end

end

