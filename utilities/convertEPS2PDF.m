function convertEPS2PDF(save_dir,delete_converted,fullGsPath,libstdcpath)
%% function convertEPS2PSD_cell(save_dir,delete_converted,fullGsPath)
try
    delc=delete_converted;
catch
    delc=1;
end
try
    lstdcpath=libstdcpath;
catch  
    lstdcpath='/usr/lib/x86_64-linux-gnu/libstdc++.so.6';
end
try
    if isunix
        fullGsPath_='';
        setenv('LD_LIBRARY_PATH', lstdcpath)
    else
        fullGsPath_= fullGsPath;
    end
catch
    fullGsPath_= 'C:\Program Files\gs\gs9.52\bin\gswin64c.exe';
end
[R,C]=size(save_dir);
cur_dir=cd;
for r=1:R
    for c=1:C
        tmp_dir=save_dir{r,c};
        cd(tmp_dir);
        files=dir('*.eps');
        for i=1:length(files)
            eps2pdf_old(files(i).name,fullGsPath_);
            if delc
                delete(files(i).name);
            end
        end
        cd(cur_dir);
    end
    
end
cd(cur_dir);
