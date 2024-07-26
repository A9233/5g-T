load('matrix_6_seq.mat')
% [d0, d5] = AF_func_SSSGen(0, 0);

Aj_sss0 = [d_seq01, d_seq51]; % PCI = 0
Aj_sss1 = [d_seq02, d_seq52]; % PCI = 1
Aj_sss2 = [d_seq03, d_seq53]; % PCI = 2

Al_sss = zeros(size(Aj_sss0,1), size(Aj_sss0,2), 3);
% Al_sss1 = zeros(size(Aj_sss1));
% Al_sss2 = zeros(size(Aj_sss2));

% for pss_i = 1:3aj
%     SSS0 = zeros(62,168);
%     SSS5 = zeros(62,168);
%     for sss_i = 1:168
%         [d0, d5] = AF_func_SSSGen(pss_i-1, sss_i-1);
%         SSS0(:,sss_i) = d0;
%         SSS5(:,sss_i) = d5;
%     end
%     Al_sss(:, :, pss_i) = [SSS0, SSS5];
%     
% end


% enb
sss=zeros(62,168,3);
Ma_sss = zeros(size(Aj_sss0,1), size(Aj_sss0,2), 3);
for pss_i=1:3
    PSS_ID = pss_i-1;
    
    MaSSS0 = zeros(62,168);
    MaSSS5 = zeros(62,168);
    
    for sss_i = 1:168
        SSS_ID = sss_i - 1;
        
        enb.NDLRB= 6;
        enb.DuplexMode= 'TDD';
        enb.CyclicPrefix= 'Normal';
        enb.NCellID= 3*SSS_ID + PSS_ID;
        enb.TDDConfig= 0;
        enb.SSC= 0;
        enb.NSubframe= 0;
        
        sequence0 = lteSSS(enb);
        
        enb.NSubframe= 5;
        sequence5 = lteSSS(enb);
        
        MaSSS0(:,sss_i) = sequence0;
        MaSSS5(:,sss_i) = sequence5;
        sss(:,:,pss_i) = MaSSS0;
    end
    
    %Ma_sss(:, :, pss_i) = [MaSSS0, MaSSS5];

end