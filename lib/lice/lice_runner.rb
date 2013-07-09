#!/usr/bin/env ruby

require_relative "lice_options"
require_relative "lice_parser"
require_relative "lice_process"

module Lice

    class LiceRunner
        # We get the licence file name and source named from LiceOptions
        # We use LiceParser to read the licence header text into an array
        # We use LiceProcess to determine the comment symbols we require

        attr_reader :licenceFile, :sourceFileArray

        def initialize(argv)
            Lice::LiceOptions.new(argv)
            @sourceFileArray = argv 
            if @sourceFileArray.size >=2
                @licenceFile = @sourceFileArray.shift
            else
                puts "An insufficient number of file names have been passed."
                exit 1
            end
        end

        def run
            if File.exists?(@licenceFile) && File.readable?(@licenceFile)
                processSourceFiles
            else
                puts "Error: Licence file #{@licenceFile} is not accessible."
                exit 1
            end
        end

        def processSourceFiles
            @sourceFileArray.each do |src|
                if File.exists?(src) && File.writable?(src)
                    commentArray = Lice::LiceProcess.getComment(src)
                else
                    puts "Error: #{src} is not accessible."
                end
            end

        end
    end
end
        

