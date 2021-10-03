%% 初始化
%一些基本参数
Es0=0.5; Ep0=0.5; %r和p分量振幅 
k1=4; w=0.02; %角频率
r=0:0.05:5; t=0; tspan=100; %绘制的空间以及时间范围
node_num=length(r);
n1=1; n2=1.6; n21=n2/n1; %介质折射率以及相对折射率
k2=n21*k1; %介质2中的空间角频率
in_angle=pi/7; %入射角
cnone=zeros(1,node_num); %用于作图
l_num=2; %光线数目
%基本波函数
E_s1=Es0*cos(k1*r);
E_p1=Ep0*cos(k1*r);
E_s2=Es0*cos(k2*r);
E_p2=Ep0*cos(k2*r);
%作图的容器
fig3=figure('WindowState','maximized');
ax3=axes(fig3);
%一些用到的匿名函数
RM=@(theta)[cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)]; %绕y轴顺时针旋转的矩阵
p_handle=@(ax,coords) plot3(ax,coords(1,:),coords(2,:),coords(3,:)); %利用坐标矩阵绘图的函数
%振幅比
delta=n21^2-sin(in_angle)^2; 
if delta>0 %判断是否处于全反射状态
    rs=(cos(in_angle)-sqrt(delta))/(cos(in_angle)+sqrt(delta));
    ts=(2*cos(in_angle))/(cos(in_angle)+sqrt(delta));
    rp=(n21^2*cos(in_angle)-sqrt(delta))/(n21^2*cos(in_angle)+sqrt(delta));
    tp=(2*n21*cos(in_angle))/(n21^2*cos(in_angle)+sqrt(delta));
    delta_s=0; %未处于全反射状态时相移通过rs、rp的正负体现
    delta_p=0;
else
    delta=-delta;
    rs=(cos(in_angle)-1i*sqrt(delta))/(cos(in_angle)+1i*sqrt(delta));
    rp=(n21^2*cos(in_angle)-1i*sqrt(delta))/(n21^2*cos(in_angle)+1i*sqrt(delta));
    delta_s=angle(rs);
    rs=abs(rs);
    delta_p=angle(rp);
    rp=abs(rp);
end
%% 作图
plot3(ax3,0,0,0) %确保先创建一个三维图形对象再使用hold，否则会一直保持默认的二维坐标轴状态
hold(ax3,'on')
%光线s分量
[P(1,1),P(2,1),P(3,1)]=creat_p(p_handle,ax3,[r;-E_s1;cnone],[r;-E_s1;cnone],[r;-E_s2;cnone],{'--',0.8,1}); 
%P是一个图形句柄数组，第一行保存入射光的图形句柄，第二行保存反射光的图形句柄，第三行保存折射光的图形句柄
%P的第一列对应s分量，第二列对应p分量，第三列对应合成量，第四列对应波矢所在基准线
%光线p分量
[P(1,2),P(2,2),P(3,2)]=creat_p(p_handle,ax3,[r;cnone;-E_p1],[r;cnone;E_p1],[r;cnone;E_p2],{'--',0.8,2}); 
%光线合矢量
[P(1,3),P(2,3),P(3,3)]=creat_p(p_handle,ax3,[r;-E_s1;-E_p1],[r;-E_s1;E_p1],[r;-E_s2;E_p2],{'-',1.2,3}); 
%波矢所在直线
P(1,4)=line(ax3,[0 r(end)],[0 0],[0 0],'Color','k','LineWidth',0.5);
P(2,4)=copyobj(P(1,4),ax3);  
P(3,4)=copyobj(P(1,4),ax3);
RMs=zeros(6);
RMs(1:3,1:3)=RM(-in_angle-pi/2); %入射光的旋转矩阵
RMs(4:6,4:6)=RM(in_angle-pi/2); %反射光的旋转矩阵
%RMs是存储旋转矩阵的准对角阵
coords=[[r;-E_s1;cnone],[r;cnone;-E_p1],[r;-E_s1;-E_p1],[r(end);0;0]
        [r;-E_s1;cnone],[r;cnone;E_p1],[r;-E_s1;E_p1],[r(end);0;0]];
%coords是存储坐标的矩阵
%每三行是一条光线的所有成分的x,y,z坐标，1:node_num列为s分量，node_num+1:2*node_num列为p分量...

if n21<1 && in_angle>=asin(n21) %全反射情况
    delete(P(3,:)); P=P(1:2,:); %全反射时，删除折射光对应的图形对象
    coords=RMs*coords; %对坐标进行旋转操作
    x_left=coords(1,end)-0.5; x_right=coords(4,end)+0.5;
    z_top=coords(3,end)+0.5; z_bottom=-0.5; %z轴坐标区范围
    set(P(1,4),{'XData','YData','ZData'},{[0 coords(1,end)],[0 coords(2,end)],[0 coords(3,end)]})
    set(P(2,4),{'XData','YData','ZData'},{[0 coords(4,end)],[0 coords(5,end)],[0 coords(6,end)]})
    coords=coords(:,1:end-1); P=P(:,1:end-1); %基准线坐标只更新一次，不保留基准线端点坐标以及图形句柄
    update_coords(coords,P,l_num,node_num);
