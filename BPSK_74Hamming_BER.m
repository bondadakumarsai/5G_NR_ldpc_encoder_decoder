EbNodB = 1;
R = 4/7;                            %(7,4) Hamming Code (4/7 bits/symbol)%
EbNo = 10^(EbNodB/10);              
sigma = sqrt(1/(2*R*EbNo));

%%BER_th = 0.5*erfc(sqrt(EbNo));


k = 4;                              %Number of Bits of message per block
n = 7;                              %Number of codeword bits   

cwords = [0     0     0     0     0     0     0;
     0     0     0     1     0     1     1;
     0     0     1     0     1     1     0;
     0     0     1     1     1     0     1;
     0     1     0     0     1     1     1;
     0     1     0     1     1     0     0;
     0     1     1     0     0     0     1;
     0     1     1     1     0     1     0;
     1     0     0     0     1     0     1;
     1     0     0     1     1     1     0;
     1     0     1     0     0     1     1;
     1     0     1     1     0     0     0;
     1     1     0     0     0     1     0;
     1     1     0     1     0     0     1;
     1     1     1     0     1     0     0;
     1     1     1     1     1     1     1];


Nbiterrs = 0; Nblkerrs = 0;

Nblocks = 1000;
for i = 1 : Nblocks
   msg = randi([0 1],1,k);           %generate random message
   %Encoding here
   cword = [msg mod(msg(1)+msg(2)+msg(3),2)...
                mod(msg(2)+msg(3)+msg(4),2)...
                mod(msg(1)+msg(2)+msg(3),2)];%(7,4) Hamming Code
      
   s = 1 - (2 * cword);                 %BPSK symbols
   r = s + sigma * randn(1,n);        %AWGN Channel
   %Hard-Decision Decoding here
   b = ( r < 0 );                     %threshold at zero
   dist = mod(repmat(b,16,1)+cwords,2)*ones(7,1);
   [dmin , pos] = min(dist);
   msg_cap1 = cwords(pos,1:4);
   
   %Soft-Decision Decoding here
   corr = (1-2*cwords)*r';
   [dmax,pos] = max(corr);
   msg_cap2 = cwords(pos,1:4);
   

   Nerrs = sum(msg ~= msg_cap2);
   
   if(Nerrs > 0)
      Nbiterrs = Nbiterrs + Nerrs;
      Nblkerrs = Nblkerrs + 1;
   end
end

BER_sim = Nbiterrs/(k*Nblocks);
FER_sim = Nblkerrs/Nblocks;

disp([EbNodB BER_sim FER_sim Nbiterrs k*Nblocks]);
