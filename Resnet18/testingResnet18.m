Dir = 'C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Test';
cd C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Test


filelist = dir(fullfile(Dir, '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);
num_of_files=length(filelist)

sum=0;
freq=16000;
FFTLength = 512;
numBands = 64;
frequencyRange = [125 7500];
windowLength = 0.025*freq;
overlapLength = 0.015*freq;
for i=1:num_of_files
    name_of_file=filelist(i).name %just name of file with wav extension
    folder=filelist(i).folder; %path to file without name of file and "\"
    temp=strcat(folder,"\");
    path_of_file=strcat(temp,name_of_file);
    
    % make white noise for audio and make them 2.8 sec
    
    y=audioread(path_of_file);
    size_of_y=size(y);
    length_in_sec=size_of_y(1)/freq;
        
        
    if length_in_sec>2.8
        t=length_in_sec-2.8;
        division=t/2;
        samp=round(division*freq);
        y=y(1+samp:end-samp);
        
        
    elseif length_in_sec<2.8
        add_sec=2.8-length_in_sec;
        add_samp=round(add_sec*freq);
        %noise=0.0001*randn(add_samp,1);
        noise=wgn(add_samp,1,-85);
        y=[y;noise];
        
    end
    
    checkSize=size(y);
    if checkSize(1)<44800
        add_again=44800-checkSize(1);
        noise=wgn(add_again,1,-85);
        y=[y;noise];
     elseif checkSize(1)>44800
        sub_again=checkSize(1)-44800;
        y=y(1:end-sub_again);
    end
            
             
        melSpectrogram(y,freq);
        axis off
        colorbar('off')
        add2=strcat("C:\Users\Parisa\Desktop\ProjectKarshenasi\","1.jpg");
        saveas(gcf,add2);
        
        I=imread(add2);
        I = imresize(I, [224 224]);
        pred=classify(trainedNetwork_1,I)
        
        if contains(name_of_file,"target")
            if strcmp(string(pred),"target") 
                sum=sum+1
            end 
        else
            if strcmp(string(pred),"non_target")
                sum=sum+1
            end 
        end  
end 

accuracy=sum/num_of_files




