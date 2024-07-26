%% Generating PSS with Zadoff-chu 3GPP specification and Mapping resource elements


function [PSS_seq cp]= PSS_Sequence_generation(CellID_N2)
root=[25 29 34];
u=root(CellID_N2);
dp=zeros(62,1);
pss=zeros(128,1);
gshift=zeros(128,1);
gfft=zeros(128,1);
a=zeros(72,1);
dam_pss=zeros(137,1);
for n=1:1:62
    if n<32
        dp(n)= exp(-1i*((pi*u*(n-1)*(n))/63));%n is replaced with n-1 bcoz sequence n starts from 1  
    else        
        dp(n)=exp(-1i*((pi*u*(n)*(n+1))/63)); 
    end  
end
for m=1:1:72
    k(m)=m-36+((6*12)/2);
end
PSS_seq = dp;
for l=1:1:72
    if l<6
        a(k(l),1)=0;
    elseif l<37
        a(k(l),1)=dp(l-5);
    elseif l<68
        a(k(l),1)=dp(l-5);
    else
         a(k(l),1)=0;
    end    
end

for i=1:1:128
        if i<29;
            pss(i,1)=0;
            
        elseif i<65;
            pss(i,1)=a(i-28);
            
        elseif i<66;
            pss(i,1)=0;
            
        elseif i<102;
            pss(i,1)=a(i-29);
            
        else 
            pss(i,1)=0;
            
        end 
end
 gshift=fftshift(pss,1);
 gfft=ifft(gshift);
 

dam_pss=[gfft(end-8:end); gfft];
cp=[gfft(end-8:end)];
%PSS_seq=dam_pss;
%PSS_seq=dam_pss;


end 