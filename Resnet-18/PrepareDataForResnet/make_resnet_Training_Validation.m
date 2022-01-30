
%training

Dir = 'C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Train';
cd C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Train
filelist = dir(fullfile(Dir, '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);
num_of_files=length(filelist);

num_of_train_files=2808;
len_of_audio_y=2.8*freq;
audiotrain=zeros(len_of_audio_y,num_of_train_files);
trainLabel=zeros(num_of_train_files,1);

for i=1:num_of_train_files
    
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

    if contains(name_of_file,"target")
        melSpectrogram(y,freq);
        axis off
        colorbar('off')
        add=string(i);
        add=strcat(add,".png");
        add2=strcat("C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalImage\train\target\",add);
        saveas(gcf,add2);
        trainLabel(i)=0;
     else
        melSpectrogram(y,freq);
        axis off
        colorbar('off')
        add=string(i);
        add=strcat(add,".png");
        add2=strcat("C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalImage\train\non_target\",add);
        saveas(gcf,add2);
        trainLabel(i)=1;
     end
     audiotrain(:,i)=y;   
     
end

%validation part

Dir = 'C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Validation';
cd C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalData\Validation


filelist = dir(fullfile(Dir, '**\*.*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);
num_of_files=length(filelist);

num_of_validation_files=817;
audiovalidation=zeros(len_of_audio_y,num_of_validation_files);
validationLabel=zeros(num_of_validation_files,1);


for i=1:num_of_validation_files
    
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
            
             
     if contains(name_of_file,"target")
        melSpectrogram(y,freq);
        axis off
        colorbar('off')
        add=string(i);
        add=strcat(add,".png");
        add2=strcat("C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalImage\validation\target\",add);
        saveas(gcf,add2);
        validationLabel(i)=0;
     else
        melSpectrogram(y,freq);
        axis off
        colorbar('off')
        add=string(i);
        add=strcat(add,".png");
        add2=strcat("C:\Users\Parisa\Desktop\ProjectKarshenasi\CategoricalImage\validation\non_target\",add);
        saveas(gcf,add2);
        validationLabel(i)=1;
     end
     audiovalidation(:,i)=y; 
             
end 

