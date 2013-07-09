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
            @fileArray = %w[licence.txt src1.rb src2 src3.cpp]
            @fileArray.each do |file|
                File.open(file, 'w') do |fileWriter|
                    if file == "licence.txt"
                        fileWriter.puts "Test licence text"
                    elsif file == "src3.cpp"
                        fileWriter.puts "#include <iostream>\n// hello"
                    else
                        fileWriter.puts "#!/usr/bin/env ruby\nsome text"
                    end
                end
            end
            @testRunner = Lice::LiceRunner.new(@fileArray)
        end # setup

        should "process source ruby source with .rb suffix" do
            @testRunner.run
            rubyArray = Array.new
            File.open("src1.rb") do |fileReader|
                while line = fileReader.gets
                    rubyArray.push(line)
                end
            end
            assert(rubyArray[0].match /^#!/)
            assert(rubyArray[2].match /#\s*Test licence text\s*#/)
            assert(rubyArray[5].match /some text/)
        end

        should "process script file with hash bang line" do
            @testRunner.run
            scriptArray = Array.new
            File.open("src2") do |fileReader|
                while line = fileReader.gets
                    scriptArray.push(line)
                end
            end
            assert(scriptArray[0].match /^#!/)
            assert(scriptArray[2].match /#\s*Test licence text\s*#/)
            assert(scriptArray[5].match /some text/)
        end

        should "process a C++ file" do
            @testRunner.run
            cppArray = Array.new
            File.open("src3.cpp") do |fileReader|
                while line = fileReader.gets
                    cppArray.push(line)
                end
            end
            assert(cppArray[0].match /^\/\*/)
            assert(cppArray[1].match /^\* Test/)
            assert(cppArray[1].match /\*$/)
            assert(cppArray[2].match /^\*\//)
            assert(cppArray[4].match /^#include <iostream>/)
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


