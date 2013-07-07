#!/usr/bin/env ruby

module Lice
    
    class LiceParser
        # Reads in a licence text, line by line, into an array. Lines are
        # reflowed and padded to maintain a consistent length.
        #
        # The MAX_WIDTH should be 79 chars. We will allow 4 chars for a single
        # char comment character and a space at both ends of the line.
        # We will set MAX_TEXT_WIDTH to be 75.

        MAX_WIDTH = 79
        MAX_TEXT_WIDTH = 75

        attr_reader :liceArray
        
        def initialize
            @liceArray = Array.new
            @cacheArray = Array.new
        end

        def LiceParser.checkLine line
            if line.size > MAX_TEXT_WIDTH
                false
            else
                true
            end
        end

        def processLine line
            # left justify and pad line with spaces
            return line.ljust(MAX_TEXT_WIDTH)
        end

        def addLine line
            line.chomp!
            if !@cacheArray.empty?
                line = @cacheArray[0] + " " + line
                @cacheArray.clear 
            end
            if LiceParser.checkLine(line) 
                @liceArray.push processLine(line) 
            else
                breakIndex = line.rindex(/\s/,MAX_TEXT_WIDTH-1)
                @liceArray.push processLine(line[0..breakIndex-1])
                @cacheArray.push line[breakIndex+1..-1]
            end
        end

        def size
           return [@liceArray.size, @cacheArray.size]
        end 
    end
end
