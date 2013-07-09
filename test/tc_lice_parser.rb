require_relative "../lib/lice/lice_parser"
require "test/unit"

class TestLineLength < Test::Unit::TestCase

    def setup
        @fileName = "tc_parser_testfile"
        File.open(@fileName, 'w') do |fileWriter|
            fileWriter.puts "test line" 
        end
        @testLice = Lice::LiceParser.new(1, @fileName)
        @line="giraffe giraffe giraffe giraffe giraffe giraffe"\
              " giraffe giraffe giraffe giraffe giraffe"  # 87 chars
        @shortLine = "this is a short line\n"
    end

    def teardown
        File.delete(@fileName)
    end

    def test_checkLine_short
        assert(Lice::LiceParser.checkLine(@shortLine))
    end

    def test_checkLine_long
        assert(!Lice::LiceParser.checkLine(@line))
    end

    def test_LiceParser_addLine
        @testLice.addLine @shortLine 
        assert_equal([2, 0], @testLice.size)
        # Note MAX_TEXT_WIDTH set to 75 in LiceParser
        assert_equal("test line".ljust(75),     # from setup
                     @testLice.liceArray[0])
        assert_equal("this is a short line".ljust(75), 
                     @testLice.liceArray[1])
    end

    def test_LiceParser_addLine_long
        @testLice.addLine @line
        assert_equal([2, 1], @testLice.size)
    end

    def test_LiceParser_diff_comment_size
        testLice2 = Lice::LiceParser.new(2, @fileName)
        testLice2.addLine @shortLine
        assert_equal("this is a short line".ljust(73),
                    testLice2.liceArray[1])

    end
end
