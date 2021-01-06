x = imread('D:\Matlab\MRI.png');
y = imread('D:\Matlab\PET.png');

x1 = rgb2gray(x);
y1 = rgb2gray(y);

x2 = imresize(x1,[256,256]);
y2 = imresize(y1,[256,256]);

[LL1,LH1,HL1,HH1] = dwt2(x2,'haar');
[LL2,LH2,HL2,HH2] = dwt2(y2,'haar');

f1 = imbilatfilt(LL1);
f2 = imbilatfilt(LL2);

LL3 = (f1+f2)/2;
[r,c] = size(LL1);

d11 = zeros(128,128);
d12 = zeros(128,128);
d13 = zeros(128,128);
d21 = zeros(128,128);
d22 = zeros(128,128);
d23 = zeros(128,128);


for i=1:3:(126)
    for j=1:3:(126)
        for k = i:1:(i+3)
            for l = j:1:(j+3)
                d11(k,l) = LH1(k,l);
                d12(k,l) = HL1(k,l);
                d13(k,l) = HH1(k,l);
                d21(k,l) = LH2(k,l);
                d22(k,l) = HL2(k,l);
                d23(k,l) = HH2(k,l);
            end
        end
        d11 = zeros(128,128);
        if contrast(d11)>=contrast(d21)
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL31(p,q) = d11(p,q);
                end
            end
        else
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL31(p,q) = d21(p,q);
                end
            end
        if contrast(d12)>=contrast(d22)
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL32(p,q) = d12(p,q);
                end
            end
        else
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL32(p,q) = d22(p,q);
                end
            end    
        if contrast(d13)>=contrast(d23)
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL33(p,q) = d13(p,q);
                end
            end
        else
            for p=i:1:(i+3)
                for q=j:1:(j+3)
                    LL33(p,q) = d23(p,q);
                end
            end
        end
        end
        end
    end
end

LL31 = zeros(128,128);
LL32 = zeros(128,128);
LL33 = zeros(128,128);

h = idwt2(LL3,LL31,LL32,LL33,'haar');
subplot(1,3,1), imshow(x2),title('Input Image 1');
subplot(1,3,2), imshow(y2),title('Input Image 2');
subplot(1,3,3), imshow(h,[]),title('Output Image');