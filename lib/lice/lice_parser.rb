#!/usr/bin/env ruby

module Lice
    
    class LiceParser
        # Reads in a licence text, line by line, into an array. Lines are
        # reflowed and padded to maintain a consistent length.
        #
        # The MAX_WIDTH should be 79 chars. The commentSize argument passed
        # to the class upon initialization will determine the max text width
        # to allow for comments and padding

        MAX_WIDTH = 79
        @maxTextWidth = 75
        #MAX_TEXT_WIDTH = 75

        attr_reader :liceArray
        
        def initialize commentSize
            @liceArray = Array.new
            @cacheArray = Array.new
            # allow for comment symbols and 1 space either end
            @maxTextWidth = MAX_WIDTH - (2*commentSize + 2)
        end

        def LiceParser.checkLine line
            if line.size > @maxTextWidth
                false
            else
                true
            end
        end

        def processLine line
            # left justify and pad line with spaces
            return line.ljust(@maxTextWidth)
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
                breakIndex = line.rindex(/\s/,@maxTextWidth-1)
                @liceArray.push processLine(line[0..breakIndex-1])
                @cacheArray.push line[breakIndex+1..-1]
            end
        end

        def size
           return [@liceArray.size, @cacheArray.size]
        end 
    end
end
