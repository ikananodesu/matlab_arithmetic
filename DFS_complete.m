clc,clear,close all;
%绘制地图
Map=getMap();
%起始点与目标点 覆盖地图
Start_Point=[8;1];
End_Point=[1;2];
%标注 可行径点为0 障碍物为1 起始点为2 目标点为3 路径为4
Map(Start_Point(1),Start_Point(2))=2;
Map(End_Point(1),End_Point(2))=3;
[L,W]=size(Map);
%判断是否可达
reachable=reachable_F(Map,Start_Point,End_Point);
%输出路径
if reachable
    path=DFS_F(Map,Start_Point,End_Point);
    for i=2:length(path)-1
        Map(path(1,i),path(2,i))=4;
    end
imagesc(Map);
colorbar;
else
    disp('寄了找不到');
    imagesc(Map);
    colorbar;
end

%绘制地图
function Map=getMap()
Map=zeros(20,20);
Map(4:16,4)=1;
Map(5:14,5)=1;
Map(15:20,7:9)=1;
Map(19:20,5:6)=1;
Map(5:9,2)=1;
Map(2:19,17)=1;
Map(17:19,1:2)=1;
Map(3,1:19)=1;
Map(5:14,9)=1;
end
%能不能找到路径
function reachable = reachable_F(Map,Start_Point,End_Point)
%四方向通路 左上右下，第一行x轴第二行y轴
direction=[[1;0],[0;1],[-1;0],[0;-1]];
openlist=Start_Point;
closelist=[];
node_now=[];
[L,W]=size(Map);
while ~isempty(openlist)
    %取用开放表第一个点
   currentNode=openlist(:,1);
   if currentNode == End_Point
       reachable=true;
       return;
   end
   %当前节点已经用过了 关闭表录入 开放表删除
   closelist=[closelist,currentNode];
   openlist(:,1)=[];
   %四连通找到周围节点加入开放列表
   for i=1:4
       node_now(:,i)=currentNode+direction(:,i); 
       if ~ismember(node_now(:,i)',closelist','rows')&&node_now(1,i)>=1&&node_now(2,i)>=1&&node_now(1,i)<=L&&node_now(2,i)<=W&&Map(node_now(1,i),node_now(2,i))~=1
           if ~ismember(node_now(:,i)',openlist','rows')
           openlist=[openlist,node_now(:,i)];
           end
       end
   end
end
reachable=false;
end
%将点存入parent中
function path=DFS_F(Map,Start_Point,End_Point)
    openlist=Start_Point;
    closelist=[];
    direction=[[1;0],[0;1],[-1;0],[0;-1]];
    node_now=[];
    [L,W]=size(Map);
    parent=containers.Map('KeyType', 'char', 'ValueType', 'any');
    while ~isempty(openlist)
        currentNode=openlist(:,1);
        if currentNode==End_Point
            path=getPath(parent,Start_Point,End_Point);
            return;
        end
        closelist=[closelist,currentNode];
        openlist(:,1)=[];
        for i=1:4
           node_now(:,i)=currentNode+direction(:,i); 
           if ~ismember(node_now(:,i)',closelist','rows')&&node_now(1,i)>=1&&node_now(2,i)>=1&&node_now(1,i)<=L&&node_now(2,i)<=W&&Map(node_now(1,i),node_now(2,i))~=1
               if ~ismember(node_now(:,i)',openlist','rows')
                   openlist=[openlist,node_now(:,i)];
                   parent(mat2str(node_now(:,i)))=currentNode;
               end
           end
        end
        path=[];
    end
end
%从parent中读取路径
function path=getPath(parent,Start_Point,End_Point)
    path=[End_Point];
    while ~isequal(path(:,1),Start_Point)
        path=[parent(mat2str(path(:,1))),path];
    end
end