clc,clear,close all;

%定义一个有向有权图
Map = [4, 0, 2, 0, 1, 0, 0, 8;
       0, 2, 0, 0, 3, 1, 0, 0;
       1, 0, 0, 8, 0, 7, 2, 9;
       0, 1, 0, 4, 0, 0, 8, 0;
       5, 0, 0, 0, 9, 4, 0, 7;
       0, 4, 0, 1, 0, 9, 5, 2;
       0, 0, 4, 0, 0, 0, 0, 1;
       0, 3, 0, 2, 0, 8, 0, 0];
 [L,~]=size(Map);
 %定义初始点
 Begin_P=[1;0];
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
         if(Map(Now_P(1),i)~=0)
             %如果存在相邻则判断 有没有走过、有没有在备择队列中
             if ~ismember(i,Openlist(1,:)','rows')&&~ismember(i,Closelist(1,:)','rows')
                 %插入队列
                 Openlist=[Openlist,[i;Now_P(2)+Map(Now_P(1),i)]];
                 %如果没走过并且距离还更短
                 if((~ismember(i,Openlist(1,:)','rows')&&select_Map(i,2)>select_Map(Now_P(1),2)+Map(Now_P(1),i))||select_Map(i,2)==0)
                    select_Map(i,2)=select_Map(Now_P(1),2)+Map(Now_P(1),i);
                    select_Map(i,3)=Now_P(1);
                 end
             end
         end
     end
     %排序顺序
     Openlist=sortrows(Openlist',2,'ascend')';
 end
disp(select_Map);
