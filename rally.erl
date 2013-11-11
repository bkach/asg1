% Boris Kachscovsky - 9110017317
% Advanced Functional Programming
% Uppsala University
% November 11, 2013
% kachscovsky@gmail.com

-module(rally).
-export([rally/3,toList/1,sepTup/1,advance/2]).

% rally - Begins the rally
-spec rally(_,_,[{non_neg_integer(),_}]) -> non_neg_integer().
rally(MaxAc , MaxBr , Track) -> 
		calcMoves(MaxAc,MaxBr,0,0,(toList(Track))) .

% calcMoves - Calculates how many moves will be needed
-spec calcMoves(_,_,non_neg_integer(),integer(),maybe_improper_list()) -> non_neg_integer().
calcMoves(_,_,Moves,_,[]) -> Moves;
calcMoves(MaxAc,MaxBr,Moves,Speed,Track) ->
		Tiles = Speed + (maxAcc((MaxBr div 10),(MaxAc div 10),Speed,Track)),
		NewTrack = advance(Tiles,Track),
		calcMoves(MaxAc,
				  MaxBr,
				  (Moves+1),
				  (Tiles),
				  (NewTrack)
		          ).

% maxAcc - checks the maximum acceleration possible for a given track
-spec maxAcc(integer(),integer(),integer(),maybe_improper_list()) -> integer().
maxAcc(MaxBr,Acc,Speed,Track) ->
		IsValid = validAcc((Speed+Acc),0,Track,MaxBr),
		case IsValid of
				true -> Acc ;
			    _ -> maxAcc(MaxBr,Acc-1,Speed,Track)
		end	.

% validAcc - checks whether an acceleration is valid or not
-spec validAcc(integer(),non_neg_integer(),maybe_improper_list(),integer()) -> boolean().
validAcc(_,_,[],_) -> true;
validAcc(Speed,Counter,[H|T],MaxBr) ->
		Limit = H div 10,
		case Limit of
				(L) when (L >= Speed) -> 
						validAcc(Speed,Counter+1,T,MaxBr);
				(L) when (L >= ((Speed) - (MaxBr * (Counter div (Speed))))) ->
						validAcc(Speed,Counter+1,T,MaxBr);
				_ -> false 
		end .

% advance - advances the track
-spec advance(_,_) -> any().
advance(_,[]) -> [];
advance(0,L) -> L;
advance(N,[_|T]) -> advance(N-1,T) .

% toList & sepTup - turns a track into a single list
-spec toList([{non_neg_integer(),_}]) -> [any()].

toList(L) -> lists:flatten([sepTup(X) || X <- L]) .
-spec sepTup({non_neg_integer(),_}) -> [any()].

sepTup({0,_}) -> [];
sepTup({X,Y}) -> [Y | sepTup({X-1,Y})] .
