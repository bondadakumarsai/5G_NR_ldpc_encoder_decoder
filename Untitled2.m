%G = [1 0 0 0 1 0 1; 0 1 0 0 1 1 1; 0 0 1 0 1 1 0; 0 0 0 1 0 1 1];
%cwords =mod((dec2bin(0:15,4)-48)*G,2)

load base_matrices\NR_1_2_20.txt;
B = NR_1_2_20;
size(B)

