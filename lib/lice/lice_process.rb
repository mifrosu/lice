#!/usr/bin/env ruby

module Lice
    class LiceProcess

        attr_reader :licenceFileName
        attr_reader :sourceFileArray
        
        def initialize fileNameArray
            @sourceFileArray = fileNameArray
            @licenceFileName = @sourceFileArray.shift
        end

        def indentify fileName
        end
    end
end
