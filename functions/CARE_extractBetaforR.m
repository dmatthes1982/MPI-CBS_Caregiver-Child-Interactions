function CARE_extractBetaforR
%%% extract beta data
for dyad=[2:10 12:27 29:40 42 44:47]
    ndyad=num2str(dyad);   
    if dyad < 10
        load(['/Volumes/INTENSO/CARE/DualfNIRS_CARE_processed/03_glm/CARE_d0',ndyad,'_03_glm_002.mat']);
    else
        load(['/Volumes/INTENSO/CARE/DualfNIRS_CARE_processed/03_glm/CARE_d',ndyad,'_03_glm_002.mat']);
    end

    glmcontrast_ch(dyad,:) = data_glm.sub1.T_contrast(:,3).';  
    glmcontrast_cg(dyad,:) = data_glm.sub2.T_contrast(:,3).';  


end

glmcontrast_ch(glmcontrast_ch==0)=NaN;
glmcontrast_cg(glmcontrast_cg==0)=NaN;

%% Test channels for significance and fdr correction
%[~,p1] = ttest(glmcontrast);





%% Exclude channels (visual data check)
excl_ch(7,1)=[3];
excl_ch(9,1:2)=[8,15];
excl_ch(10,1)=[12];
excl_ch(13,1:3)=[3,4,8];
excl_ch(14,1)=[6];
excl_ch(15,1:3)=[4,14,16];
excl_ch(16,1:5)=[1,2,3,4,5];
excl_ch(21,1:2)=[3,4];
excl_ch(18,1)=[3];
excl_ch(19,1:2)=[2,11];
excl_ch(21,1:2)=[3,4];
excl_ch(26,1)=[15];
excl_ch(29,1)=[15];
excl_ch(33,1:2)=[3,4];
excl_ch(34,1:3)=[4,6,8];
excl_ch(35,1:5)=[1,2,3,4,10];
excl_ch(39,1:3)=[5,6,8];
excl_ch(40,1)=[3];


[row,col,v]=find(excl_ch);
endi=size(row);

for n=1:endi(1,1)
    rr=row(n,1);
    cc=v(n,1);
    glmcontrast_ch(rr,cc)=NaN;
    glmcontrast_cg(rr,cc)=NaN;


end;

save(['/Volumes/INTENSO/CARE/results/glmcontrast.mat'],'glmcontrast_ch','glmcontrast_cg')
dlmwrite('/Users/trinhnguyen/R/CARE/data/glmcontrast.csv',glmcontrast_cg)

 