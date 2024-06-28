%%% MAPPING PROOF TREES TO DIALOGUE STRUCTURE %%%

% Prolog Source Code tested with 
% SWI-Prolog 5.10.1 and SICStus 3.12.8

% VARIABLE NAMING CONVENTIONS (for readability)

% J for Judgement nodes
% JContent and JAgent for content and agent of a judgement
% Entry and Infer for Rule names
% L for Leave nodes which close off a branch of the proof tree
% T for Tree
% D for Dialogue
% R prefix for Remainder (of a list)
% JList records the goals of a tree branch whose success
% needs to be confirmed when they are closed
% (because these goals were introduced through 
% the communicative transfer rule and in the dialogue
% match with an 'ask' speech act)  

% ENCODING OF PROOF TREES

% This definition checks the global structure of the
% tree, it does not check whether the correct rules
% (corresponding with the rule names) have been used.

proof_tree((_J,Entry,_L)):-
   entry_rule_name(Entry).

proof_tree((_J,Infer,[T|RT])):-
   infer_rule_name(Infer),
   proof_tree(T),
   proof_trees(RT).
   
proof_trees([]).
   
proof_trees([T|RT]):-
   proof_tree(T),
   proof_trees(RT).

entry_rule_name(observe).   
entry_rule_name(member).
infer_rule_name(tr).
infer_rule_name(and-intro).
infer_rule_name(and-elim).
infer_rule_name(arrow-intro).
infer_rule_name(arrow-elim).
infer_rule_name(material).

% MAPPING FROM TREES TO DIALOGUE
 
map_tree2dialogue(T,D):-
    proof_tree(T),
	map(T,[],D).

% A transfer (tr) rule introduces an 'ask' speech
% act into the dialogue	
	
map((J,Infer,RT),JList,[ask(JAgent,JContent)|RD]):-  
    Infer = tr,
	!,
    J = (JAgent, JContent),
    RT = [((JAgent2,JContent2),_,_)],	
	map_trees(RT,[(JAgent2,JContent2)|JList],RD).

% Inference rules other than transfer are not expressed
% explicitly in the dialogue	
	
map((_J,Infer,RT),JList,D):-  
    infer_rule_name(Infer),	
	map_trees(RT,JList,D).

% Entry rules which close of a proof branch, lead
% to expression of all the proof goals that have
% now succeeded (i.e., members of JList)
	
map((_J,Entry,_L),JList,D):-  
    entry_rule_name(Entry),	
	express(JList,D).

% The final tree of a sequence of trees
% which all rooted in the same branch
% is associated with the explicitly introduced 
% proof goals (via transfer) of that branch, such that
% when the tree is closed off, confirmation of the
% success of the branch's goals is expressed
% (using the 'confirm' speech act). 
	
map_trees([T],JList,D):-
    map(T,JList,D).	

% The non-final trees of a sequence of trees
% which are all rooted in the same branch
% are not associated explicitly introduced 
% proof goals (via transfer) of that branch, 
% i.e., in map(T1,[],D1) the second argument 
% is the empty list. Thus, only when the final 
% tree that is rooted in the branch has been 
% closed will the succes of the branch's goals be
% expressed (using the 'confirm' speech act).
	
map_trees([T1|RT],JList,D):-
    map(T1,[],D1),
	map_trees(RT,JList,RD),
	append_lists(D1,RD,D).
	
% When a branch of the proof is completed, express is
% called to express all the judgements in that branch 
% that have now been proven
	
express([],[]).	
	 
express([(JAgent,JContent)|T],[confirm(JAgent,JContent)|RT]):-
    express(T,RT).	

% General purpose predicates
	
append_lists([],List,List).

append_lists([H|T],List,[H|NList]):-
   append_lists(T,List,NList).
  
% Examples

my_map_tree2dialogueEx1(T,D):-
   T = ((caller,sd),tr,
           [
		     ((nurse,sd),material,
			    [
				  ((nurse,ht),tr,
				     [
					   ((caller,ht),observe,
					       successful_test
					    )
					 ]
				  )  
				]
			  )
		   ]
		),
	map_tree2dialogue(T,D).	

my_map_tree2dialogueEx2(T,D):-
   T = ((caller,sd),tr,
           [
		     ((nurse,sd),arrow-elim,
			     [
				   ((nurse,imply_ht_sd),member,
				        successful_test
				   ),
				   ((nurse,ht),tr,
				      [
				        ((caller,ht),observe,
						successful_test
						)
					  ]	
				   ) 
				 ]
				
			  )
		   ]
		),
	map_tree2dialogue(T,D).		

my_map_tree2dialogueEx3(T,D):-
   T = ((caller,sd),tr,
           [
		     ((nurse,sd),material,
			    [
				  ((nurse,ht),tr,
				     [
					   ((caller,ht),material,
					       [ 
							((caller,tbiggerthan39),tr,
					           [((partner,tbiggerthan39),observe,
					               successful_test
					             )
								] 
							 )
							] 
					    )
					 ]
				  )  
				]
			  )
		   ]
		),
	map_tree2dialogue(T,D).	
