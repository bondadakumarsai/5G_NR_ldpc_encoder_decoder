function out = check_cword(B,z,c)
%B: Base Matrix 
%z: Expansion Factor
%c: Codeword, length = #cols(B) * z
%out = 1, if codeword is valid; 0, else

[m,n] = size(B);

syn = zeros(m*z,1);

for i= 1:m
    for j =1:n
        syn((i-1)*z+1:i*z) = mod(syn((i-1)*z+1:i*z) + mul_sh(c((j-1)*z+1:j*z),B(i,j))',2);
    end
end

if any(syn)
    out = 0;
else
    out = 1;
end

