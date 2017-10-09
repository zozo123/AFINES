(* ::Package:: *)

#!/software/mathematica-10.2-x86_ 64/bin/MathematicaScript -script

dir=$ScriptCommandLine[[2]];

ti=If[Length[$ScriptCommandLine]>2,ToExpression[$ScriptCommandLine[[3]]],1];
tf=If[Length[$ScriptCommandLine]>3,ToExpression[$ScriptCommandLine[[4]]],-1];
vxsz=If[Length[$ScriptCommandLine]>4,ToExpression[$ScriptCommandLine[[5]]],0.1];
nsb=If[Length[$ScriptCommandLine]>5,ToExpression[$ScriptCommandLine[[6]]],10];
np=If[Length[$ScriptCommandLine]>6,ToExpression[$ScriptCommandLine[[7]]],500];
nm=If[Length[$ScriptCommandLine]>7,ToExpression[$ScriptCommandLine[[8]]],11];
thresh=If[Length[$ScriptCommandLine]>8,ToExpression[$ScriptCommandLine[[9]]],1];
fov=If[Length[$ScriptCommandLine]>9,ToExpression/@{$ScriptCommandLine[[10]],$ScriptCommandLine[[11]]},{50,50}];


bx=fov[[1]];
Import["~/Code/cytomod/analysis/cytomod_functions.m"];


nbxs=bx/vxsz;



(*Import actins*)
acts=pts2[dir,"actins"][[ti;;tf,All,1;;2]];


outfile=OpenWrite[dir<>"/analysis/meshsizes_1D_vx"<>ToString[vxsz]<>"_thresh"<>ToString[thresh]<>"_t"<>ToString[ti]<>"-"<>ToString[tf]<>".dat"];
t=ti;
Do[
Print["t = "<>ToString[t]];
(*preprocessing a network by filling in links*)
acallb=Table[mysubdivide[ac[[j*nm+i]],ac[[j nm+i+1]],nsb,fov],{j,0,np-1},{i,1,nm-1}];
(*Print["Bin Counting"];*)
(*Bin Count to make network into black/white image*)
bncnts=BinCounts[Flatten[acallb,2],{-0.5bx,0.5bx,vxsz},{-0.5bx,0.5bx,vxsz}];
bc=Map[If[#>=thresh,1,0]&,bncnts,{2}];

(*rowtots=Total[bc];
coltots=Total/@bc;
mss=N[bx/ReplaceAll[Join[rowtots,coltots],0->1]];*)
(*Print["Sequencing"];*)
s=Table[Flatten[SequenceCases[bc[[All,i]],{p:Repeated[0]}:>{Length[{p}]}]],{i,nbxs}];
s2=Table[Flatten[SequenceCases[bc[[i]],{p:Repeated[0]}:>{Length[{p}]}]],{i,nbxs}];
mss=Flatten[ConstantArray[#*vxsz,#]&/@Flatten[Join[s,s2]]];

(*Print["Writing"];*)

WriteString[outfile,mss,"\n"];
t+=1;,

{ac,acts}
];

Close[outfile];
