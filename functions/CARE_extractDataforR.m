function CARE_extractDataforR
%% extract wtc data
for dyad=[2:27 29:40 42 44:47]
    ndyad=num2str(dyad);   
    if dyad < 10
        load(['F:/CARE/DualfNIRS_CARE_processed/05a_wtc/CARE_d0',ndyad,'_05a_wtc_001.mat']);
    else
        load(['F:/CARE/DualfNIRS_CARE_processed/05a_wtc/CARE_d',ndyad,'_05a_wtc_001.mat']);
    end

    wtc_collab1(dyad,:) = data_wtc.coherences(1:16,1).';
    wtc_collab2(dyad,:) = data_wtc.coherences(1:16,2).'; 
    wtc_indiv1(dyad,:) = data_wtc.coherences(1:16,3).'; 
    wtc_indiv2(dyad,:) = data_wtc.coherences(1:16,4).';
    wtc_rest1(dyad,:) = data_wtc.coherences(1:16,5).'; 
    wtc_rest2(dyad,:) = data_wtc.coherences(1:16,6).'; 
    wtc_rest3(dyad,:) = data_wtc.coherences(1:16,7).'; 
    %wtc_talk(dyad,:) = data_wtc.coherences(1:16,4).'; 

end

%nwtc_collab(wtc_collab==0)=NaN;
%wtc_indiv(wtc_indiv==0)=NaN;
%wtc_rest(wtc_rest==0)=NaN;
%wtc_talk(wtc_talk==0)=NaN;

%Fishersz transformation for all r values
wtc_collab1=.5.*log((1+wtc_collab1)./(1-wtc_collab1));
wtc_collab2=.5.*log((1+wtc_collab2)./(1-wtc_collab2));
wtc_indiv1=.5.*log((1+wtc_indiv1)./(1-wtc_indiv1));
wtc_indiv2=.5.*log((1+wtc_indiv2)./(1-wtc_indiv2));
wtc_rest1=.5.*log((1+wtc_rest1)./(1-wtc_rest1));
wtc_rest2=.5.*log((1+wtc_rest2)./(1-wtc_rest2));
wtc_rest3=.5.*log((1+wtc_rest3)./(1-wtc_rest3));
%wtc_talk=.5.*log((1+wtc_talk)./(1-wtc_talk));

%% Test channels for significance and fdr correction
%[~,p1] = ttest(wtc_collab);

%[~,p2] = ttest(wtc_indiv);

%[~,p3] = ttest(wtc_rest);

%[~,p4] = ttest(wtc_talk);

%p=[p1,p2,p3,];%p4];

%q=0.05;
%FDR = fdr0(p, q);


%% Reshape for LMM
wtc_lmm=horzcat(wtc_collab1,wtc_collab2,wtc_indiv1,wtc_indiv2,...
    wtc_rest1,wtc_rest2,wtc_rest3);%,wtc_talk);

%% Exclude channels (visual data check)
%excl_ch(2,1:3)=[4,15,16];
%excl_ch(3,1:2)=[1,3];
%excl_ch(4,1:4)=[3,4,16,10];
%excl_ch(5,1:2)=[9,10];
%excl_ch(6,1:5)=[13,1,8,11,14];
%excl_ch(7,1:4)=[1,2,6,3];
%excl_ch(8,1)=[2];
%excl_ch(9,1:4)=[1,2,6,8];
%excl_ch(10,1:5)=[10,15,2,4,8];
%excl_ch(11,1:7)=[1,3,9,10,15,4,8];
%excl_ch(12,1:2)=[8,13];
%excl_ch(13,1:13)=[10,1,2,3,4,6,7,8,9,11,12,15,16];
%excl_ch(14,1:8)=[3,4,5,6,7,8,10,12];
%excl_ch(15,1:3)=[12,4,16];
%excl_ch(16,1:3)=[11,12,4];
%excl_ch(17,1:13)=[3,4,6:16];
%excl_ch(18,1:8)=[1:8];
%excl_ch(19,1:9)=[12,1:4,7:10];
%excl_ch(20,1:5)=[2,3,4,6,8];
%excl_ch(21,1:12)=[3,4,8,14,16,6,9,10,11,12,13,15];
%%excl_ch(22,1:2)=[4,8];
%excl_ch(23,1:7)=[4,6,8,13:16];
%excl_ch(24,0)=[];
%excl_ch(25,1:2)=[5,15];
%excl_ch(26,1:4)=[3,15,16,4];
%%excl_ch(27,0)=[];
%excl_ch(29,1:5)=[4,8,14,15,16];
%excl_ch(30,1:5)=[1,2,4,6,8,];
%excl_ch(31,1:7)=[1:4,6:8];
%excl_ch(32,1:3)=[3,7,8];
%%excl_ch(33,0)=[];
%excl_ch(34,1:12)=[1:12];
%excl_ch(35,1:10)=[1,2,4,8:12,15,16];
%excl_ch(36,1:3)=[4,7,8];
%excl_ch(37,1:2)=[4,8];
%%excl_ch(38,0)=[];
%excl_ch(39,1:7)=[3,4,2,5,7,8,11];
%excl_ch(40,1:3)=[3,6,4];
%excl_ch(41,1)=[4];
%excl_ch(42,1:4)=[1,3,4,7];
%%excl_ch(44,0)=[];
%excl_ch(45,1:2)=[10,14];
%excl_ch(46,1:6)=[1:4,9,10];
%excl_ch(47,1)=[4];

