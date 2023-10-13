%Untuk membersihkan data 
clear all;
clc;

%Untuk membaca Dataset
%E:\E-LEARNING UMBY\E-LEARNING UMBY SEMESTER 8\SKRIPSI\script\makanan
%(lokasi file)
imds=imageDatastore("E:\E-LEARNING UMBY\E-LEARNING UMBY SEMESTER 8\SKRIPSI\script\makanan","IncludeSubfolders",true,"LabelSource","foldernames")
[dLatih,dUji] = splitEachLabel(imds,0.8)

%Untuk mempreprocessing data
Latihds=augmentedImageDatastore([64 64],dLatih,"ColorPreprocessing","none")
Ujids=augmentedImageDatastore([64 64],dUji,"ColorPreprocessing","none")

% Untuk mengatur parameter
option=trainingOptions("sgdm", ...
    "plots","training-progress", ...
    "Verbose",false, ...
    "MaxEpochs", 10, ...
    "Shuffle","every-epoch", ...
    "InitialLearnRate",0.01, ...
    "ValidationData",Ujids, ...
    "ValidationFrequency",30)

%Arsitektur CNN
layers = [imageInputLayer([64 64 3],"Name","imageinput")
    convolution2dLayer([3 3],32,"Name","convo1","Padding","same")
    batchNormalizationLayer("Name","bn1")
    reluLayer("Name","relu1")
    maxPooling2dLayer([2 2],"Name","maxPool1","Padding","same","Stride",[2 2])
    convolution2dLayer([3 3],64,"Name","convo2","Padding","same")
    batchNormalizationLayer("Name","bn2")
    reluLayer("Name","relu2")
    maxPooling2dLayer([2 2],"Name","maxPool2","Padding","same","Stride",[2 2])
    convolution2dLayer([3 3],128,"Name","convo3","Padding","same")
    batchNormalizationLayer("Name","bn3")
    reluLayer("Name","relu3")
    maxPooling2dLayer([2 2],"Name","maxPool3","Padding","same","Stride",[2 2])
    fullyConnectedLayer(10,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name", "classoutput")];

%Untuk memproses training data
net = trainNetwork(Latihds, layers, option)

analyzeNetwork(layers)

%Untuk memprediksi data Uji
preds = classify(net, Ujids)
trueS = dUji.Labels

%Untuk melihat berapa akurasi yang dihasilkan dari proses training
accuracy = sum(preds==trueS)/numel(trueS)

%Untuk melihat hasil data Uji menggunakan Confusion Matrix
confusionchart(trueS, preds)

%menyimpan hasil training
save net
