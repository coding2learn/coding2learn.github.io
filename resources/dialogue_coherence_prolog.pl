  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% MEANING AND DIALOGUE COHERENCE PROLOG CODE %%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%% Author: Paul Piwek              
  %%% Copyright: The Open University 
  %%% Homepage: http://mcs.open.ac.uk/pp2464/resources  

  %%% Tested with SWI Prolog 5.6.12 
   

/* 

In Piwek (submitted) we investigate a number of systems of the
following form:

S = <I,D_P,m>
I = <L,A,C,R,>

Key
---

S : System
I : Inference System
D_P : Set of Potential Dialogues
m : mapping from Proof (Search) Trees to Dialogues (D, a subset of D_P)
L : Logical Language
A : Agents and their Assumptions
C : Channels
R : Hybrid Inference Rules 

This file contains the prolog code for the mapping m from Proof (Search)
Trees to representations of dialogue structures for a number of the systems 
in Piwek (submitted).

Reference
---------

Piwek, P. (2006). Meaning and Dialogue Coherence: A Proof-theoretic Investigation.
Manuscript. Submitted.

*/

/*

System 1
--------

D_P = empty | 
      alpha_i: alpha_j, A (given that H)? | 
      alpha_i: A (given that H) |
      alpha_i: I am wondering whether A (given that H) |
      alpha_i: Then I conclude A (given that H).  

D_I = empty | 
      alpha_i:goal_derive(A, given that H) | 
      alpha_i:confirmed(A, given that H) | 
      alpha_i:in_assumptions(A)

Example
-------
    
    Gamma_alpha = {}
    Gamma_beta = {a}
    Gamma_gamma = {b}


 a in Gamma_beta   b in Gamma_beta
----------------  ----------------
 beta: {} |- a     gamma: {} |- b 
---------------   --------------- 
 alpha: {} |-a     alpha: {} |- b 
 --------------------------------
    alpha: {} |- a/\b

After the proof search the following will
be a subset of Gamma_alpha: {a,b}


Linearization
-------------

Step 1:

alpha:goal_derive(a/\b,given_that,[])
 alpha: (transfer) goal_derive(a,given_that,[]) (tr.)
  beta:goal_derive(a,given_that,[]) 
  beta:in_assumptions(a) 
  beta:confirmed(a,given_that,[])
 alpha:confirmed(a,given_that,[])
 alpha: (transfer) goal_derive(b,given_that,[]) (tr.)
  gamma:goal_derive(b,given_that,[]) 
  gamma:in_assumptions(b) 
  gamma:confirmed(b,given_that,[])
 alpha:confirmed(b,given_that,[])
alpha:confirmed(a/\b,given_that,[])

Step 2:

alpha: I am wondering whether a/\b.
alpha: beta, a?
beta: a.
alpha: gamma, b?
gamma: b.
alpha: Then I conclude a/\b. 

Sketch of operations to go from 1 to 2:

- merge X (tr.) Y 
- map in_assumptions, confirm to statement
- map confirm to 'then ...'
- omit repetitions of information (e.g., confirmed(a),
  confirmed(a))
 
*/

% System 1 mapping

%%% map1_1

/*

 In map1_1((M,Rule,R1),Result) 
 M has one the following forms:
 
 1. judgement(Agent,AssumptionsList,Conclusion)
 2. membership(Agent,Conclusion,ExtGlobContext)

EITHER A. Result = append of M1 R2 and M2 with

 M1 has one of the following forms:
  
 1. (Agent,goal_derive(A,given_that,H))
 2. (Agent,transfer,goal_derive(A,given_that,H))

 M2 is

 3. (Agent,confirmed(A,given_that,H))

OR B. Result = (Agent,in_assumptions(A))

*/

map1(A,C):-
   map1_1(A,B),
   write('MAP1_1 RESULT:'),nl,
   my_print_list(B),nl,nl,
   map1_2(B,C),
   write('MAP1_2 RESULT:'),nl,
   my_print_list(C).

