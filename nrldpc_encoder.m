function cword = nrldpc_encoder(B,z,msg)
%B: Base Matrix 
%z: Expansion Factor
%cword: Codeword vector, length = (#col(B))*z
%msg: Message vector, length = (#col(B)-#rows(B)*z)

[m,n] = size(B);

cword = zeros(1,n*z);
cword(1:(n-m)*z) = msg;

%double-diagonal Encoding
temp = zeros(1,z);

for i = 1:4 %rows 1 to 4
    for j = 1:n-m %message column
        temp = mod(temp + mul_sh(msg((j-1)*z+1:j*z),B(i,j)),2);
    end
end

if B(2,n-m+1) == -1
    p1_sh = B(3,n-m+1);
else
    p1_sh = B(2,n-m+1);
end

cword((n-m)*z+1:(n-m+1)*z) = mul_sh(temp,z-p1_sh); %p1

%finding p2, p3 & p4

for i = 1:3
    temp = zeros(1,z);
    for j = 1 : n-m +i
        temp = mod(temp + mul_sh(cword((j-1)*z+1:j*z),B(i,j)),2);
    end
    cword((n-m+i)*z+1:(n-m+i+1)*z) = temp;
end

%remaining parities
for i = 5:m
    temp = zeros(1,z);
    for j = 1:n-m+4
         temp = mod(temp + mul_sh(cword((j-1)*z+1:j*z),B(i,j)),2);
    end
    cword((n-m+i-1)*z+1:(n-m+i)*z) = temp;
end
