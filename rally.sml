(*Boris Kachscovsky - 9110017317*)
(*Advanced Functional Programming*)
(*Uppsala University*)
(*November 11, 2013*)
(*kachscovsky@gmail.com*)

fun rally maxAc maxBr track =
let

  val maxAc = maxAc div 10
  val maxBr = maxBr div 10

  (* toList: (tiles,limits)::xs -> limits::xs *)
  fun toList l =
  let
    fun toList' lst [] = lst
      | toList' lst ((0,_)::xs) =
          toList' lst xs
      | toList' lst ((tiles,limit)::xs) =
          toList' (lst @ [limit]) (((tiles-1),limit)::xs)
  in
    toList' [] l
  end;

  (* p: track -> print track *)
  fun p track =
  let
    fun toString str [] = str ^ "\n"
      | toString str (x::xs) = toString ((Int.toString(x)) ^ "|" ^ str) xs
  in
    print(toString "" track)
  end;

  (* validAcc: speed, track -> whether it is a valid speed (acceleration added
   on the input) *)
  fun validAcc speed track =
    let
      fun validAcc' speed counter [] = true
        | validAcc' speed counter (limit::xs) =
        let
          val limit = limit div 10
        in
          if limit >= speed
           then validAcc' speed (counter+1) xs
          else if limit >= ((speed) - (maxBr * (counter div (speed))))
            then validAcc' speed (counter+1) xs
          else false
        end
    in
      validAcc' speed 0 track
    end;

  (* maxAcc: speed track -> maximum acceleration possible *)
  fun maxAcc speed track =
  let
    fun maxAcc' acc speed track =
      if validAcc (speed+acc) track
      then acc
      else maxAcc' (acc-1) speed track
  in
    maxAcc' maxAc speed track
  end
  
  (* maxTiles: speed, track -> max tiles that can be crossed in this turn *)
  fun maxTiles speed track = speed + (maxAcc speed track)

  (* advance: int and list, and advances the list n times *)
  fun advance _ [] = []
    | advance 0 l = l
    | advance n (x::xs) = advance (n-1) xs

  (* rally': takes moves speed and track and returns the number of moves *)
  fun rally' moves _ [] = moves
    | rally' moves speed track =
    let
      val tiles = maxTiles speed track
    in
      rally' (moves + 1) tiles (advance tiles track)
    end
in
  rally' 0 0 (toList(track))
end;

(*rally 30 10 [(10,100),(5,70),(3,40),(6,100),(0,0)];*)
(*rally 40 50 [(15,100),(0,0)];*)
(*rally 40 20 [(1,50),(1,40),(1,30),(1,20),(1,10),(1,20),(1,30),(1,40),(1,50),(0,0)];*)