map1_1((M,_Rule,[]),[(Agent,in_assumptions(Conclusion))]):-
   M = membership(Agent,Conclusion,_ExtGlobContext).

map1_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  \+ Rule = tr,
  M1 = [(Agent,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,confirmed(Conclusion,given_that,AssumptionsList))],
  list_map1_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

map1_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  Rule = tr,
  M1 = [(Agent,transfer,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,confirmed(Conclusion,given_that,AssumptionsList))],
  list_map1_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

list_map1_1([],[]).

list_map1_1([H1|T1],Result):-
   map1_1(H1,H2),
   list_map1_1(T1,T2),
   append(H2,T2,Result).

my_print_list([]).
my_print_list([H|T]):-
   write(H),nl,
   my_print_list(T).

/* EXAMPLES

map1( 
        (
          judgement(alpha,[],and(a,b)),
          member,
           [(
             membership(alpha,and(a,b),context_alpha),_,[]
            )
           ]
         ),
         Result).

MAP1_1 RESULT:
alpha, goal_derive(and(a, b), given_that, [])
alpha, in_assumptions(and(a, b))
alpha, confirmed(and(a, b), given_that, [])

MAP1_2 RESULT:
alpha, i_am_wondering_whether, and(a, b), given_that, []
alpha, and(a, b), given_that, []

map1( 
        (
          judgement(alpha,[],and(a,b)),
          intro,
           [(
             judgement(alpha,[],a),tr,
                     [
                      ( 
                       judgement(beta,[],a),member,
                           [
                              (
                               membership(beta,a,context_beta),_,[]
                              )  
                           ]
                      )  
                     ]
            ),

           ( 
             judgement(alpha,[],b),tr,
                     [
                      ( 
                       judgement(gamma,[],b),member,
                           [
                              (
                               membership(gamma,b,context_gamma),_,[]
                              )  
                           ]
                      )  
                     ]
            )


           ]
         ),
         _Result).

MAP1_1 RESULT:
alpha, goal_derive(and(a, b), given_that, [])
alpha, transfer, goal_derive(a, given_that, [])
beta, goal_derive(a, given_that, [])
beta, in_assumptions(a)
beta, confirmed(a, given_that, [])
alpha, confirmed(a, given_that, [])
alpha, transfer, goal_derive(b, given_that, [])
gamma, goal_derive(b, given_that, [])
gamma, in_assumptions(b)
gamma, confirmed(b, given_that, [])
alpha, confirmed(b, given_that, [])
alpha, confirmed(and(a, b), given_that, [])

MAP1_2 RESULT:
alpha, i_am_wondering_whether, and(a, b), given_that, []
alpha, beta, a, ?, given_that, []
beta, a, given_that, []
alpha, gamma, b, ?, given_that, []
gamma, b, given_that, []
alpha, confirmed(and(a, b), given_that, [])
*/

%%% map1_2

/*

- merge X (tr.) Y 
- map in_assumptions, confirm to statement
- map confirm to 'then ...'
- omit repetitions of information (e.g., confirmed(a),
  confirmed(a))

*/

map1_2(In,Out):-
  my_replace(
      (
       [(Alpha1, goal_derive(A1, given_that,H1))],
       [(Alpha1,i_am_wondering_whether,A1,given_that,H1)]
       ),
        In,Out1),
  my_replace(
       ([(Alpha2,transfer,goal_derive(A2, given_that,H2)),
         (Alpha3,i_am_wondering_whether,A2,given_that,H2)],
        [(Alpha2,Alpha3,A2,'?',given_that,H2)] 
       ), 
        Out1,Out2),
  my_replace(
       (
        [(Alpha5, confirmed(A4, given_that,H4)),
         (_Alpha6, confirmed(A4, given_that,H4))],
        [(Alpha5, confirmed(A4, given_that,H4))]
       ),
        Out2,Out3),
  my_replace(
       (
        [(Alpha4,in_assumptions(A3)),
         (Alpha4, confirmed(A3, given_that,H3))],
        [(Alpha4,A3,given_that,H3)]
       ),
        Out3,Out).

