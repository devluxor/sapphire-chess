## The minimax algorithm

Pseudocode:

```
function minimax(position, depth, maximizing_player)
	if depth == 0 or game over in position
		return static evaluation of position
 
	if maximizingPlayer
		max_evaluation = -infinity
		for each child of position
			eval = minimax(child, depth - 1, false)
			maxEval = max(maxEval, eval)
		return maxEval
 
	else
		minEval = +infinity
		for each child of position
			eval = minimax(child, depth - 1, true)
			minEval = min(minEval, eval)
		return minEval
 
 
// initial call
minimax(currentPosition, 3, true)
```

In Ruby:

```ruby
def minimax(position, depth, maximizing_player)
  return position evaluation (score?) if depth.zero? || checkmate?

  if maximizing_player # White player?
    max_evaluation = -Float::INFINITY

    position_childs.each do |position|
      evaluation = minimax(max_evaluation, depth - 1, false)
      max_evaluation = [evaluation, max_evaluation].max
    end

    return max_evaluation
  else
    min_evaluation = -Float::INFINITY

    position_childs.each do |position|
      evaluation = minimax(min_evaluation, depth - 1, true)
      min_evaluation = [evaluation, min_evaluation].min
    end

    return min_evaluation
  end
end

# Initial call
minimax(current_position, 3, true)
```

`minimax` = name of the method

`position` = the board?

`depth` = levels of the tree

`maximizing_player` = if true, white, else, black 
(white wants max. values, black wants min. values.
the score can be determined by the sum of the score of the pieces?
black: negative scores,
white: positive scores)

`max_evaluation` = max. evaluation found

child of position?

`evaluation` = 'current' evaluation

