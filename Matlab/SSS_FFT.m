%% Processing received Signal and Acquiring Required resource blocks
function SSS_seq=SSS_FFT(SSS)
    
    s1=zeros(128,1);
    sfft=zeros(128,1);
    s_shift=zeros(128,1);
    for i=1:1:128
        s1(i,1)=SSS(i+9,1);
        
    end
    
    sfft=fft(s1);
    s_shift=fftshift(sfft,1);
    
    S_seq=zeros(62,1);
        duk=[];
        
        for i=1:1:63
             if i<32
                 S_seq(i,1)=s_shift(i+33,1);
             elseif i<33
                 duk(i)=s_shift(i+33,1);
             else
                 S_seq(i-1,1)=s_shift(i+33,1); 
             end 
        end
    SSS_seq=S_seq;

end 