/*

2 ?- my_replace(([a],[x]),[a,b,b,b,a,a,b],R).

R = [x, b, b, b, x, x, b] 

4 ?- my_replace(([a,b],[x,y]),[a,b,b,a,b,a,b,a,b],R).

R = [x, y, b, x, y, x, y, x, y] 

5 ?- my_replace(([a,b],[z]),[a,b,a,b,c,c,c,c,a,b,v,a,b],R).

R = [z, z, c, c, c, c, z, v, z]

*/

my_replace(_Pattern,[],[]).

% Pattern [X] to [Y]

my_replace(([X],[Y]),[H1|T1],[H2|T2]):-
  copy_term(([X],[Y]),([X_new],[Y_new])),
  X = H1,!,
  H2 = Y,
  my_replace(([X_new],[Y_new]),T1,T2).

my_replace(([X],[Y]),[H1|T1],[H2|T2]):-
  H2 = H1,  
  my_replace(([X],[Y]),T1,T2).

% Pattern [X1,X2] to [Y1,Y2]

my_replace(([X1,X2],[Y1,Y2]),[H1A,H1B|T1],[H2A|T2]):-
  copy_term(([X1,X2],[Y1,Y2]),([X1new,X2new],[Y1new,Y2new])),
  [X1,X2] = [H1A,H1B],!,
  [H2A,H2B] = [Y1,Y2],
  my_replace(([X1new,X2new],[Y1new,Y2new]),[H2B|T1],T2).

my_replace(([X1,X2],[Y1,Y2]),[H1|T1],[H2|T2]):-
  H2 = H1,  
  my_replace(([X1,X2],[Y1,Y2]),T1,T2).

% Pattern [X1,X2] to [Y1]

my_replace(([X1,X2],[Y1]),[H1A,H1B|T1],[H2A|T2]):-
  copy_term(([X1,X2],[Y1]),([X1new,X2new],[Y1new])),
  [X1,X2] = [H1A,H1B],!,
  [H2A] = [Y1],
  my_replace(([X1new,X2new],[Y1new]),T1,T2).

my_replace(([X1,X2],[Y1]),[H1|T1],[H2|T2]):-
  H2 = H1,  
  my_replace(([X1,X2],[Y1]),T1,T2).


% System 2

/*

We now have alternative proof paths in the tree. We need a predicate which
given a tree tells us whether it represents a successful search or not. We should
be able to define this recursively on trees.

Proof_Search_Tree :== alt([List_Proof_Search_Trees])
Proof_Search_Tree :== (judgement(Agent,AssumptionsList,Conclusion),[List_Proof_Search_Trees])
Proof_Search_Tree :== (membership(Agent,Conclusion,_ExtGlobContext),[])

ASSUMPTION: Proof Search Proceeds left-to-right

D_I = empty | 
      alpha_i:goal_derive(A, given that H) | 
      alpha_i:confirmed(A, given that H) | 
      alpha_i:in_assumptions(A) |
      alpha_i:not_resolved(A, given that H)
*/

map2(A,C):-
   map2_1(A,B),
   write('MAP2_1 RESULT:'),nl,
   my_print_list(B),nl,nl,
   map2_2(B,C),
   write('MAP2_2 RESULT:'),nl,
   my_print_list(C).

map2_1((M,_Rule,[]),[(Agent,in_assumptions(Conclusion))]):-
   M = membership(Agent,Conclusion,_ExtGlobContext).

% alternatives are all mapped
%
%map2_1(alt(R1),R2):-
%  list_map2_1(R1,R2).

% incomplete proof branches:

