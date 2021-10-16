# Use dfs to find all the positions

# Arranged (y, x) not (x, y)
"""
Gets all the positive move the player (`to_move`) can make in a `position`.
"""
function get_moves(position::Array, to_move::Int)
    moves = []

    for y in 1:3
        for x in 1:3

            if position[y][x] == to_move
                
                if isassigned(position, y + to_move)
                    if position[y + to_move][x] == 0
                        push!(moves, [[y, x], [y + to_move, x]])
                    end # if

                    if isassigned(position[y+to_move], x + 1)
                        if position[y + to_move][x + 1] == to_move * -1
                            push!(moves, [[y, x], [y + to_move, x + 1]])
                        end # if
                    end # if
                    if isassigned(position[y+to_move], x - 1)
                        if position[y + to_move][x - 1] == to_move * -1
                            push!(moves, [[y, x], [y + to_move, x - 1]])
                        end # if
                    end # if
                end # if

            end # if

        end #for
    end # for

    return moves

end # function

"""
Returns a position which is `pos` with the `move` made. The returned array is a deepcopy.
"""
function new_p(pos::Array, move::Array)
    _pos = deepcopy(pos)
    _pos[move[2][1]][move[2][2]] = _pos[move[1][1]][move[1][2]]
    _pos[move[1][1]][move[1][2]] = 0

    return _pos
end # function

"""
Gets the index of some `value` in an `array`. Returns `0` if the value does not exist in the array.
"""
function extract(value::Any, array::Array)
    for i in 1:length(array)
        if array[i] == value
            return i
        end # if
    end # for
    return 0
end # function

# time to rewrite with recursive dfs for tracking which player is on
function dfs!(pos::Array, links::Array, seen::Array; player = 1)
    
    # stack = [pos]

    #== temp
    while length(stack) > 0

        s = stack[end]
        pop!(stack)

        if extract(s, seen) == 0
            append!(seen, s)
            println("Checking: " * string(s))
        end # if

        moves = get_moves(s, player)

        i = 1
        while i <= length(moves)
            if extract(new_p(s, moves[i]), seen) == 0
                append!(stack, [new_p(s, moves[i])])
            end # if
            i += 1
        end # while
        # println("Stack: " * string(stack))
        # println("Seen: " * string(seen))

    end # while
    ==#

    for move in get_moves(pos, player)

        if extract(new_p(pos, move), seen) == 0
            # println("Checking: " * string(new_p(pos, move)))
            # println("Links: " * string(links))

            append!(seen, [new_p(pos, move)])
            push!(links, [])

            dfs!(new_p(pos, move), links, seen, player=player*-1)
        end # if

        append!(links[extract(pos, seen)], extract(new_p(pos, move), seen))

    end # for

end # function

base = [[1, 1, 1], [0, 0, 0], [-1, -1, -1]]
player = 1
positions = [base]
links = [[]]

dfs!(base, links, positions)

println("Ps: " * string(positions))
println("Links: " * string(links))
