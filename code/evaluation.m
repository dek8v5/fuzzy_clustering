clear
clc
close all

mask1 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/7d7f8396b6f1e2a1f8417c3f42062a7dc0252fcec1a361bb85466197931a070d.png');
mask2 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/08ae7ecfa3f66f8ba283d7922af77248cddad8f01793d0f20e6ba459951db150.png');
mask3 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/38e8f52411fb6358ee3ebe6dff04f724093402ddce0c1eb01d4431d6034d14b9.png');
mask4 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/86fc97603d13c1e1b7e984b3fe3074d4ccbd5b6508a41d58b4859852c12be676.png');
mask5 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/499d529c138a545ccc316fd8742692f764dd6a61d3d8edcdc9d46eba35059f6f.png');
mask6 = imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e/masks/0758a93dac4911f5420343ca7321988a9897aa3e91f9e17c03b58fdafb346e64.png');

mask = (mask1 | mask2 | mask3 | mask4 | mask5 | mask6);


    prediction = imread('fuzzysegmented.png')*255;
    ground_truth = mask*255;
    
    true_positive = (prediction==255) & (ground_truth==255);
    tp = sum(true_positive);
    
    true_negative = ((prediction==0)&(ground_truth==0));
    tn = sum(true_negative);
    
    false_positive = ((prediction==255)&(ground_truth==0));
    fp = sum(false_positive);
    
    false_negative = ((prediction==0)&(ground_truth==255));
    fn = sum(false_negative);
    
    accuracy = (tp+tn)/(tp+tn+fp+fn);
    jaccard = tp/(tp+fp+fn);
    sensitivity = tp/(tp+fn);
    f1_score = 2*tp/(2*tp+fp+fn);
    precision = tp/(tp+fp);
    
    %draw the segmentation result based on the evaluations
    tn_final = true_negative * 2;
    tp_final = true_positive;
    fp_final = false_positive * 3;
    fn_final = false_negative * 4;
    
    result_final = abs(tn_final+tp_final+fp_final+fn_final);

    result_final = imshow(result_final, [0 1 0; 0 0 0;0 0 1; 1 0 0])
    title('accuracy: green (tp), black (tn), blue(fp), red(fn)');
    
accuracy_total = mean(accuracy)
jaccard_total= mean(jaccard)
sensitivity_total=mean(sensitivity)
f1_score_total = mean(f1_score)
precision_total = mean(precision)
