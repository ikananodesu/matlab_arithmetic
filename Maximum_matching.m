clc,clear,close all;
%[出发点 [V1 V2 V3 V4 V5]左匹配-[V6 V7 V8 V9 V10]右匹配 接收]
Need=0;
%定义流量图
Original_G=[0,1,1,1,1,1,0,0,0,0,0,0;
            0,0,0,0,0,0,0,1,1,0,0,0;
            0,0,0,0,0,0,0,0,1,1,1,0;
            0,0,0,0,0,0,1,1,1,0,1,0;
            0,0,0,0,0,0,0,0,1,0,0,0;
            0,0,0,0,0,0,0,0,1,1,1,0;
            0,0,0,0,0,0,0,0,0,0,0,1;
            0,0,0,0,0,0,0,0,0,0,0,1;
            0,0,0,0,0,0,0,0,0,0,0,1;
            0,0,0,0,0,0,0,0,0,0,0,1;
            0,0,0,0,0,0,0,0,0,0,0,1;
            0,0,0,0,0,0,0,0,0,0,0,0];
%空闲量图
Residual_G=Original_G;
%反向流图
[L,~]=size(Original_G);
Inversion_G=zeros(L,L);
%定义初始点
Begin_P=[1;0];
flag=0;
%迭代器
while 1
[Residual_G,Inversion_G,flag]=Graph_iteration_F(Begin_P,L,Residual_G,Inversion_G);
    if flag~=0
        break;
    end
end
Answer_G=Original_G-(Residual_G-Inversion_G);
for j=1:L
    for i=1:j
        %将反向流清除
        if(Answer_G(j,i)~=0)
            Answer_G(i,j)=Answer_G(i,j)-Answer_G(j,i);
            Answer_G(j,i)=0;
        end
    end
end
%输出最大流量分配图
if Need>sum(Answer_G(1,:))
    disp('寄了，网络装不下');
else
    disp('实现需求了');
    disp(Answer_G);
    disp('最大总流量：')
    disp(sum(Answer_G(1,:)));
end
%算法实现函数
%流通图迭代函数
function [Residual_G,Map_F,flag]=Graph_iteration_F(Begin_P,L,Residual_G,Map_F)
%Dijkstra算法搬过来 寻找一条可行路径
 %定义开放、关闭队列、当前位置
 Openlist=[];
 Closelist=[];
 Openlist=[Begin_P,Openlist];
 Now_P=[];
 %初始化结果路径表
 %第一列是目标节点 第二列是最短路径 第三列是父节点
 select_Map=linspace(1,L,L)';
 select_Map(:,2:3)=0;
 %遍历搜索
 while ~isempty(Openlist)
     Now_P=Openlist(:,1);
     Closelist=[Closelist,Now_P];
     Openlist(:,1)=[];
     for i=1:L
         %遍历相邻节点
         if(Residual_G(Now_P(1),i)~=0)
             %如果存在相邻则判断 有没有走过、有没有在备择队列中
             if ~ismember(i,Openlist(1,:)','rows')&&~ismember(i,Closelist(1,:)','rows')
                 %插入队列
                 Openlist=[Openlist,[i;Now_P(2)+Residual_G(Now_P(1),i)]];
                 %如果没走过并且距离还更短
                 if((~ismember(i,Openlist(1,:)','rows')&&select_Map(i,2)>select_Map(Now_P(1),2)+Residual_G(Now_P(1),i))||select_Map(i,2)==0)
                    select_Map(i,2)=select_Map(Now_P(1),2)+Residual_G(Now_P(1),i);
                    select_Map(i,3)=Now_P(1);
                 end
             end
         end
     end
     %排序顺序
     Openlist=sortrows(Openlist',2,'ascend')';
 end
%根据select_Map得到路径path 尾节点初始化
Child=L;
R1=find(select_Map(:,1)==Child);
Father=select_Map(R1,3);
if Father==0
    flag=1;
    return
end
Point=Residual_G(Father,Child);
path=[Child;0];
%把路径录进来
while Father
    path=[[Father;Point],path];
    Child=Father;
    R1=find(select_Map(:,1)==Child);
    Father=select_Map(R1,3);
    if Father
        Point=Residual_G(Father,Child);
    end
end
if(path(1,1)~=1)
    flag=1;
else
    flag=0;
end
for i=1:length(path(1,:))-1
    %网络流图对应路线减去最小流
    Residual_G(path(1,i),path(1,i+1))=Residual_G(path(1,i),path(1,i+1))-min(path(2,1:end-1));
    %网络流图反向路线增加最小流
    Residual_G(path(1,i+1),path(1,i))=Residual_G(path(1,i+1),path(1,i))+min(path(2,1:end-1));
    %反向流图记录最小流
    Map_F(path(1,i+1),path(1,i))=Map_F(path(1,i+1),path(1,i))+min(path(2,1:end-1));
end
end