import Foundation

enum Player: String {
    case X = "X"
    case O = "O"
}

enum GameResult {
    case ongoing
    case draw
    case win(Player)
}

class TicTacToe {
    private var board: [[String]]
    var currentPlayer: Player
    
    init() {
        board = Array(repeating: Array(repeating: " ", count: 3), count: 3)
        currentPlayer = .X
    }
    
    func printBoard() {
        for row in board {
            print(row.map { $0 == " " ? "_" : $0 }.joined(separator: " | "))
        }
    }
    
    func play(row: Int, col: Int) -> GameResult {
        guard row >= 0 && row < 3 && col >= 0 && col < 3 else {
            print("Invalid move. Please try again.")
            return .ongoing
        }
        
        guard board[row][col] == " " else {
            print("Cell already occupied. Please try again.")
            return .ongoing
        }
        
        board[row][col] = currentPlayer.rawValue
        
        let result = checkGameResult()
        
        switch result {
        case .ongoing:
            currentPlayer = currentPlayer == .X ? .O : .X
        case .win(let player):
            print("Player \(player.rawValue) wins!")
        case .draw:
            print("The game is a draw!")
        }
        
        return result
    }
    
    private func checkGameResult() -> GameResult {
        // Check rows and columns
        for i in 0..<3 {
            if board[i][0] == board[i][1], board[i][1] == board[i][2], board[i][0] != " " {
                return .win(currentPlayer)
            }
            if board[0][i] == board[1][i], board[1][i] == board[2][i], board[0][i] != " " {
                return .win(currentPlayer)
            }
        }
        
        // Check diagonals
        if board[0][0] == board[1][1], board[1][1] == board[2][2], board[0][0] != " " {
            return .win(currentPlayer)
        }
        if board[0][2] == board[1][1], board[1][1] == board[2][0], board[0][2] != " " {
            return .win(currentPlayer)
        }
        
        // Check for draw
        if !board.joined().contains(" ") {
            return .draw
        }
        
        return .ongoing
    }
}

// Main game loop
let game = TicTacToe()

while true {
    game.printBoard()
    
    print("Player \(game.currentPlayer.rawValue), enter your move (row and column): ", terminator: "")
    if let input = readLine() {
        let components = input.split(separator: " ")
        if components.count == 2, let row = Int(components[0]), let col = Int(components[1]) {
            let result = game.play(row: row, col: col)
            if case .win(_) = result {
                game.printBoard()
                break
            } else if case .draw = result {
                game.printBoard()
                break
            }
        } else {
            print("Invalid input. Please enter row and column as two numbers separated by a space.")
        }
    }
}

