%% Generating SSS Sequence Generation

function [SSS_seq0, SSS_seq5, d1, d2] = SSS_Sequence_generation(CellID_N2, CellID_N1)


        S0=zeros(128,1);
        S5=zeros(128,1);
        dam_S0=zeros(137,1);
        dam_S5=zeros(137,1);
        
        N1=CellID_N1-1;
        N2=CellID_N2-1;

        PCI=3*N1+N2;

        qq = floor((N1)/30);
        q= floor((N1+((qq*(qq+1))/2))/30);
        mm= N1+((q*(q+1))/2);
        m0= mod(mm, 31);
        m1= mod((m0+(floor(mm/31)+1)),31);

        
        %%s seq generation s0 and s1
        x=zeros(31,1);
        x(1)=0;x(2)=0;x(3)=0;x(4)=0;x(5)=1;%initial conditiong
        
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
        
        
        
        d_seq(1:2:end-1) = d1;
        
        d_seq(2:2:end) = d2;
        d_seq5(1:2:end-1) = d5_1;
        
        d_seq5(2:2:end) = d5_2;
       d_sss=transpose(d_seq);
        d_sss5=transpose(d_seq5);
        
     SSS_seq0=d_sss;
     SSS_seq5=d_sss5;   
        
 
 
end 









