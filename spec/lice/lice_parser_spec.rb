#!/usr/bin/env ruby

require 'lice/lice_parser'

module Lice
    describe LiceParser do

        context "with simple test lines" do
            before(:all) do
                @filename = "test_output.txt"
                File.open(@filename, 'w') do |fileWriter|
                    fileWriter.puts "test line"
                end
                @testLice = Lice::LiceParser.new(1, @filename)
                @line = ''
                11.times { @line += 'giraffe ' }
                @shortLine = "this is a short line\n"
            end

            it "adds left-justified text from a test file to liceArray" do
                @testLice.liceArray[0].should == "test line".ljust(75)
            end

            it "checks if a line is sufficiently short" do
                Lice::LiceParser.checkLine(@shortLine).should == true
            end

            it "checks if a line is too long" do
                Lice::LiceParser.checkLine(@line).should == false
            end

            it "adds short lines to liceArray" do
                @testLice.addLine(@shortLine)
                @testLice.liceArray[1].should == @shortLine.ljust(75)
            end

            it "breaks long lines into separate elements < max size" do
                @testLice.addLine(@line)
                expectElement1 = String.new
                9.times { expectElement1 += 'giraffe '}
                expectElement2 = 'giraffe giraffe '
                @testLice.liceArray[2].should == expectElement1.ljust(75)
                @testLice.liceArray[3].should == expectElement2.ljust(75)
            end

            it "outputs a blank line for carriage return/whitespace lines" do
                @testLice.addLine("  \r\n")
                @testLice.liceArray[4].should == " ".ljust(75)
            end

            it "accounts for different comment sizes" do
                testLice2 = Lice::LiceParser.new(2, @filename)
                testLice2.addLine @shortLine
                testLice2.liceArray[1].should == @shortLine.ljust(73)
            end

            after(:all) do
                File.delete(@filename)
            end
        end


        context "with a licence file input" do

            before do
                @licence_file = 'licence_header.txt'
                @testArray = []
                if File.exists? @licence_file
                    File.open(@licence_file) do |fileReader|
                        while line = fileReader.gets
                            @testArray.push(line)
                        end
                    end
                end
            end

        end

    end
end
