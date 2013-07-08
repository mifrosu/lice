#!/usr/bin/env ruby

require "test/unit"
require "shoulda"
require_relative "../lib/lice/lice_runner"

class TestLiceRunner < Test::Unit::TestCase

    context "a lice runner instance receiving a file name array" do

        setup do
            @fileArray = %w[licence.txt src1.rb src2.py src3.cpp]
            @testRunner = Lice::LiceRunner.new(@fileArray)
        end

        should "allocate the first file as the licence file" do
            assert_equal("licence.txt", @testRunner.licenceFile)
        end

        should "allocate the remaining files as source files" do
            assert_equal(%w[src1.rb src2.py src3.cpp], 
                         @testRunner.sourceFileArray)
        end

        #should "check the licence file exists" do
        #    fileName = "licence.txt"
        #    File.open(fileName, 'w') do |file| 
        #        file.puts "Hello"
        #    end
        #end

    end
end


