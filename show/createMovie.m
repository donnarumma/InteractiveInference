function createMovie(inname,outname,params)
%%function createMovie(inname,outname,params)
default_params=paramsCreateMovie;
try
    params=recopyFields(params,default_params);
catch
    params=default_params;
end
rep      = params.repetitions;
ext      = params.extension;
ifres    = params.ifresize;
R        = params.R;
C        = params.C;
ifsingle = params.ifsingle;
FrameRate= params.FrameRate;

try
    addpath(params.dirname);
catch
end
try
    outname;
catch
    outname 	= 'movie/subGoalMovie';
end
try
    inname;
catch
    inname = 'movieIms/Seq';
end

fprintf('Saving %s...',[outname '.avi']); t=tic;
writerObj = VideoWriter([outname '.avi']);
writerObj.FrameRate = FrameRate; 
open(writerObj);
    
if ~params.dirmode
    nS = length(dir ([inname '*.' ext]));
    imnames=cell(1,nS);
    for i=1:nS
        imnames{i}=[inname num2str(i) '.' ext];
    end
else
    goodfiles   = dir([inname '*.' ext]);
    imnames     = {goodfiles.name};
    nS          = length(imnames);
    for i=1:nS
        imnames{i}=[goodfiles(i).folder '/' imnames{i}];
    end
    
end

for i=1:nS
%     imname = [inname num2str(i) '.' ext];
    imname = imnames{i};
    img = imread(imname);
    if ifres
        img=imresize(img,[R,C]);
    end
    if ifsingle
%             img=im2double(img);
        img=im2single(img);
    end
    
    if i==nS || i==1
        rep = rep*2;
    end
    for k=1:rep
        writeVideo(writerObj,img); 
    end
end
close(writerObj);
fprintf('Done. Elapsed time %gs\n',toc(t));