map2_1((M,_Rule,[]),[(Agent,goal_derive(Conclusion,given_that,AssumptionsList)),
                    (Agent,not_resolved(Conclusion,given_that,AssumptionsList))]):-
  M = judgement(Agent,AssumptionsList,Conclusion).

% For proof search trees containing a proof and
% transfer

map2_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  \+ Rule = tr,
  \+ R1 = alt(_),
  contain_proof((M,Rule,R1)),
  M1 = [(Agent,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,confirmed(Conclusion,given_that,AssumptionsList))],
  list_map2_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

% For proof search trees containing a proof and
% no transfer

map2_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  Rule = tr,
  \+ R1 = alt(_),
  contain_proof((M,Rule,R1)),
  M1 = [(Agent,transfer,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,confirmed(Conclusion,given_that,AssumptionsList))],
  list_map2_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

% For proof search trees containing no proof and
% no transfer

map2_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  \+ Rule = tr,
  \+ R1 = alt(_),
  \+ contain_proof((M,Rule,R1)),
  M1 = [(Agent,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,not_resolved(Conclusion,given_that,AssumptionsList))],
  list_map2_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

% For proof search trees containing no proof and
% transfer

map2_1((M,Rule,R1),R4):-
  M = judgement(Agent,AssumptionsList,Conclusion),
  Rule = tr,
  \+ R1 = alt(_),
  \+ contain_proof((M,Rule,R1)),
  M1 = [(Agent,transfer,goal_derive(Conclusion,given_that,AssumptionsList))],
  M2 = [(Agent,not_resolved(Conclusion,given_that,AssumptionsList))],
  list_map2_1(R1,R2),
  append(M1,R2,R3),
  append(R3,M2,R4).

% For proof search trees where the judgement is followed by a number
% of alternatives

map2_1((M,Rule,R1),R4):-
  M = judgement(_Agent,_AssumptionsList,_Conclusion),
  R1 = alt(_AltList),
  map2_1_alt((M,Rule,R1),R4).

map2_1_alt((_M,_Rule,alt([])),[]).
  
map2_1_alt((M,Rule,alt([H|T])),Result):-
  map2_1((M,Rule,[H]),R1),  
  map2_1_alt((M,Rule,alt(T)),R2),
  append(R1,R2,Result).

list_map2_1([],[]).

list_map2_1([H1|T1],Result):-
   map2_1(H1,H2),
   list_map2_1(T1,T2),
   append(H2,T2,Result).

contain_proof((judgement(Agent,_AssumptionsList,Conclusion),_RuleName,
                 [(membership(Agent,Conclusion,_ExtGlobContext),_R,[])])).

% Relies on left-to-right assumption of proof search tree structure:

contain_proof((judgement(_Agent,_AssumptionsList,_Conclusion),_RuleName,alt(List))):-
   reverse(List,[H|_T]),
   contain_proof(H).

contain_proof((judgement(_Agent,_AssumptionsList,_Conclusion),_RuleName,List)):-
   all_contain_proof(List).

all_contain_proof([H]):-
   contain_proof(H).

all_contain_proof([H|T]):-
   contain_proof(H),
   all_contain_proof(T).

/*

Operations to go from 1 to 2:

- map goal_derive to i_am_interested_in
- merge X (tr.) Y 
- map in_assumptions, confirm to statement
- omit repetitions of information
- map not_resolved to 'I don't know'
- map not_resolved not_resolved to 'I don't Know. Right'.  

*/

