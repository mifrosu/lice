#!/usr/bin/env ruby

require_relative "./lice_parser"

module Lice

    class LiceProcess
        # Identifies the file type from the file name suffix, or from 
        # the presence of a hash bang line.  

        @@LANG_COMMENTS = {
            :c_style => ["/*", "*", "*/"],
            :cpp_style => ["//"],
            :script_style => ["#"],
            :vim_style => ["\""], 
            :haskell => ["{-", " ", "-}"],
            :percent => ["%"]         # Erlang, TeX
        }

        @@SUFFIX_ID = {
            "c" => :c_style,
            "h" => :c_style,
            "cpp" => :c_style,
            "cxx" => :c_style,
            "hpp" => :c_style,
            "cs" => :c_style,   # C#
            "java" => :c_style,
            "class" => :c_style,
            "jar" => :c_style,
            "rb" => :script_style,
            "py" => :script_style,
            "pl" => :script_style,  # perl
            "pm" => :script_style,
            "t" => :script_style,
            "pod" => :script_style,
            "vim" => :vim_style,
            "tex" => :percent,
            "erl" => :percent,
            "hrl" => :percent,
            "hs" => :haskell,
            "lhs" => :haskell
        }

        #attr_reader :licenceFileName
        #attr_reader :sourceFileArray
        
        def initialize fileName
            @fileName 
        end

        def LiceProcess.getSuffix fileName
            if fileName.match(/\./)
                return fileName.split(/\./)[-1]
            else
                return nil
            end
        end

        def LiceProcess.identifyFileType fileName
            fileSuffix = getSuffix fileName
            if fileSuffix
                if @@SUFFIX_ID.has_key? fileSuffix
                   return @@SUFFIX_ID.fetch fileSuffix
                end
            end 
        end

        def LiceProcess.getComment fileName
            fileType = LiceProcess.identifyFileType fileName
            if fileType 
                return @@LANG_COMMENTS.fetch fileType
            else
                if File.exist? fileName
                    firstLine = nil
                    File.open fileName do |file|
                        firstLine = file.gets
                    end
                    # test if first line begins "#!" e.g. #!/usr/bin/env ruby
                    if firstLine.match /^\#!/
                        return @@LANG_COMMENTS.fetch :script_style
                    end
                end
            end
        end

    end
end
