function [D P]=dijkstra(A,s)

%This function implements Dijkstras Algorithm

%Inputs are the distance matrix A, with 0's on the diagonal and inifities
%on off diagonals where there is no link, and s is the starting node

%Outputs are D, a vector of shortest distances from the starting node to
%every other node, and P, a vector of predecessor nodes in the SPF tree

[x y ]=size(A);
Q=1:x; %not visted nodes

%Checking Conditions

%check that A is not non-empty
if isempty(A)
    error('A is non-empty')
end

%check that A is square
if ~abs(x-y)<=10*eps
    error('A is not square')
end

%check that A has no negative weights
if sum(sum(A<0))>0
    error('There are negative weights in A')
end

%check that we are given a valid starting node
if ~any(abs(Q-s)<= 10*eps)
   error('Starting node is invalid')
end

%check that diagonal elements are zero
if sum(diag(A))>0
   error('Diagonal elements of A are not all zero')
end

%check that the starting node is actually connected to other nodes
if abs(sum(isinf(A(s,:)))-y)<=10*eps
    error('Starting node is not connected to other nodes')
end

%check that we have no NaN values in A
if sum(sum(isnan(A)))>0
    error('There is a NaN value in A')
end

%check that we don't have zeros on off diagonal elements
check=A;
check(eye(size(check))~=0)=NaN;
if sum(any(check==0))>0
    error('There are off diagonal zeros in A. Are these supposed to be infinities?')
end


%initialise distance vector
D=Inf(x,1);
D(s)=0;

%initialise p vector
P=NaN(x,1);


S=[];   %visted nodes

while ~isempty(Q)
    temp=D;
    temp(S)=NaN;                     %set s to NaN as we've already visted these nodes and don't need to look at their shortest paths
    [mindist minnode]=min(temp) ;        %find index and minimum distance of unvisted noddes
    S=[S minnode];                         %add node to visted list
    indexinQ=find(abs(Q-minnode)<=10*eps);  %find which unvisted node this is in the Q vector
    Q(indexinQ)=[]  ;                   %remove node from unvisted list
    for i=Q;         
       %for unvisted nodes find neighbouring distances
        newdistance=mindist+A(minnode,i) ;
        if newdistance<D(i)
            D(i)=newdistance;
            P(i)=minnode;               %set predessor node to minnode
        end
    end
end
