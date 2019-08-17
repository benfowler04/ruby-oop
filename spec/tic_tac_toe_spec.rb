require './tic_tac_toe'

RSpec.describe Board do
    describe "#add_move" do
        it "returns -1 if game ends in a draw" do
            board = Board.new
            board.add_move("5","X")
            board.add_move("1","O")
            board.add_move("2","X")
            board.add_move("8","O")
            board.add_move("6","X")
            board.add_move("4","O")
            board.add_move("7","X")
            board.add_move("3","O")
            expect(board.add_move("9","X")).to eql(-1)
        end
        it "returns 1 when a winning move is made by completing a row" do
            board = Board.new
            board.add_move("1","X")
            board.add_move("2","X")
            expect(board.add_move("3","X")).to eql(1)
        end
        it "returns 1 when a winning move is made by completing a column" do
            board = Board.new
            board.add_move("1","X")
            board.add_move("4","X")
            expect(board.add_move("7","X")).to eql(1)
        end
        it "retuns 1 when a winning move is made by completing a diagonal" do
            board = Board.new
            board.add_move("1","X")
            board.add_move("5","X")
            expect(board.add_move("9","X")).to eql(1)
        end
        it "returns 0 if game should continue" do
            board = Board.new
            board.add_move("5","X")
            board.add_move("1","O")
            expect(board.add_move("2","X")).to eql(0)
        end
    end

    describe "#is_move_valid?" do
        it "returns false if move is out of bounds" do
            board = Board.new
            expect(board.is_move_valid?(10)).to eql(false)
        end
        it "returns false if move is invalid" do
            board = Board.new
            board.add_move("5","X")
            expect(board.is_move_valid?(5)).to eql(false)
        end
        it "returns true if move is valid" do
            board = Board.new
            board.add_move("5","X")
            expect(board.is_move_valid?(1)).to eql(true)
        end
    end
end