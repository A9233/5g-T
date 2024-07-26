%% 5G&Beyond Project
%% Task 1 generate Zadoff-chu and compare with matlab toolbox lte function

%% Generating PSS using MatLab Toolbox LTE (Reference - Sharetechnotes)
% Since PSS is determined by each eNodeB, you have to define properites of a eNodeB.  
% NDLRB indicate System Bandwith in the unit of RBs.
% NDLRB 6 = 1.4 Mhz, NDLRB 15 = 3.0 Mhz, NDLRB 25 = 5.0 Mhz,
% NDLRB 50 = 10 Mhz, NDLRB 75 = 15 Mhz, NDLRB 100 = 20 Mhz
% CellRefP indicate number of downlink Antenna. CellRefP = 1 means 1 transmission antenna (SISO)
% NCellID indicate PCI (Physical Channel Identity) of the Cell
% NSubframe indicate the subframe number. Since PSS resides only in a specific subframe,
% you need to specify the proper subframe number here.
% enb.CyclicPrefix = 'Normal';
% enb.NDLRB = 6;
% enb.CellRefP = 1;
% enb.DuplexMode = 'TDD';
% enb.NCellID = 0;% root index=25
% enb.NSubframe = 0;

% if you pass the eNodeB information (enb) into ltePSS(), it will generate OFDM symbols for the specified PSS.
% pss_arrayIndex is just a sequence of integer which will used to plot PSS symbols.

% pss = ltePSS(enb);
% sss = lteSSS(enb);
% pss_arrayIndex = 0:length(pss)-1;%Mapping resource element 
%  figure
%  plot(sss,'o');


%% Genrating PSS signal 
% task: Generate sequence, matching resource elements, genrate grid, filtering and cyclic prefic(generating final signal)  

function Signal =Project_er(nid2, nid1,mode,SNR)

%nid1 is a number NID 2 in the range of 0 to 2, representing the physical-layer identity within the physical-layer cell-identity group.
%nid2 is a number NID 1 in the range of 0 to 167, representing the physical-layer cell-identity group.
duplexmode=["FDD" "TDD"];
%mode=1;
root=[25 29 34];

%% Generating PSS with Zadoff-chu 3GPP specification and Mapping resource elements

u=root(nid2);
for n=1:1:62
    if n<32
        dp(n)= exp(-1i*((pi*u*(n-1)*(n))/63));%n is replaced with n-1 bcoz sequence n starts from 1  
    else        
        dp(n)=exp(-1i*((pi*u*(n)*(n+1))/63)); 
    end  
end
% dp=zeros(62,1);
%         enb.NDLRB= 6;
%         enb.DuplexMode= 'FDD';
%         enb.CyclicPrefix= 'Normal';
%         enb.NCellID= 3*nid1 + nid2-1;
%         enb.TDDConfig= 0;
%         enb.SSC= 0;
%         enb.NSubframe= 0;
%         
%         dp= ltePSS(enb);
        
        
% Mapping resource element
% frame structure type 2, the primary synchronization signal shall be mapped to the third OFDM symbol in subframes 1 and 6.

for m=1:1:72
    k(m)=m-36+((6*12)/2);
end


for l=1:1:72
    if l<6
        a(k(l))=0;
    elseif l<37
        a(k(l))=dp(l-5);
    elseif l<68
        a(k(l))=dp(l-5);
    else
         a(k(l))=0;
    end    
