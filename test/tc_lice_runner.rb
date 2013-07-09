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
    end     # context

    context "LiceRunner.getCommentSize" do
        should "find the comment character size" do
            commentArray = %w[/* * */]
            assert_equal(1, Lice::LiceRunner.getCommentSize(commentArray))
            assert_equal(2, Lice::LiceRunner.getCommentSize(["//"]))
        end
    end     # context

    context "the lice runner instance" do

        setup do
            @fileArray = %w[licence.txt src1.rb src2.rb]
            @fileArray.each do |file|
                File.open(file, 'w') do |fileWriter|
                    if file == "licence.txt"
                        fileWriter.puts "Test licence text"
                    else
                        fileWriter.puts "#!/usr/bin/env ruby\nsome text"
                    end
                end
            end
            @testRunner = Lice::LiceRunner.new(@fileArray)
        end # setup

        should "process source" do
           @testRunner.run



        end

        teardown do
            File.delete("licence.txt")
            @fileArray.each do |file|
                if File.exists?(file)
                    File.delete(file)
                end
            end
        end # teardown

    end     # context
end


