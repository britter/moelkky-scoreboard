module ScoreCalculation exposing (calculateScores)


calculateScores : List Int -> Int -> List Int
calculateScores scores newScore =
    let
        total =
            List.sum scores

        newTotal =
            total + newScore
    in
    case ( scores, newScore ) of
        ( 0 :: 0 :: _, 0 ) ->
            if total < 15 then
                -total :: scores

            else
                -15 :: scores

        ( _, _ ) ->
            if newTotal > 50 then
                -(total - 25) :: scores

            else
                newScore :: scores