else
    l_num=3;
    ref_angle=asin(sin(in_angle)/n21);
    RMs(7:9,7:9)=RM(-ref_angle+pi/2);
    coords(7:9,:)=[[r;-E_s2;cnone],[r;cnone;E_p2],[r;-E_s2;E_p2],[r(end);0;0]];
    coords=RMs*coords;
    x_left=coords(1,end)-0.5; x_right=coords(4,end)+0.5;
    z_top=coords(3,end)+0.5; z_bottom=coords(end,end)-0.5;
    set(P(1,4),{'XData','YData','ZData'},{[0 coords(1,end)],[0 coords(2,end)],[0 coords(3,end)]})
    set(P(2,4),{'XData','YData','ZData'},{[0 coords(4,end)],[0 coords(5,end)],[0 coords(6,end)]})
    set(P(3,4),{'XData','YData','ZData'},{[0 coords(7,end)],[0 coords(8,end)],[0 coords(9,end)]})
    coords=coords(:,1:end-1); P=P(:,1:end-1);
    update_coords(coords,P,l_num,node_num);
end

%创建水平面和法向平面
surf(ax3,[x_left,x_right;x_left,x_right],[2,2;-2,-2],[0,0;0,0],'FaceAlpha',0.4,'EdgeColor','none','FaceColor',[0.3010 0.7450 0.9330])
surf(ax3,[0,0;0,0],[1.5,-1.5;1.5,-1.5],[z_top,z_top;z_bottom,z_bottom],'FaceAlpha',0.4,'EdgeColor','none','FaceColor','y')

set(ax3,{'XLim','YLim','ZLim'},{[x_left,x_right],[-2,2],[z_bottom,z_top]})
axis(ax3,'equal'); grid(ax3,'on'); hold(ax3,'off')
%%
if l_num==3
    while t<tspan
    t=t+1;
    new_Esin=-Es0*cos(k1*r+w*t);
    new_Epin=-Ep0*cos(k1*r+w*t);
    new_Esout1=-Es0*cos(k1*r-w*t);
    new_Epout1=Ep0*cos(k1*r-w*t);
    new_Esout2=-Es0*cos(k2*r-w*t);
    new_Epout2=Ep0*cos(k2*r-w*t);
    coords=[[r;new_Esin;cnone],[r;cnone;new_Epin],[r;new_Esin;new_Epin]
        [r;rs*new_Esout1;cnone],[r;cnone;rp*new_Epout1],[r;rs*new_Esout1;rp*new_Epout1]
        [r;ts*new_Esout2;cnone],[r;cnone;tp*new_Epout2],[r;ts*new_Esout2;tp*new_Epout2]];
    update_coords(RMs*coords,P,l_num,node_num);
    drawnow
    end
else
    while t<tspan
        t=t+1;
        new_Esin=-Es0*cos(k1*r+w*t);
        new_Epin=-Ep0*cos(k1*r+w*t);
        new_Esout1=-Es0*cos(k1*r-w*t+delta_s);
        new_Epout=Ep0*cos(k1*r-w*t+delta_p);
        coords=[[r;new_Esin;cnone],[r;cnone;new_Epin],[r;new_Esin;new_Epin]
            [r;rs*new_Esout1;cnone],[r;cnone;rp*new_Epout],[r;rs*new_Esout1;rp*new_Epout]];
        update_coords(RMs*coords,P,l_num,node_num);
        drawnow
    end
end
%%
function [pE1,pE2,pE3]=creat_p(p_handle,ax,in_coords,out_coords1,out_coords2,prop_cell) %用于创建三条光线的图形句柄
    pE1=p_handle(ax,in_coords); %入射光
    pE2=p_handle(ax,out_coords1); %反射光
    pE3=p_handle(ax,out_coords2); %折射光
    linkprop([pE1,pE2,pE3],{'LineStyle','LineWidth','SeriesIndex'});
    set(pE1,{'LineStyle','LineWidth','SeriesIndex'},prop_cell);
end

function update_coords(coords,P,l_num,node_num)
    for i=1:l_num
       for j=1:3
           set(P(i,j),{'XData','YData','ZData'},{coords(3*i-2,node_num*(j-1)+1:node_num*j),...
               coords(3*i-1,node_num*(j-1)+1:node_num*j),coords(3*i,node_num*(j-1)+1:node_num*j)})
       end
    end
end