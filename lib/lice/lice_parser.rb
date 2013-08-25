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
        
        def initialize(commentSize, fileName)
            @liceArray = Array.new
            @cacheArray = Array.new
            @fileName = nil
            # allow for comment symbols and 1 space either end
            @maxTextWidth = MAX_WIDTH - (2*commentSize + 2)
            if File.readable?(fileName)
                @fileName=fileName
            else
                puts "#{fileName} is not readable"
                exit 1
            end
            addFile
        end

        def LiceParser.checkLine line
            line.size <= @maxTextWidth
        end

        def processLine line
            # left justify and pad line with spaces
            return line.ljust(@maxTextWidth)
        end

        def addLine line
            if LiceParser.checkLine(line)
                if !line.match(/^R/)
                    line.chomp!
                elsif line.strip == ""
                    @liceArray.push(processLine(" "))
                    return
                end
                @liceArray.push(processLine(line))
            else
                # we find the first index < maxTextWidth-1 that is a space 
                breakIndex = line.rindex(/\s/, @maxTextWidth-1) 
                @liceArray.push(processLine(line[0..breakIndex-1]))
                line = line[breakIndex+1..-1]
                addLine(line)
            end
        end

        def processArray
            if !@liceArray.empty?
                i=0
                @liceArray.each do |element|
                    element.chomp!
                    if element.match /.*\n\n.*/
                        breakIndex = element =~ /\n\n/
                        @liceArray.insert(i+1, " ".ljust(@maxTextWidth))
                        @liceArray.insert(i+2, 
                                          element[breakIndex+2..-1])
                        @liceArray[i]=element[0..breakIndex-1]
                    end
                    @liceArray[i] = @liceArray[i].ljust(@maxTextWidth)
                    i+=1
                end
            end
        end

                       
        def addFile 
            if File.exists? @fileName
                File.open(@fileName) do |fileReader|
                    while line = fileReader.gets
                        addLine line
                    end
                    while !@cacheArray.empty?
                        line = @cacheArray[0]
                        @cacheArray.clear
                        addLine line
                    end
                end
            end
        end

        def size
           return [@liceArray.size, @cacheArray.size]
        end 
    end
end
