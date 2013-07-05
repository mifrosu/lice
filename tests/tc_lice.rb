require "../lice"
require "test/unit"

class TestLineLength < Test::Unit::TestCase

    def setup
        @testLice = Lice::LiceParser.new
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
        assert_equal(@testLice.size, [1, 0])
        assert_equal(@testLice.liceArray[0],
                     "this is a short line".ljust(75))
    end

    def test_LiceParser_addLine_long
        @testLice.addLine @line
        assert_equal(@testLice.size, [1,1])
    end
end
