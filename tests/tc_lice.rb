require "../lice"
require "test/unit"

class TestLineLength < Test::Unit::TestCase

    def setup
        @line="giraffe giraffe giraffe giraffe giraffe giraffe"\
              " giraffe giraffe giraffe giraffe giraffe"  # 87 chars
    end

    def test_checkLine_short
        assert(Lice::LiceParser.checkLine("this is a short line"))
    end

    def test_checkLine_long
        assert(!Lice::LiceParser.checkLine(@line))
    end

    def test_liceParser_addLine
        testLice = Lice::LiceParser.new
        testLice.addLine "this is a short line"
        assert_equal(testLice.size, [1, 0])
    end

    def test_liceParser_addLine_long
        testLice = Lice::LiceParser.new
        testLice.addLine @line
        assert_equal(testLice.size, [1,1])
    end
end
