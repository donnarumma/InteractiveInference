function cmaps=getRedBlueCmaps(NC)

cmaps=linspecer(NC);
cmapsw       =cmaps;
cmapsw(4,:)  =cmaps(2,:);
cmapsw(2:3,:)=cmaps(3:4,:);
cmaps        =cmapsw;