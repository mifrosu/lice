#!/usr/bin/env ruby

module Lice
    
    class LiceParser

        MAX_WIDTH = 79
        
        def initialize
            @liceArray = Array.new
            @cacheArray = Array.new
        end

        def LiceParser.checkLine line
            if line.size > MAX_WIDTH
                false
            else
                true
            end
        end

        def addLine line
            if LiceParser.checkLine(line) 
                @liceArray.push line
            else
                breakIndex = line.rindex(/\s/,MAX_WIDTH-1)
                @liceArray.push line[0..breakIndex-1]
                @cacheArray.push line[breakIndex+1..-1]
            end
        end

        def size
           return [@liceArray.size, @cacheArray.size]
        end 
    end
end
