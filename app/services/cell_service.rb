class CellService
  def discover(line, col, board)
    return if not validate_discover(line, col, board)
    return if board.lines[line].cells[col].bomb

    board.lines[line].cells[col].discovered = true

    return if board.lines[line].cells[col].close_bombs != 0
    
    discover(line, col + 1, board)
    discover(line, col - 1, board)
    discover(line + 1, col, board)
    discover(line - 1, col, board)
  end

  private
  def validate_discover(line, col, board)
    return false if board.lines.size <= line or board.lines[0].cells.size <= col
    return false if line < 0 or col < 0
    return false if board.lines[line].cells[col].discovered
    true
  end
end
