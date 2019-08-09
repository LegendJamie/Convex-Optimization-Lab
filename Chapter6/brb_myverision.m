function [q_opt,optval]=brb(f,red,A,B,epsilon)
% function [q_opt,optval]=brb(f,red,A,B,epsilon)
% 
% Branch and bound algorithm
%
% Inputs
%  f: handle to a function which computes R(x,y) from (6.4)
%  red: handle to function [a,b] = red(a,b) which computes a reduction of [a,b]
%  A: column vector specifying the lower boundary of the initial box
%  B: column vector specifying the upper boundary of the initial box
%  epsilon: desired accuracy
%
% Outputs
%  q_opt: optimizer corresponding to an epsilon-optimal sulution of (6.3)
%  optval: optimal value R(q_opt)
%

% TO DO
B_set={[A,B]};
U_p=f(B_set{1}(:,2),B_set{1}(:,1));
L_p=f(B_set{1}(:,1),B_set{1}(:,1));
while U_p-L_p>epsilon
    U_max=0;
    U_p=0;
    L_p=0;
    for i=1:numel(B_set)
        U=f(B_set{i}(:,2),B_set{i}(:,1));
        if U>U_max
            U_max=U;
            biggest_B=B_set{i};
            biggest_index=i;
        end
    end
    a=biggest_B(:,1);
    b=biggest_B(:,2);
    [~,max_index]=max(b-a);
    e_k=zeros(length(A),1);
    e_k(max_index)=1;
%    B_set{biggest_index}=red(a,b-(b(max_index)-a(max_index))/2*e_k);
%    B_set=[B_set,red(a+(b(max_index)-a(max_index))/2*e_k,b)];
     [a1,b1]=red(a,b-(b(max_index)-a(max_index))/2*e_k);
     [a2,b2]=red(a+(b(max_index)-a(max_index))/2*e_k,b);
     B_set{biggest_index}=[a1,b1];
     B_set=[B_set,[a2,b2]];
%     for i=1:numel(B_set)
%         [a,b]=red(B_set{i}(:,1),B_set{i}(:,2));
%         B_set{i}=[a,b];
%     end
%     for i=1:numel(B_set)
%         U=f(B_set{i}(:,2),B_set{i}(:,1));
%         L=f(B_set{i}(:,1),B_set{i}(:,1));
%         if U>U_p
%             U_p=U;
%         end
%         if L>L_p
%             L_p=L;
%             a=B_set{i}(:,1);
%         end
%     end
    U_p=max(f(b2,a2),f(b1,a1));
    L_p=max(f(a2,a2),f(a1,a1));
    if f(a2,a2)>f(a1,a1)
        a=a2;
    else
        a=a1;
    end
end


q_opt=a;
optval=f(q_opt,q_opt);

end