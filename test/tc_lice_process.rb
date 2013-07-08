#!/usr/bin/env ruby

require "test/unit"
require "shoulda"
require_relative "../lib/lice/lice_process"

class TestLiceProcess < Test::Unit::TestCase

    context "processing source files" do

        
        should "check file exists" do
        end

        should "get file suffix" do
            assert_equal("rb", Lice::LiceProcess.getSuffix("test.rb"))
            assert_equal(nil, Lice::LiceProcess.getSuffix("test_script"))
        end

        should "identify file type" do
            assert_equal(:c_style, 
                         Lice::LiceProcess.identifyFileType("src.cpp"))
        end

        should "get required comment" do
            assert_equal(["#"], Lice::LiceProcess.getComment("src.rb"))
        end

        should "select the correct comment type" do
            testFileNameArray = ["source.c", "header.h", "source.cpp",
            "src.cxx", "header.hpp", "sharp.cs", "java.java",
            "java.class", "java.jar", "script.rb", "script.py", "perl.pl",
            "perl.pm", "perl.t", "perl.pod", "ruby-vim.vim", "thesis.tex",
            "erlang.erl", "erlang_header.hrl", "haskell.hs", "hask.lhs"]
            commentHash = {
                :c_style => ["/**", "*", "*/"],
                :cpp_style => ["//"],
                :script_style => ["#"],
                :vim_style => ["\""], 
                :haskell => ["{-", " ", "-}"],
                :percent => ["%"]         # Erlang, TeX
            }
            expectedCommentArray = [
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:c_style],
                commentHash[:script_style],
                commentHash[:script_style],
                commentHash[:script_style],
                commentHash[:script_style],
                commentHash[:script_style],
                commentHash[:script_style],
                commentHash[:vim_style],
                commentHash[:percent],
                commentHash[:percent],
                commentHash[:percent],
                commentHash[:haskell],
                commentHash[:haskell]
            ]
            for num in (0..testFileNameArray.size-1)
               assert_equal(expectedCommentArray[num],
                           Lice::LiceProcess.getComment(testFileNameArray[num])) 
            end
        end

        should "identify file from hash bang line if no file name suffix" do
           # This test may only be run from lice/test/ or lice/
            testScript = nil 
            if Dir.pwd.match /lice$/
               testScript = Dir.pwd + "/test/test_script" 
            elsif Dir.pwd.match /lice\/test$/
                testScript = "test_script"
            end
            if testScript 
                assert_equal(["#"], Lice::LiceProcess.getComment(testScript),
                        "Check working directory is lice/ or lice/test/")
            else
                puts
                puts
                puts "*************************************************"
                puts "* Note: hash bang ID test has not been run!     *"
                puts "* The test must be run from lice/ or lice/test/ *"
                puts "*************************************************"
                puts
            end
        end
    end

end