end

 
 %% Generating the Grid 72*98 72 subcarriers and 28 symbols
 % creating the pss in time domain i.e, In 'TDD' 3rd symbols of time slot
 % -slot2 (subframe 1) Grid=g, 
 
 r=rand(72,98);
 gg = r-0.5;

 if duplexmode(mode)=="FDD"
     for n=1:1:98%FDD
     for m=1:1:72
         if n<7
            g(m,n)=gg(m,n);
         elseif n<8
            g(m,n)=a(m);
         elseif n<77
             g(m,n)=gg(m,n);
         elseif n<78
            g(m,n)=a(m);
         else
             g(m,n)=gg(m,n);
         end          
     end
     end
 else 
     for n=1:1:98%TDD
         for m=1:1:72
             if n<17
                g(m,n)=gg(m,n);
             elseif n<18
                g(m,n)=a(m);
             elseif n<87
                 g(m,n)=gg(m,n);
             elseif n<88
                g(m,n)=a(m);
             else
                 g(m,n)=gg(m,n);
             end          
         end
     end

 end
 
 for n=1:1:98
 for i=1:1:128
        if i<29;
            g_array(i,n)=0;
        elseif i<65;
            g_array(i,n)=g(i-28,n);
        elseif i<66;
            g_array(i,n)=0;
        elseif i<102;
            g_array(i,n)=g(i-29,n);
        else 
            g_array(i,n)=0;
        end 
 end 
 end
%figure, surf(g_array);
 gshift=fftshift(g_array,1);
 gfft=ifft(gshift);

 signal_pss=[];
 for i=1:1:98
     temps=ifft(gshift(:,i));
     if mod(i-1,7)==0
         s=[temps(end-9:end); temps];
     else 
         s=[temps(end-8:end); temps];
     end 
     signal_pss =[signal_pss; s];
 end        
 
 % signal generated only for PSS sequence
    
%% Generating SSS
%sequency generation

        N1=nid1-1;
        N2=nid2-1;

        PCI=3*N1+N2;

        qq = floor((N1)/30);
        q= floor((N1+((qq*(qq+1))/2))/30);
        mm= N1+((q*(q+1))/2);
        m0= mod(mm, 31);
        m1= mod((m0+(floor(mm/31)+1)),31);

        x=zeros(31,1);
        x(1)=0;x(2)=0;x(3)=0;x(4)=0;x(5)=1;%initial condition
        
        x_c=zeros(31,1);
        x_c(1)=0;x_c(2)=0;x_c(3)=0;x_c(4)=0;x_c(5)=1;%initial condition
        
        z_x=zeros(31,1);
        z_x(1)=0;z_x(2)=0;z_x(3)=0;z_x(4)=0;z_x(5)=1;%initial condition
        
        for i=1:1:26
            x(i+5)=mod((x(i+2)+x(i)),2);%%%%check eq
            x_c(i+5)=mod((x_c(i+3)+x_c(i)),2);
            z_x(i+5)=mod((z_x(i+4)+z_x(i+2)+z_x(i+1)+z_x(i)),2);
        end
        
         ss=zeros(31,1);
         cc=zeros(31,1);
         zz=zeros(31,1);
        for i=1:1:31
            ss(i)=1-2*x(i);
            cc(i)=1-2*x_c(i);
            zz(i)=1-2*z_x(i);
        end
        
         s=zeros(31,1);
         s1=zeros(31,1);
        
         s56=(mod(((5-1)+m0),31));
        for i=0:1:30
            s(i+1)=ss((mod(i+m0,31)+1));
            s1(i+1)=ss((mod(i+m1,31))+1);
            
        end
        
        %c seq generation
        
         c=zeros(31,1);
         c1=zeros(31,1);
        for i=0:1:30
            
            c(i+1)=cc(round(mod(i+(N2),31)+1));
            c1(i+1)=cc(round(mod(i+(N2)+3,31)+1));
            
        end
        
        % z seq generation
         z=zeros(31,1);
         z1=zeros(31,1);
         z0=zeros(31,1);
        
        for i=0:1:30
            z0(i+1) = zz(mod(i+mod(m0,8),31)+1);
            z1(i+1) = zz(mod(i+mod(m1,8),31)+1);
        end
        
        %generating sequence
       d1=zeros(31,1);
         d2=zeros(31,1);
        
        
        d1=s.*c;
        d2=s1.*c1.*z0;
        d5_1=s1.*c;
        d5_2= s.*c1.*z1;
        d_seq=zeros(62,1);
        d_seq5=zeros(62,1);
        d_trans=zeros(62,1);
        d_sss=zeros(62,1);
        d_sss5=zeros(62,1);
        d_seq(1:2:end-1) = d1;
        
        d_seq(2:2:end) = d2;
        d_seq5(1:2:end-1) = d5_1;
        
        d_seq5(2:2:end) = d5_2;

