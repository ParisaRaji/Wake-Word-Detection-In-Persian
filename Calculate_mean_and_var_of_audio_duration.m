cd
Dir = 'C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData';
cd C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData


filelist = dir(fullfile(Dir, '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);
num_of_files=length(filelist); %there is 4404 files

freq=16000;
count_of_stereo_file=0;
time_vec_for_var=zeros(1,num_of_files);
%this loop should have done one time and we will use the results later in
%this project

for i=1:num_of_files
    
    name_of_file=filelist(i).name; %just name of file with wav extension
    folder=filelist(i).folder; %path to file without name of file and "\"
    temp=strcat(folder,"\");
    path_of_file=strcat(temp,name_of_file);
    %stereo to mono and checking it
    y=audioread(path_of_file);
    %check if it has two column so is stereo
    num_of_sample_and_col=size(y);
    %col(2) will show the number of columns of y
    if num_of_sample_and_col(2)>1
        count_of_stereo_file=count_of_stereo_file+1;
    end
    %After running this loop we found that, there is no stereo file and all of them are mono and there is no need
    %to convert them
    
    length_in_sec=num_of_sample_and_col(1)/freq;
    time_vec_for_var(i)=length_in_sec;
       
end
count_of_stereo_file;
v=var(time_vec_for_var);
m=mean(time_vec_for_var);

