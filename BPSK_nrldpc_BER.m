EbNodB = 4;
MaxItrs = 8;
rate_matching = 0;

load base_matrices\NR_1_0_16.txt;
B = NR_1_0_16;
[mb, nb] = size(B);
z = 16;

Slen = sum(B(:)~=-1);   %number of non '-1' in B
treg = zeros(max(sum(B~=-1,2)),z); %register storage for minsum

k = (nb - mb)*z;
n = nb*z;
if rate_matching == 1
    n = n -2*z;
end
Rate = k/n;                     
EbNo = 10^(EbNodB/10);              
sigma = sqrt(1/(2*Rate*EbNo));


Nbiterrs = 0; Nblkerrs = 0; Nblocks = 100;

for i = 1 : Nblocks
   %msg = randi([0 1],1,k);           %generate random message
   msg = zeros(1,k); % all-zero msg 
   
   %Encoding here
   cword = zeros(1,n);
      
   s = 1 - (2 * cword);                 %BPSK symbols
   r = s + sigma * randn(1,n);          %AWGN Channel
 
   %puncturing
   if rate_matching == 1
   r(1:2*z) = 0;
   end
   
   %Soft-Decision, iterative message-passing layered decoding here
   L = r;   % Total Belief
   itr = 0; % iteration number
   R = zeros(Slen, z);     %storage for row processing
   while itr < MaxItrs
       Ri = 0;
        for lyr = 1:mb
            ti = 0; % number of non -1 in row = lyr
            for col = 1:nb
                if B(lyr,col) ~= -1
                    ti = ti + 1;
                    Ri = Ri + 1;
                    %Substraction
                    L((col-1)*z+1:col*z) = L((col-1)*z+1:col*z) - R(Ri,:);
                    %Row alignment and store in treg
                    treg(ti,:) = mul_sh(L((col-1)*z+1:col*z),B(lyr,col));
                end  
            end
            %minsum on treg: ti x z
            for i1 = 1:z %treg(1:ti,i1)
                [min1, pos] = min(abs(treg(:,i1))); %first min
                min2 = min(abs(treg([1:pos-1 pos+1:ti],i1))); %second min
                S = sign(treg(1:ti,i1));
                parity = prod(S);
                treg(1:ti,i1) = min1; %absolute value for all
                treg(pos,i1) = min2; %absolute value for min1 position
                treg(1:ti,i1) = parity * S.*treg(1:ti,i1); %assign signs
            end
            %column alignment, addition and store in R
            Ri = Ri - ti; %reset the storage counter
            ti = 0;
            for col = 1:nb
                if B(lyr,col) ~= -1
                    Ri= Ri + 1;
                    ti = ti + 1;
                    %Column alignment
                    R(Ri,:) = mul_sh(treg(ti,:), z-B(lyr,col));
                    %Addition
                    L((col-1)*z+1:col*z) = L((col-1)*z+1:col*z) + R(Ri,:);
                end
            end
        end
        msg_cap = L(1:k) < 0; %decision
        itr = itr + 1;
   end

   Nerrs = sum(msg ~= msg_cap);
   
   if(Nerrs > 0)
      Nbiterrs = Nbiterrs + Nerrs;
      Nblkerrs = Nblkerrs + 1;
   end
end

BER_sim = Nbiterrs/(k*Nblocks);
FER_sim = Nblkerrs/Nblocks;

disp([EbNodB BER_sim FER_sim Nbiterrs k*Nblocks]);