%         nid1=nid1-1;
%         nid2=nid2-1;
%         enb.NDLRB= 6;
%         enb.DuplexMode= 'FDD';
%         enb.CyclicPrefix= 'Normal';
%         enb.NCellID= 3*nid1 + nid2;
%         enb.TDDConfig= 0;
%         enb.SSC= 0;
%         enb.NSubframe= 0;
%         
%         sequence0 = lteSSS(enb);
        
          d_sss=transpose(d_seq);
          d_sss5=transpose(d_seq5);
%         d_sss=sequence0;
%         enb.NDLRB= 6;
%         enb.DuplexMode= 'FDD';
%         enb.CyclicPrefix= 'Normal';
%         enb.NCellID= 3*nid1 + nid2;
%         enb.TDDConfig= 0;
%         enb.SSC= 0;
%         enb.NSubframe= 5;
%         
%         sequence5 = lteSSS(enb);
%         d_sss5=sequence5;

%         figure,plot((d_sss));
%         figure,plot((d_sss5));
        %for i=1:1:62
%          d_check(:,nid1,nid2)=d_seq(:,1,1);
%          d_check5(:,nid1,nid2)=d_seq5(:,1,1);
%         
%         
%         %end
%         
     
 
        % figure
        % plot (d_sss,'r');

%% Generating the Grid 72*28 SSS
 % creating the pss in time domain i.e, In 'TDD' last symbols of time slot1
 r2=rand(72,98);
 rr=r2-0.48;
 s_array=zeros(72,98) ;
  
 b_sss=zeros(72,1);
 % mapping resource element
 for l=1:1:72
    if l<6
        b_sss(k(l))=0;
        b_sss5(k(l))=0;
    elseif l<37
        b_sss(k(l))=d_sss(l-5);
        b_sss5(k(l))=d_sss5(l-5);  
    elseif l<68
        b_sss(k(l))=d_sss(l-5);
        b_sss5(k(l))=d_sss5(l-5);
    else
         b_sss(k(l))=0;
         b_sss5(k(l))=0;
    end    
 end


 % creating Grid for 7*14 = 98 total symbols (7 subframe and 14 symbols per subframe)
 
 if duplexmode(mode)=="FDD"
     for n=1:1:98%FDD
     for m=1:1:72
         if n<6
            s_array(m,n)=rr(m,n);
         elseif n<7
            s_array(m,n)=b_sss(m);
         elseif n<76
            s_array(m,n)=rr(m,n);
         elseif n<77
            s_array(m,n)=b_sss(m);
         else
            s_array(m,n)=rr(m,n);
         end          
     end
     end
 else
 for n=1:1:98% TDD
     for m=1:1:72
         if n<14
            s_array(m,n)=rr(m,n);
         elseif n<15
            s_array(m,n)=b_sss(m);
         elseif n<84
            s_array(m,n)=rr(m,n);
         elseif n<85
            s_array(m,n)=b_sss(m);
         else 
             s_array(m,n)=rr(m,n);
         end          
     end
 end
 end
 
%ifft function for Secondary Syn Sig
ss=zeros(128,98)  ;
 
for n=1:1:98
 for i=1:1:128
        if i<29;
            ss(i,n)=0;
        elseif i<65;
            ss(i,n)=s_array(i-28,n);
        elseif i<66;
            ss(i,n)=0;
        elseif i<102;
            ss(i,n)=s_array(i-29,n);
        else 
            ss(i,n)=0;
        end 
 end
end    
    sss=zeros(128,1);
    