%[row,col,v]=find(excl_ch);
%endi=size(row);

%for n=1:endi(1,1)
%    rr=row(n,1);
%    cc=v(n,1);
%    wtc_lmm(rr,cc)=NaN;
%    wtc_lmm(rr,cc+16)=NaN;
%    wtc_lmm(rr,cc+32)=NaN;
    %wtc_lmm(rr,cc+48)=NaN;

%end

save(['F:/CARE/results/wtc_lmm.mat'],'wtc_lmm')
dlmwrite('F:/CARE/results/wtc_lmm.csv',wtc_lmm)

end
 
%%% extract wtc flipped data
%for dyad=[2:10 12:27 29:40 42 44:47]
    %ndyad=num2str(dyad);   
    %if dyad < 10
    %    load(['F:\CARE\DualfNIRS_CARE_processed\05c_wtc_flipped/CARE_d0',ndyad,'_05c_wtc_flipped_002.mat']);
    %else
    %    load(['F:\CARE\DualfNIRS_CARE_processed\05c_wtc_flipped/CARE_d',ndyad,'_05c_wtc_flipped_002.mat']);
    %end

    %wtc_collab_flipped(dyad,:) = data_wtc_flipped.coherences_flipped(1:16,2).';  
    %wtc_indiv_flipped(dyad,:) = data_wtc_flipped.coherences_flipped(1:16,2).'; 
    %wtc_rest_flipped(dyad,:) = data_wtc_flipped.coherences_flipped(1:16,3).'; 
    %wtc_talk(dyad,:) = data_wtc.coherences(1:16,4).'; 

%end

%wtc_collab_flipped(wtc_collab_flipped==0)=NaN;
%wtc_indiv_flipped(wtc_indiv_flipped==0)=NaN;
%wtc_rest_flipped(wtc_rest_flipped==0)=NaN;
%wtc_talk(wtc_talk==0)=NaN;

%Fishersz transformation for all r values
%wtc_collab_flipped=.5.*log((1+wtc_collab_flipped)./(1-wtc_collab_flipped));
%wtc_indiv_flipped=.5.*log((1+wtc_indiv_flipped)./(1-wtc_indiv_flipped));
%wtc_rest_flipped=.5.*log((1+wtc_rest_flipped)./(1-wtc_rest_flipped));
%wtc_talk=.5.*log((1+wtc_talk)./(1-wtc_talk));

%% Test channels for significance and fdr correction
%[~,p1] = ttest(wtc_collab_flipped);

%[~,p2] = ttest(wtc_indiv_flipped);

%[~,p3] = ttest(wtc_rest_flipped);

%[~,p4] = ttest(wtc_talk);

%p=[p1,p2,p3,];%p4];

%q=0.05;
%FDR = fdr0(p, q);


%% Reshape for LMM
%wtc_lmm_flipped=horzcat(wtc_collab_flipped,wtc_indiv_flipped,wtc_rest_flipped);%,wtc_talk);

%% Exclude channels (visual data check)
%excl_ch(7,1)=[3];
%excl_ch(9,1:2)=[8,15];
%excl_ch(10,1)=[12];
%excl_ch(13,1:3)=[3,4,8];
%excl_ch(14,1)=[6];
%excl_ch(15,1:3)=[4,14,16];
%excl_ch(16,1:5)=[1,2,3,4,5];
%excl_ch(21,1:2)=[3,4];
%excl_ch(18,1)=[3];
%excl_ch(19,1:2)=[2,11];
%excl_ch(21,1:2)=[3,4];
%excl_ch(26,1)=[15];
%excl_ch(29,1)=[15];
%excl_ch(33,1:2)=[3,4];
%excl_ch(34,1:3)=[4,6,8];
%excl_ch(35,1:5)=[1,2,3,4,10];
%excl_ch(39,1:3)=[5,6,8];
%excl_ch(40,1)=[3];


%[row,col,v]=find(excl_ch);
%endi=size(row);

%for n=1:endi(1,1)
%    rr=row(n,1);
%    cc=v(n,1);
%    wtc_lmm_flipped(rr,cc)=NaN;
%    wtc_lmm_flipped(rr,cc+16)=NaN;
%    wtc_lmm_flipped(rr,cc+32)=NaN;
%    wtc_lmm_flipped(rr,cc+48)=NaN;

%end;

%save(['\\fs.univie.ac.at\homedirs\nguyenq22\Documents\MATLAB\coherence\wtc/wtc_lmm_flipped3.mat'],'wtc_lmm_flipped')
%dlmwrite('\\fs.univie.ac.at\homedirs\nguyenq22\Documents\R\CARE\data/wtc_lmm_flipped3.csv',wtc_lmm_flipped)