map2_2(In,Out):-
  my_replace(
      (
       [(Alpha1, goal_derive(A1, given_that,H1))],
       [(Alpha1,i_am_wondering_whether,A1,given_that,H1)]
       ),
        In,Out1),
  my_replace(
       ([(Alpha2,transfer,goal_derive(A2, given_that,H2)),
         (Alpha3,i_am_wondering_whether,A2,given_that,H2)],
        [(Alpha2,Alpha3,A2,'?',given_that,H2)] 
       ), 
        Out1,Out2),
  my_replace(
       (
        [(Alpha5, confirmed(A4, given_that,H4)),
         (_Alpha6, confirmed(A4, given_that,H4))],
        [(Alpha5, confirmed(A4, given_that,H4))]
       ),
        Out2,Out3),
  my_replace(
       (
        [(Alpha4,in_assumptions(A3)),
         (Alpha4, confirmed(A3, given_that,H3))],
        [(Alpha4,A3,given_that,H3)]
       ),
        Out3,Out4),
  my_replace(
       (
        [(Alpha7, not_resolved(A5, given_that,H5)),
         (_Alpha8, not_resolved(A5, given_that,H5))],
        [(Alpha7, not_resolved(A5, given_that,H5))]
       ),       
        Out4,Out5),
  my_replace(
       (
        [(Alpha9, not_resolved(A6, given_that,H6))],
        [(Alpha9, i_dont_know_whether(A6, given_that,H6))]
       ),       
        Out5,Out).       
        

