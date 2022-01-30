%extract feature


trainLabelCat=categorical(trainLabel);
validationLabelCat=categorical(validationLabel);


FFTLength = 512;
numBands = 64;
frequencyRange = [125 7500];
windowLength = 0.025*freq;
overlapLength = 0.015*freq;


trainFeatures = melSpectrogram(audiotrain,freq, ...
   'Window',hann(windowLength,'periodic'), ...
   'OverlapLength',overlapLength, ...
   'FFTLength',FFTLength, ...
    'FrequencyRange',frequencyRange, ...
    'NumBands',numBands, ...
    'FilterBankNormalization','none', ...
    'WindowNormalization',false, ...
    'SpectrumType','magnitude', ...
    'FilterBankDesignDomain','warped');

trainFeatures = log(trainFeatures + single(0.001));
trainFeatures = permute(trainFeatures,[2,1,4,3]);
trainFeatures=imresize(trainFeatures,[96 ,64]);

validationFeatures = melSpectrogram(audiovalidation,freq, ...
    'Window',hann(windowLength,'periodic'), ...
    'OverlapLength',overlapLength, ...
    'FFTLength',FFTLength, ...
    'FrequencyRange',frequencyRange, ...
    'NumBands',numBands, ...
    'FilterBankNormalization','none', ...
    'WindowNormalization',false, ...
    'SpectrumType','magnitude', ...
    'FilterBankDesignDomain','warped');


validationFeatures = log(validationFeatures + single(0.001));
validationFeatures = permute(validationFeatures,[2,1,4,3]);
validationFeatures=imresize(validationFeatures,[96, 64]);


net = yamnet;
net.Layers(end).Classes

uniqueLabels = unique(trainLabelCat);
numLabels = numel(uniqueLabels);

lgraph = layerGraph(net.Layers);

lgraph = replaceLayer(lgraph,"dense",fullyConnectedLayer(numLabels,"Name","dense"));
lgraph = replaceLayer(lgraph,"Sound",classificationLayer("Name","Sounds","Classes",uniqueLabels));

options = trainingOptions('adam','ValidationData',{single(validationFeatures),validationLabelCat},'MaxEpochs',30,'MiniBatchSize',8);

newnet=trainNetwork(single(trainFeatures),trainLabelCat,lgraph,options);

