#using PlotlyJS
using Plots
using UnicodePlots
using Crayons

# Arranged (y, x) not (x, y)
"""
Gets all the moves the player (`to_move`) can make in a `position`.
"""
function get_moves(position::Array, to_move::Int)
    moves = []

    for y in 1:length(position)
        for x in 1:length(position)

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

"""
Checks to see if anyone has won or if the game is draw. Returns `"live"` if the game is ongoing, and `0` if the game is a draw.
"""
function check_victors(pos::Array)

    if -1 in pos[1]
        return -1
    elseif 1 in pos[3]
        return 1
    elseif length(get_moves(pos, 1)) == 0 && length(get_moves(pos, -1)) == 0
        return 0
    end # if

    return "live"
    
end

"""
Use recursive DFS to create a set of links and positions which covers every board state possible in hexapawn and links them together.
"""
function dfs!(pos::Array, links::Array, seen::Array; player = 1)

    for move in get_moves(pos, player)

        if extract(new_p(pos, move), seen) == 0
            # println("Checking: " * string(new_p(pos, move)))
            # println("Links: " * string(links))

            append!(seen, [new_p(pos, move)])
            push!(links, [])

            if check_victors(new_p(pos, move)) == "live"
                dfs!(new_p(pos, move), links, seen, player=player*-1)
            end # If
        end # if

        append!(links[extract(pos, seen)], extract(new_p(pos, move), seen))

    end # for

end # function

#== SELF PLAY ==#

"""
Using `links` to get a new `pos` using the weights from `player`.
"""
function move(pos::Int, player::Array, links::Array)
    
    _move = [0, 0]
    if sum(player[pos]) > 0
        bead = rand(1:sum(player[pos]))
        i = 1
        for m in player[pos]
            if bead > m
                bead -= m
            else
                _move[1] = pos
                pos = links[pos][i]
                _move[2] = i
                break
            end # if
            i += 1
        end # for
    end # if

    return [pos, _move]

end

"""
Pits `w` against `b` for one game. Uses `links` for connections. Returns `[w_moves, b_moves, victor]` (victor according to check_victors()).
If the game goes over 100 moves the function returns `"ERROR"`. There is no real game of hexapawn that lasts longer than ~8 moves.
"""
function pit(w::Array, b::Array, links::Array)

    current_pos = 1
    w_moves = []
    b_moves = []

    for i in 1:100

        if check_victors(positions[current_pos]) != "live"
            return [w_moves, b_moves, check_victors(positions[current_pos])]
        end # if

        out = move(current_pos, w, links)
        current_pos = out[1]
        push!(w_moves, out[2])
        
        if check_victors(positions[current_pos]) != "live"
            return [w_moves, b_moves, check_victors(positions[current_pos])]
        end # if

        out = move(current_pos, b, links)
        current_pos = out[1]
        push!(b_moves, out[2])


    end # for

    return "ERROR"

end # function

"""
Trains the weights in `w` and `b` for `games` games. Bonuses and punishments can be set using `win`, `lose`, and `draw`.
"""
function train!(w::Array, b::Array; games = 200, win = 3, lose = -1, draw = 1, do_plot = false)

    data_to_plot = [[] for l in w]
    println("Training")

    for i in 1:games

        out = pit(w, b, links)

        if out != "ERROR"

            w_moves = out[1]
            b_moves = out[2]
            result = out[3]

            # look for errors in the moves... because they exist and I don't know why?
            kill = false
            for m in w_moves
                if 0 in m
                    kill = true
                    break
                end # if
            end # for
            for m in b_moves
                if 0 in m
                    kill = true
                    break
                end # if
            end # for

            if !kill

                # edit weights based on results
                if result == 1 # W WINS
                    for m in w_moves
                        
                        w[m[1]][m[2]] += win

                    end # for
                    for m in b_moves

                        b[m[1]][m[2]] += lose

                    end # for
                elseif result == -1 # B WINS
                    for m in w_moves
                        
                        w[m[1]][m[2]] += lose

                    end # for
                    for m in b_moves

                        b[m[1]][m[2]] += win

                    end # for
                else # DRAWS
                    for m in w_moves
                        
                        w[m[1]][m[2]] += draw

                    end # for
                    for m in b_moves

                        b[m[1]][m[2]] += draw

                    end # for
                end # if
            
            end # if

            if do_plot

                for d in w
                    append!(data_to_plot[extract(d, w)], sum(d))
                end # for

            end # if

        end # if

    end # for

    println("\n")

    if do_plot

        # plt = lineplot([i for i in 1:length(data_to_plot[1])], [x for x in data_to_plot[1]], name = "box 1", xlabel = "Games", ylabel = "Beads")
        # println(plt)

        filtered = sort([[extract(u, w), sum(u)] for u in w if sum(u) / length(u) != 5 && sum(u) != 0], by= x -> x[2], rev = true)[1:20]
        plt = barplot([string(i[1]) for i in filtered], [x[2] for x in filtered], title = "Sum in box")
        println(plt)

        plt = lineplot([i for i in 1:length(data_to_plot[2])], [x for x in data_to_plot[2]], name = "box 2", xlabel = "Games")
        for box in filtered[1:10]
            lineplot!(plt, [i for i in 1:length(data_to_plot[box[1]])], data_to_plot[box[1]], name = "box " * string(box[1]))
        end # for
        println(plt)

    end # if

