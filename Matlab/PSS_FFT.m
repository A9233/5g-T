%% Processing received Signal and Acquiring Required resource blocks
function PSS_seq = PSS_FFT(Total_signal,mode)

dummy_PSS=zeros(2350,1);
seq_pre_fft=zeros(128,1);
Seq_shift=zeros(128,1);
seq_postFFT=zeros(128,1);




    if mode==1
        for i=1:1:2350
         if i<833
           dummy_PSS(i) = Total_signal(i,1);
         elseif i<961
            seq_pre_fft(i-832) = Total_signal(i,1);
         else 
            dummy_PSS(i) = Total_signal(i,1);
         end 
        end 

        seq_postFFT= fft(seq_pre_fft);
        Seq_shift=fftshift(seq_postFFT,1);

        PSS_seq=zeros(62,1);
        duk=[];
        for i=1:1:63
             if i<32
                 PSS_seq(i,1)=Seq_shift(i+33);
             elseif i<33
                 duk(i)=Seq_shift(i+33);
             else
                 PSS_seq(i-1,1)=Seq_shift(i+33); 
             end 
        end 
        duplex=1;
    else if mode==2
    
         for i=1:1:2355
         if i<2205
           dummy_PSS(i) = Total_signal(i,1);
         elseif i<2333
            seq_pre_fft(i-2204) = Total_signal(i,1);
         else 
            dummy_PSS(i) = Total_signal(i,1);
         end 
        end 

        seq_postFFT= fft(seq_pre_fft);
        Seq_shift=fftshift(seq_postFFT,1);

        PSS_seq=zeros(62,1);
        duk=[];
        for i=1:1:63
             if i<32
                 PSS_seq(i,1)=Seq_shift(i+33);
             elseif i<33
                 duk(i)=Seq_shift(i+33);
             else
                 PSS_seq(i-1,1)=Seq_shift(i+33); 
             end 
        end 
        duplex=2;
        else 
            asd=0;
        end
%figure,plot(abs(PSS_seq));
end 

