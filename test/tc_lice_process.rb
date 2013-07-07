#!/usr/bin/env ruby

require "test/unit"
require "shoulda"
require_relative "../lib/lice/lice_process"

class TestLiceProcess < Test::Unit::TestCase

    context "reading fileNameArray" do

        setup do
            @fileNameArray = ["licence.txt", "src1.rb", "src2.py", "src3.sh"]
            @testProcess = Lice::LiceProcess.new(@fileNameArray)
        end
        should "identify item 0 as licence file" do
            assert_equal("licence.txt", @testProcess.licenceFileName)
        end

        should "shift licenceFileName from array" do
            assert_equal(["src1.rb", "src2.py", "src3.sh"],
                         @testProcess.sourceFileArray)
        end

    end

    context "processing licence file" do
        should "verify file exists" do
        end

    end

    context "processing source files" do
        should "check file exists" do
        end

        should "identify file type" do
        end

        should "select the correct comment type" do
        end

        should "write out processed licence text to file" do
        end

    end

end


