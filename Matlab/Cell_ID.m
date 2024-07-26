%% Receving the signal 
clc;
close all;
clear all;


for i=1:1:1
    
% NID 2 in the range of 0 to 2, representing the physical-layer identity within the physical-layer cell-identity group.
% NID 1 in the range of 0 to 167, representing the physical-layer cell-identity group.

%Signal =Project_er(nid2, nid1,mode, SNR);
NID2=1;    
NID1=4;  
mode=1;    
SNR=1000;
disp('SNR');
  disp(SNR);      
[Total_signal]= Project_er(NID2,NID1,mode,SNR);

%figure,plot(abs(Total_signal));

%% Filtering the central resource blocks from received signal (Primary Synchronization Signal)

% Seperating 6 resource blocks containg PSS signal with IFFT size 128 Time domain and FFT process
peak=zeros(6,1);
plot_pss=zeros(123,6);
p=1;
for mode=1:1:2
 PSS_seq_received= PSS_FFT(Total_signal,mode);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generated PSS sequence, SSS sequence and Identify Cell ID(3 * ND1 + ND2)

%% Generating PSS sequence

PSS_seq_generated = zeros(62,1,3);

for CellID_N2=1:1:3
PSS_seq_generated(:,:,CellID_N2) = PSS_Sequence_generation(CellID_N2);
%m_check=[PSS_seq_generated(:,:,CellID_N2) PSS_seq_received];

PSS_corr=xcorr(PSS_seq_received,PSS_seq_generated(:,:,CellID_N2));
PSS_corr_v = PSS_corr.* PSS_corr;       % the vector with elements 
%plot_pss(:,p)=PSS_corr ;     % as square of v's elements
PSS_corr_sum = sum(PSS_corr_v);         % sum of squares -- the dot product
mag = sqrt(PSS_corr_sum);               % magnitude
%figure,plot(abs(PSS_corr));
peak(p,1)=mag;
p=p+1;

end 
end

PSS_maxi=max(peak);
peak_t=[peak(1:3,1) peak(4:6,1)];

sq=1;
duplex=["FDD" "TDD"];
for mode=1:1:2
    for CellID_N2=1:1:3
        if peak_t(CellID_N2,mode)==PSS_maxi
            Duplex_scheme=duplex(mode);
            PSS_ID = CellID_N2;
            disp('CellID_N2')
            disp(CellID_N2)
            disp(mode)
           % figure,plot(abs(plot_pss(:,sq)));           
        else
            a=0;
            
        end
        sq=sq+1;
    end 
end 

 

 

%% Filtering the central resource blocks from the received signal (Secondary Synchronization Signal)

% Seperating 6 resource blocks containg PSS signal with IFFT size 128 Time domain and FFT process
SSS_seq_received = SSS_FFT(Total_signal, Duplex_scheme);

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generating SSS Sequence 

SSS_seq_generated = zeros(62,1,168);
for CellID_N1=1:1:168
SSS_seq_generated(:,:,CellID_N1) = SSS_Sequence_generation(PSS_ID, CellID_N1);

SSS_corr=xcorr(SSS_seq_received,SSS_seq_generated(:,:,CellID_N1));
SSS_corr_v = SSS_corr.* SSS_corr;       %the vector with elements 
                                        % as square of v's elements
SSS_corr_sum = sum(SSS_corr_v);         % sum of squares -- the dot product
mag(CellID_N1,1) = sqrt(SSS_corr_sum);  % magnitude
if CellID_N1==NID1
%figure,plot(abs(SSS_corr));
else 
    asd=0;
end
end 
%PSS_ID=PSS_ID-1;
Maxi=max(mag);
 
for CellID_N1=1:1:168
if mag(CellID_N1,1)==Maxi
        %figure,plot(abs(SSS_corr));
        SSS_ID=CellID_N1;
        CellID = 3*SSS_ID + PSS_ID;
        disp('==========================================================');
        disp("Cell_Search:");        
        Cell_Search.Duplex_scheme = Duplex_scheme;
        Cell_Search.PSS_ID = PSS_ID;
        Cell_Search.SSS_ID = SSS_ID;        
        Cell_Search.CellID = CellID;
        disp(Cell_Search);
        disp('==========================================================');
else
    a=a+1; 
    
end 

end 



    
end


%%

        
 