s_shift=fftshift(ss,1);    
 %cyclic shift  
signal_sss=[];
 for i=1:1:98
     temps1=ifft(s_shift(:,i));
     if mod(i-1,7)==0
         s1_a=[temps1(end-9:end); temps1];
     else 
         s1_a=[temps1(end-8:end); temps1];
     end 
     signal_sss =[signal_sss; s1_a];
 end
 
 %Signal generated only for SSS sequence
 



%% Total Signal -----changing name sequence from g, b_sss to PSS and SSS  (count starts from 1)
%  % FDD pss comes twice in every 10ms last symbolt of slot1 and slot 11(symbol 7 and symbol 77)
%  % FDD SSS earlier one symbol to pss(symbol 6 and symmbol 76)
%  % TDD The PSS is mapped to the third OFDM symbol in subframes 2 and 7
%  % TDD The SSS is mapped to the last OFDM symbol in slots 2 and 12, which is three OFDM symbols before the PSS
  
 % a contains PSS sequence, b_sss contains SSS sequence for subframe 0 and
 % b_sss5 contains SSS sequence for subframe 5

 for i=1:1:128
        if i<29;
            pss(i)=0;
            sss(i)=0;
            sss5(i)=0;
        elseif i<65;
            pss(i)=a(i-28);
            sss(i)=b_sss(i-28);
            sss5(i)=b_sss5(i-28);
        elseif i<66;
            pss(i)=0;
            sss(i)=0;
            sss5(i)=0;
        elseif i<102;
            pss(i)=a(i-29);
            sss(i)=b_sss(i-29);
            sss5(i)=b_sss5(i-29);
        else 
            pss(i)=0;
            sss(i)=0;
            sss5(i)=0;
        end 
 end 
 
 
 
 
%% Creating FDD and TDD
%    e_signal_r=rand(128,98);
 %   e_sig=e_signal_r-0.48;


e_sig=zeros(128,98);
if duplexmode(mode)=="FDD"
    for n=1:1:98
        for i=1:1:128
            if n<6;
             PS(i,n)=e_sig(i,n);
            elseif n<7;
              PS(i,n)=sss(i);
            elseif n<8
                PS(i,n)=pss(i);
            elseif n<76
                PS(i,n)=e_sig(i,n);
            elseif n<77;
              PS(i,n)=sss5(i);
            elseif n<78
                PS(i,n)=pss(i);
            else
                PS(i,n)=e_sig(i,n);
            end 
        end
    end
else 
    for n=1:1:98
        for i=1:1:128
            if n<14;
             PS(i,n)=e_sig(i,n);
            elseif n<15;
              PS(i,n)=sss(i);
            elseif n<17
                PS(i,n)=e_sig(i,n);
            elseif n<18
                PS(i,n)=pss(i);
            elseif n<84
                PS(i,n)=e_sig(i,n);
            elseif n<85;
              PS(i,n)=sss5(i);
            elseif n<87
                PS(i,n)=e_sig(i,n);
            elseif n<88
                PS(i,n)=pss(i);
            else
                PS(i,n)=e_sig(i,n);
            end 
        end
    end

end 
   
 PS_shift=fftshift(PS,1) ;   
 %cyclic shift  
signal_t=[];
 for i=1:1:98
     PS_fft=ifft(PS_shift(:,i));
     %PS_fft=(PS_shift(:,i));
     if mod(i-1,7)==0
         P_S=[PS_fft(end-9:end); PS_fft];
     else 
         P_S=[PS_fft(end-8:end); PS_fft];
     end 
     signal_t =[signal_t; P_S];
 end
 
% Adding noise to the signal 
%figure,surf(abs(PS)); 
Signal= awgn(signal_t,SNR);
%Signal= (signal_t);
 

 %Signal generated by mapping PSS and SSS sequence to symbols and
 %transmitted with SNR ( Added White Gaussian Noise )
 
 
 
  
  
 
 end
 
 
 