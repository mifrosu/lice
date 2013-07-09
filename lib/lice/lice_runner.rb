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
        @licenceTextHash

        def initialize(argv)
            @licenceTextHash = Hash.new
            Lice::LiceOptions.new(argv)
            @sourceFileArray = argv 
            if @sourceFileArray.size >=2
                @licenceFile = @sourceFileArray.shift
            else
                puts "An insufficient number of file names have been passed."
                exit 1
            end
        end

        def LiceRunner.getCommentSize commentArray
            if commentArray.size == 3
                # the body comment is at index 1
                return commentArray[1].size
            elsif commentArray.size == 1
                return commentArray[0].size
            end
        end

        def LiceRunner.formatLiceLine(comment, line)
            return comment + " " + line + " " + comment + "\n"
        end

        def LiceRunner.openComments(commentArray)
            if commentArray.size > 1
                return commentArray[0]
            else
                return "\n"
            end
        end

        def LiceRunner.bodyComment(commentArray)
            if commentArray.size == 1
                return commentArray[0]
            elsif commentArray.size == 3
                return commentArray[1]
            end
        end

        def LiceRunner.closeComments(commentArray)
            if commentArray.size > 1
                return commentArray[-1]
            else
                return "\n"
            end
        end

        def makeLiceHash(commentSize, fileName)
            liceArray = LiceParser.new(commentSize, fileName).liceArray
            @licenceTextHash[commentSize] = liceArray
        end

        def LiceRunner.writeOut(commentArray, licenceTextArray, fileName)
            File.open(fileName) do |fileReader|
                File.open(fileName + "_new", "w") do |newFileWriter|
                    firstLine = nil
                    firstLine = fileReader.gets
                    if firstLine.match /^\#!/
                        newFileWriter.puts firstLine
                    else
                        fileReader.rewind
                    end
                    newFileWriter.puts(LiceRunner.openComments(commentArray))
                    mainComment = LiceRunner.bodyComment(commentArray)
                    licenceTextArray.each do |element|
                        formattedElement = LiceRunner.formatLiceLine(
                            mainComment, element)
                        newFileWriter.puts(formattedElement)
                    end
                    newFileWriter.puts(LiceRunner.closeComments(commentArray))
                    newFileWriter.puts
                    while line = fileReader.gets
                        newFileWriter.puts line
                    end
                end
            end
        end

        
        def processSourceFiles
            @sourceFileArray.each do |src|
                if File.exists?(src) && File.writable?(src)
                    commentArray = Lice::LiceProcess.getComment(src)
                    commentSize = LiceRunner.getCommentSize(commentArray)
                    if !@licenceTextHash.key?(commentSize)
                        makeLiceHash(commentSize, @licenceFile)
                    end
                    LiceRunner.writeOut(commentArray, 
                                       @licenceTextHash.fetch(commentSize),
                                       src)
                else
                    puts "Error: #{src} is not accessible."
                end
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



    end
end
        

