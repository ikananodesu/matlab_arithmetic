clc,clear,close all;
%定义权重图
%******************************************************

%未完成 缺少一段反馈函数


Original_G=[0,-3,-5,0;
            0,-2,-1,-4;
            -3,-5,0,0;
            0,0,-2,-5];
[L,W]=size(Original_G);
%生成初始图
Map_input=Change(Original_G);
num=0;
%循环搜索
while num~=L
    [num,Map_input_min,d_L,d_W]=Addition(Map_input);
    if num~=L
        for i=1:L
            if d_L(i)~=i
                Map_input(i,:)=Map_input(i,:)-Map_input_min;
            end
            if d_W(i)~=i
                Map_input(i,:)=Map_input(i,:)-Map_input_min;
            end
        end
    else
        ans_path=Map_input;
    end
end
%矩阵松散化处理
function Map_output=Change(Map_input)
Map_input_min=min(Map_input(1:end,:));
Map_input=Map_input(:,1:end)-Map_input_min;
%每一行最小值除去
O_G_now=Map_input';
Map_input_min=min(O_G_now(1:end,:));
Map_input=O_G_now(1:end,:)-Map_input_min;
Map_output=Map_input';
end
%搜索最小边
function [num,Map_input_min,d_L,d_W]=Addition(Map_input)
    L=length(Map_input(:,1));
    num=0;
    times_L=0;
    d_L=zeros(L,1);
    d_W=zeros(L,1);
    for i=1:L
        d=i-times_L;
        [~,b]=size(find(Map_input(d,:)==0));
        if b>=2
            Map_input(d,:)=[];
            times_L=times_L+1;
            d_L(d)=d;
            num=num+1;
        end
    end
    times_W=0;
    for i=1:L
        d=i-times_W;
        [~,b]=size(find(Map_input(:,d)==0));
        if b>=2
            Map_input(:,d)=[];
            times_W=times_W+1;
            d_W(d)=d;
            num=num+1;
        end
    end
    Map_input_min=min(min(Map_input));
end