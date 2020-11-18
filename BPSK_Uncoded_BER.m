clc;
EbNodB = 4;
R = 1;                            %Un-coded BPSK%
EbNo = 10^(EbNodB/10);              
sigma = sqrt(1/(2*R*EbNo));

BER_th = 0.5*erfc(sqrt(EbNo));

N = 10^(6);                            %Number of Bits of message per block
Nerrs = 0; Nblocks = 1;

for i = 1 : Nblocks
   msg = randi([0 1],1,N);           %generate random message
   %Encoding here
   s = 1 - 2 * msg;                  %BPSK symbols
   r = s + sigma * randn(1,N);       %AWGN Channel
   %Decoding here
   msg_cap = ( r < 0 );              %threshold at zero

Nerrs = Nerrs + sum(msg ~= msg_cap);
end

BER_sim = Nerrs/(N*Nblocks);
disp([EbNodB BER_th BER_sim Nerrs N*Nblocks]);