clc,clear,close all;
%定义邻接图
Map=[0,1,0,1,1,0,0,0;
     1,0,1,0,0,1,0,0;
     0,1,0,1,0,0,1,0;
     1,0,1,0,0,0,0,1;
     1,0,0,0,0,1,0,1;
     0,1,0,0,1,0,1,0;
     0,0,1,0,0,1,0,1;
     0,0,0,1,1,0,1,0];
 [L,~]=size(Map);
 %定义初始点
 Begin_P=1;
 %定义开放、关闭队列、当前位置
 Openlist=[];
 Closelist=[];
 Openlist=[Begin_P,Openlist];
 Now_P=[];
 %初始化结果路径表
 %第一列是节点，第二列是临接关系
 select_Map=linspace(1,L,L)';
 select_Map(:,2)=0;
 select_Map(Begin_P,2)=1;
 flag=0;
 while ~isempty(Openlist)
     Now_P=Openlist(1);
     Openlist(1)=[];
     Closelist=[Closelist,Now_P];
     for i=1:L%相比于遍历 直接把邻节点存储进来会更快
         if Map(Now_P,i)==0
             continue;
         end
         if select_Map(i,2)==select_Map(Now_P,2)
             %存在相邻同类型的节点
            flag=1;
            break;
         end
         if ~ismember(i,Openlist','rows')&&~ismember(i,Closelist','rows')
            select_Map(i,2)=-select_Map(Now_P,2);
            Openlist=[Openlist,i];
         end
     end
     if ~ismember(0,select_Map(:,2),'rows')
         break;
     end
     if flag
         break;
     end
 end
 %正常展开 这是二部图
if flag
    disp('不是二部图，寄');
else
    disp('是二部图');
    disp(select_Map);
end
 
 