/* EXAMPLE

map2((judgement(beta,[],a),tr,   
         alt([(judgement(alpha,[],a),member,
           [(membership(alpha,a,[a]),_R,[])])])
      )     
           ,Result).

MAP2_1 RESULT:
beta, transfer, goal_derive(a, given_that, [])
alpha, goal_derive(a, given_that, [])
alpha, in_assumptions(a)
alpha, confirmed(a, given_that, [])
beta, confirmed(a, given_that, [])


MAP2_2 RESULT:
beta, alpha, a, ?, given_that, []
alpha, a, given_that, []

map2((judgement(beta,[],a),tr,   
         alt([(judgement(alpha,[],a),none,
           [])])
      )     
           ,Result).

MAP2_1 RESULT:
beta, transfer, goal_derive(a, given_that, [])
alpha, goal_derive(a, given_that, [])
alpha, not_resolved(a, given_that, [])
beta, not_resolved(a, given_that, [])

MAP2_2 RESULT:
beta, alpha, a, ?, given_that, []
alpha, i_dont_know_whether(a, given_that, [])
map2((judgement(alpha,[],a),member,
           [(membership(alpha,a,[a]),_R,[])]),Result).

map2( 
        (
          judgement(alpha,[],and(a,b)),
          intro,
           [ % first proof tree branch:
            (
             judgement(alpha,[],a),tr,
                alt([

                     ( % first alternative (fail):
                       judgement(beta,[],a),none,
                           [  
                           ]
                      ),

                     ( % second alternative (succeed): 
                       judgement(gamma,[],a),member,
                           [
                              (
                               membership(gamma,a,context_gamma),_,[]
                              )  
                           ]
                      )   
                    ]) % close alt
                  ),  
                
            
            % second proof tree branch: 
           ( 
             judgement(alpha,[],b),tr,
                     [
                      ( 
                       judgement(gamma,[],b),member,
                           [
                              (
                               membership(gamma,b,context_gamma),_,[]
                              )  
                           ]
                      )  
                     ]
            )


           ]
         ),
         _Result).

MAP2_1 RESULT:
alpha, goal_derive(and(a, b), given_that, [])
alpha, transfer, goal_derive(a, given_that, [])
beta, goal_derive(a, given_that, [])
beta, not_resolved(a, given_that, [])
alpha, not_resolved(a, given_that, [])
alpha, transfer, goal_derive(a, given_that, [])
gamma, goal_derive(a, given_that, [])
gamma, in_assumptions(a)
gamma, confirmed(a, given_that, [])
alpha, confirmed(a, given_that, [])
alpha, transfer, goal_derive(b, given_that, [])
gamma, goal_derive(b, given_that, [])
gamma, in_assumptions(b)
gamma, confirmed(b, given_that, [])
alpha, confirmed(b, given_that, [])
alpha, confirmed(and(a, b), given_that, [])

MAP2_2 RESULT:
alpha, i_am_wondering_whether, and(a, b), given_that, []
alpha, beta, a, ?, given_that, []
beta, i_dont_know_whether(a, given_that, [])
alpha, gamma, a, ?, given_that, []
gamma, a, given_that, []
alpha, gamma, b, ?, given_that, []
gamma, b, given_that, []
alpha, confirmed(and(a, b), given_that, [])

map2( 
           ( 
             judgement(alpha,[],b),tr,
                     [
                      ( 
                       judgement(gamma,[],b),member,
                           [
                              (
                               membership(gamma,b,context_gamma),_,[]
                              )  
                           ]
                      )  
                     ]
            )           
         ,
         _Result).

MAP2_1 RESULT:
alpha, transfer, goal_derive(b, given_that, [])
gamma, goal_derive(b, given_that, [])
gamma, in_assumptions(b)
gamma, confirmed(b, given_that, [])
alpha, confirmed(b, given_that, [])

MAP2_2 RESULT:
alpha, gamma, b, ?, given_that, []
gamma, b, given_that, []

Testing (not a realistic proof search tree):

map2( 
        (
          judgement(alpha,[],and(a,b)),
          intro,
           [ 
            (
             judgement(alpha,[],a),tr,
               
                alt([

                     ( % first alternative (fail):
                       judgement(beta,[],a),none,
                           [  
                           ]
                      ),

                     ( % second alternative (succeed): 
                       judgement(gamma,[],a),member,
                           [
                              (
                               membership(gamma,a,context_gamma),_,[]
                              )  
                           ]
                      )   
                    ]) % close alt
                
            )])
            ,
         _Result).

alpha, goal_derive(and(a, b), given_that, [])
alpha, transfer, goal_derive(a, given_that, [])
beta, goal_derive(a, given_that, [])
beta, not_resolved(a, given_that, [])
alpha, not_resolved(a, given_that, [])
alpha, transfer, goal_derive(a, given_that, [])
gamma, goal_derive(a, given_that, [])
gamma, in_assumptions(a)
gamma, confirmed(a, given_that, [])
alpha, confirmed(a, given_that, [])
alpha, confirmed(and(a, b), given_that, [])

MAP2_2 RESULT:
alpha, i_am_wondering_whether, and(a, b), given_that, []
alpha, beta, a, ?, given_that, []
beta, i_dont_know_whether(a, given_that, [])
alpha, gamma, a, ?, given_that, []
gamma, a, given_that, []
alpha, confirmed(and(a, b), given_that, [])

Single agent reasoning:

map2( 
        (
          judgement(alpha,[],and(a,b)),
          intro,
           [ 
            ( % first branch: 
                       judgement(alpha,[],a),member,
                           [
                              (
                               membership(alpha,a,context_alpha),_,[]
                              )  
                           ]
                      ),   
                    
              ( % second branch: 
                       judgement(alpha,[],b),member,
                           [
                              (
                               membership(alpha,b,context_alpha),_,[]
                              )  
                           ]
                      )  
            ])
            ,
         _Result).

MAP2_1 RESULT:
alpha, goal_derive(and(a, b), given_that, [])
alpha, goal_derive(a, given_that, [])
alpha, in_assumptions(a)
alpha, confirmed(a, given_that, [])
alpha, goal_derive(b, given_that, [])
alpha, in_assumptions(b)
alpha, confirmed(b, given_that, [])
alpha, confirmed(and(a, b), given_that, [])

MAP2_2 RESULT:
alpha, i_am_wondering_whether, and(a, b), given_that, []
alpha, i_am_wondering_whether, a, given_that, []
alpha, a, given_that, []
alpha, i_am_wondering_whether, b, given_that, []
alpha, b, given_that, []
alpha, confirmed(and(a, b), given_that, [])

*/
