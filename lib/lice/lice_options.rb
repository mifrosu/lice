#!/usr/bin/env ruby

require 'optparse'

module Lice
    
    class LiceOptions
        attr_reader :fileNameArray
        attr_reader :licenceFileName

        def initialize(argv)
            parse(argv) 
            # after parse remaining arguments are stored in array
            @fileNameArray = Array.new(argv)
            
        end

        private

        def parse(argv)

            OptionParser.new do |opts|
                opts.banner = "Usage: Lice <licence_file> <source_file(s)>"
                opts.on("-h", "--help", "Show this message") do
                    puts opts
                    exit
                end

                begin
                    argv = ["-h"] if argv.empty?
                    opts.parse!(argv)   # removes known options from argv
                rescue OptionParser::ParseError => e
                    STDERR.puts e.message, "\n", opts
                    exit(-1)
                end

            end

        end



    end
end
