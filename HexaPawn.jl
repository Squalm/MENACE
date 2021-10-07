#== SETUP BOXES ==#
p_ref = Dict(
    [ # Move 1
        1, 1, 1,
        0, 0, 0,
        -1, -1, -1
    ]  => [],
    [ # Move 2
        0, 1, 1,
        1, 0, 0,
        -1, -1, -1
    ] => [],
    [
        1, 0, 1,
        0, 1, 0,
        -1, -1, -1
    ] => [],
    [ # Move 3
        0, 1, 1,
        -1, 0, 0,
        -1, 0, -1
    ] => [],
    [
        0, 1, 1,
        1, -1, 0,
        -1, 0, -1
    ] => [],
    [
        0, 1, 1,
        1, 0, -1,
        -1, -1, 0
    ] => [],
    [
        1, 0, 1,
        -1, 1, 0,
        0, -1, -1
    ] => [],
    [
        1, 0, 1,
        0, -1, 0,
        0, -1, -1
    ] => [],
    [ # Move 4
        0, 0, 1,
        -1, 1, 0,
        -1, 0, -1
    ] => [],
    [
        0, 0, 1,
        1, -1, 0,
        0, -1, -1
    ] => [],
    [
        0, 1, 0,
        1, 1, 0,
        -1, 0, -1
    ] => [],
    [
        0, 0, 1,
        1, 0, 1,
        -1, -1, 0
    ] => [],
    [
        1, 0, 0,
        0, -1, 1,
        0, -1, -1
    ] => [],
    [
        1, 0, 0,
        -1, 1, 1,
        0, -1, -1
    ] => [],
    [
        0, 1, 0,
        -1, 0, 1,
        -1, 0, -1
    ] => [],
    [
        0, 0, 1,
        1, 1, -1,
        -1, -1, 0
    ] => [],
    [
        0, 0, 1,
        0, 1, 0,
        0, -1, -1
    ] => [],
    [
        1, 0, 0,
        0, 1, 0,
        0, -1, -1
    ] => [],
    [
        0, 0, 1,
        1, 0, 0,
        -1, 0, -1
    ] => [],
    [ # Move 6
        0, 0, 0,
        -1, -1, 1,
        0, 0, -1
    ] => [],
    [
        0, 0, 0,
        1, 1, 1,
        -1, 0, 0
    ] => [],
    [
        0, 0, 0,
        -1, 1, 1,
        0, -1, 0
    ] => [],
    [
        0, 0, 0,
        1, 1, -1,
        0, -1, 0
    ] => [],
    [
        0, 0, 0,
        -1, -1, 1,
        -1, 0, 0
    ] => [],
    [
        0, 0, 0,
        1, -1, -1,
        0, 0, -1
    ] => [],
    [
        0, 0, 0,
        -1, 1, 0,
        0, 0, -1,
    ] => [],
    [
        0, 0, 0,
        1, -1, 0,
        0, -1, 0
    ] => [],
    [
        0, 0, 0,
        0, -1, 1,
        0, -1, 0
    ] => [],
    [
        0, 0, 0,
        -1, 1, 0,
        -1, 0, 0
    ] => [],
    [
        0, 0, 0,
        0, 1, -1,
        0, 0, -1
    ] => []
)

b_positions = []

println(p_ref)