end # function

#== ALLOW THE HUMAN TO PLAY IT ==#

"""
Takes a move typed by someone in the format: `Y X, Y X` where 1 1 is the top left.
"""
function human_move(raw::String)
    
    move = [[0, 0], [0, 0]]
    move[1][1] = parse(Int, string(raw[1]))
    move[1][2] = parse(Int, string(raw[3]))
    move[2][1] = parse(Int, string(raw[6]))
    move[2][2] = parse(Int, string(raw[8]))

    return move

end # function

"""
Prints out the current position without all those ugly brackets.
"""
function format(pos::Array)
    
    formatted = [[], [], []]
    for row in 1:length(pos)
        for square in pos[row]
            if square == 0
                append!(formatted[row], "-")
            elseif square == 1
                append!(formatted[row], "W")
            elseif square == -1
                append!(formatted[row], "B")
            end # if
        end # for
    end # for

    for row in formatted
        println(Crayon(reset = true), string(row[1]) * " " * string(row[2]) * " " * string(row[3]))
    end # for

end # function

"""
Does all the pretty human stuff to let humans play a game against the alg.
"""
function play(w::Array, links::Array, positions::Array; base = [[1, 1, 1], [0, 0, 0], [-1, -1, -1]])
    
    println("You play as W/B? ")
    human = uppercase(readline())
    pos = deepcopy(base)

    blue = (150, 150, 255)
    green = (100, 255, 100)

    for i in 1:100

        println()
        println(Crayon(foreground = green, bold = true), "Move " * string(i))
        
        format(pos)

        if human == "W"

            println(Crayon(foreground = blue, bold = false), "Your move? ")
            _move = human_move(readline())
            println(_move)
            println()
            pos = new_p(pos, _move)
            format(pos)

            if check_victors(pos) != "live"
                println(Crayon(foreground = green, bold = true), "The game has ended")
                break
            end # if

        end # if

        println()
        println("ML to move...")
        c_move = move(extract(pos, positions), w, links)
        pos = positions[c_move[1]]
        format(pos)

        if check_victors(pos) != "live"
            println(Crayon(foreground = green, bold = true), "The game has ended")
            break
        end # if

        if human == "B"

            println(Crayon(foreground = blue, bold = false), "Your move? ")
            _move = human_move(readline())
            println(_move)
            println()
            pos = new_p(pos, _move)
            format(pos)

            if check_victors(pos) != "live"
                println(Crayon(foreground = green, bold = true), "The game has ended")
                break
            end # if

        end # if

    end # for

end # function

# Setup
base = [[1, 1, 1], [0, 0, 0], [-1, -1, -1]]
player = 1
positions = [base]
links = [[]]

# DFS
dfs!(base, links, positions)
println("Got " * string(length(positions)) * " positions")

# Setup weights
weights = [[5 for m in l] for l in links]

# Self-play
println("How many games to self-play?")
train!(weights, weights, games=parse(Int, readline()), do_plot=true)

# Human play
play(weights, links, positions)