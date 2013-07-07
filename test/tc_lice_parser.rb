require_relative "../lib/lice/lice_parser"
require "test/unit"

class TestLineLength < Test::Unit::TestCase

    def setup
        @testLice = Lice::LiceParser.new(1)
        @line="giraffe giraffe giraffe giraffe giraffe giraffe"\
              " giraffe giraffe giraffe giraffe giraffe"  # 87 chars
        @shortLine = "this is a short line\n"
    end

    def test_checkLine_short
        assert(Lice::LiceParser.checkLine(@shortLine))
    end

    def test_checkLine_long
        assert(!Lice::LiceParser.checkLine(@line))
    end

    def test_LiceParser_addLine
        @testLice.addLine @shortLine 
        assert_equal([1, 0], @testLice.size)
        # Note MAX_TEXT_WIDTH set to 75 in LiceParser
        assert_equal("this is a short line".ljust(75), 
                     @testLice.liceArray[0])
    end

    def test_LiceParser_addLine_long
        @testLice.addLine @line
        assert_equal([1, 1], @testLice.size)
    end

    def test_LiceParser_diff_comment_size
        testLice2 = Lice::LiceParser.new(2)
        testLice2.addLine @shortLine
        assert_equal("this is a short line".ljust(73),
                    testLice2.liceArray[0])

    end
end
