function y = mul_sh(x,k)
%x: Input Block
%k: -1 or 'k' shift 
%y: output

if(k == -1)
    y = zeros(1,length(x));
else
    y = [x(k+1:end) x(1:k)]; % multiplication by shifted Identity
end