clc;close all; clear;


left_I=imread('view0.png');
right_I=imread('view1.png');
left_I=mean(left_I,3);
right_I=mean(right_I,3);
disp_range=70;
block=32;
[row,col]=size(left_I);
%because our block is square and each pixel makes gradiant and angle values:
left_gr=zeros(col,(block^2)*2);
right_gr=zeros(col,(block^2)*2);
disparity=ones(row,col)*Inf;
for i=(block/2)+1:row-block/2
    for j=(block/2)+1:col-block/2
        [R_Gx,R_Gy]=imgradientxy(right_I(i-(block/2):i+(block/2)-1,j-(block/2):j+(block/2)-1));
        [L_Gx,L_Gy]=imgradientxy(left_I(i-(block/2):i+(block/2)-1,j-(block/2):j+(block/2)-1));
        right_gr(j,:)=[R_Gx(:);R_Gy(:)];
        left_gr(j,:)=[L_Gx(:);L_Gy(:)];
    end
    disp_row=zeros(col,1);
    for loc=(block/2)+1:col-block/2
        min_val=Inf;
        min_loc=Inf;
        for s=loc:min(loc+(block/2)+disp_range, col - (block/2))
            d=sum(sum((left_gr(s,:)-right_gr(loc,:)).^2));
            if d<min_val
                min_val=d;
                min_loc=s-loc+1;
            end
        end
        if min_loc>=min(loc+(block/2)+disp_range, col - (block/2))-10
            min_loc=disp_row(loc-1);
        end
        disp_row(loc)=min_loc;
    end
    disparity(i,:)=disp_row;
    left_gr(:)=0;
    right_gr(:)=0;
end
Disparity=disparity((block/2)+1:row-(block/2),(block/2)+1:col-(block/2));
imshow(Disparity);
colormap jet;
colorbar ;
caxis([0 60]);
colormapeditor
%     
    
    
    
    
    
    