clc,clear,close all;
%定义一个无向有权图
Map = [0, 1, 2, 0, 1, 0, 0, 0;
       1, 0, 0, 0, 3, 1, 0, 1;
       2, 0, 0, 8, 0, 7, 2, 0;
       0, 0, 8, 0, 0, 0, 8, 0;
       1, 3, 0, 0, 0, 4, 0, 1;
       0, 1, 7, 0, 4, 0, 0, 0;
       0, 0, 2, 8, 0, 0, 0, 1;
       0, 1, 0, 0, 1, 0, 1, 0];
[L,~]=size(Map);
Begin_P=6;
%定义已经搜索、未搜索队列、当前位置
 Complete_list=[];
 Wait_list=linspace(1,L,L)';
 Now_P=Begin_P;
 %初始化结果路径表
 %第一列是目标节点 第二列是最短路径 第三列是父节点
 select_Map=linspace(1,L,L)';
 select_Map(:,2:3)=0;
 Inner=zeros(3,1);
 Inner=[];
 flag=0;
 while ~isempty(Wait_list)
     %将选中的点添加入树中
     Complete_list=[Complete_list,Now_P];
     %在未搜索队列中寻找对应索引并删除
     R1=find(Wait_list==Now_P);
     Wait_list(R1)=[];
     %如果未搜索队列已经空了，说明所有节点都被找到，结束算法
     if(isempty(Wait_list)==1)
         break;
     end
     %遍历生成树临接节点，寻找最小临接边
     for i=1:length(Complete_list)
         for j=1:length(Wait_list)
             if(Map(Complete_list(i),Wait_list(j))~=0)
                Inner=[Inner,[Complete_list(i);Wait_list(j);Map(Complete_list(i),Wait_list(j))]];
             end
         end
     end
     if(isempty(Inner)&&~isempty(Wait_list))
         flag=1;
         break;
     end
     Inner=sortrows(Inner',3,'ascend')';
     select_Map(Inner(2,1),3)=Inner(1,1);
     select_Map(Inner(2,1),2)=Inner(3,1);
     Now_P=Inner(2,1);
     Inner=[];
 end
 if(flag)
     disp('存在独立节点 寄了');
 else
    %输出最小生成树和路径长度
    disp('起点是');
    disp(Begin_P);
    disp('生成树为');
    disp(select_Map);
    disp('长度是');
    disp(sum(select_Map(:,2)));
 end