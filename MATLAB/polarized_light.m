%% 默认值设定
lx=1; ly=1.5; %初始时x方向和y方向光矢量的长度
deltaA=pi/2; %初始x和y方向的相位差（实际在这里是x和z方向）
thick=-1/4; %玻片的类型
deltaC=2*pi*thick; %玻片引起的相位差
xmin=-lx-1; xmax=lx+1; %坐标轴范围
ymin=-10; ymax=0;
zmin=-ly-1; zmax=ly+1;
vd=12; %显示向量的数据间隔，每隔12个点显示一个向量
ra=0.05; %每一个时间单位长度对应角度变化大小
Q=2; %设置显示点的倍数，或者说一个周期长度缩减至原来的1/Q倍
num=floor(Q*(0-ymin)/ra)+1; %在坐标轴范围内点的个数
yb=-5; %玻片所处位置
num1=ceil(num*yb/ymin); %玻片所处位置对应点个数
pxmy=(0:-ra/Q:ymin); %每一个对应点的y坐标
pxmx=zeros(1,num); pzmz=pxmx; %玻片前方的图像坐标
pxmx1=zeros(1,num-num1); pzmz1=pxmx1; %玻片后方的图像坐标
tspan=num+floor(2*pi/ra); %显示的时间长度
filename='pl3.gif'; fps=30;
%% 作图
figure1=figure(1);
figure1.OuterPosition=[350 1 864 864];
ax1=axes; %创建坐标区
ax1.Position=[0.06,0.06,0.90,0.90];

%面xz上的图像以及几条基准线
px=plot3([0 0],[0 0],[0 0],'LineWidth',1.5,'Color',[0 0.4470 0.7410]); px.Color(4)=0.7; hold on
pz=plot3([0 0],[0 0],[0 0],'LineWidth',1.5,'Color',[0.8500 0.3250 0.0980]); pz.Color(4)=0.7;
ps=plot3([0 0],[0 0],[0 0],'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);
px1=plot3([0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',[0 0.4470 0.7410]); px1.Color(4)=0.7;
pz1=plot3([0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',[0.8500 0.3250 0.0980]); pz1.Color(4)=0.7;
ps1=plot3([0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);
po=plot3([0 0],[0 yb],[0 0],'.','MarkerSize',15,'Color',[0 0 0]);
line([-lx 0 0 -lx 0;lx 0 0 lx 0],[0 0 0 yb yb;0 0 ymin yb yb],[0 -ly 0 0 -ly;0 ly 0 0 ly],'LineStyle','--','Color',[0.4,0.4,0.4]);

%移动的波的图像
pxm=plot3(zeros(1,num),pxmy,zeros(1,num),'--','LineWidth',1,'Color',[0 0.4470 0.7410]);pxm.Color(4)=0.5;
pzm=plot3(zeros(1,num),pxmy,zeros(1,num),'--','LineWidth',1,'Color',[0.8500 0.3250 0.0980]);pzm.Color(4)=0.5;
psm=plot3(zeros(1,num1),pxmy(1,1:num1),zeros(1,num1),'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);
psm1=plot3(zeros(1,num-num1),pxmy(1,num1+1:end),zeros(1,num-num1),'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);

%跟随波移动而做周期运动的一些向量
Vx=line(zeros(2,num),[pxmy;pxmy],zeros(2,num),'LineStyle','-.','Color',[0 0.4470 0.7410],'LineWidth',0.3);
Vz=line(zeros(2,num),[pxmy;pxmy],zeros(2,num),'LineStyle','-.','Color',[0.8500 0.3250 0.0980],'LineWidth',0.3);
Vs=line(zeros(2,num),[pxmy;pxmy],zeros(2,num),'LineStyle','-.','Color',[0.9290 0.6940 0.1250],'LineWidth',0.8);

%玻片的图像
[X,Z]=meshgrid([xmin+0.5,xmax-0.5],[zmin+0.5,zmax-0.5]);
Y = X.^0*yb;
surf(X,Y,Z,'FaceAlpha',0.1)

%图像的一些属性的设置
axis equal
grid on
xlim([xmin xmax]);ylim([ymin ymax]);zlim([zmin zmax])
xticks(xmin:0.5:xmax); set(gca,'xticklabel',[])
yticks(ymin:0.5:ymax); set(gca,'yticklabel',[])
zticks(zmin:0.5:zmax); set(gca,'zticklabel',[])
hold off

for t=1:tspan
    t1=ra*t;t2=lx*sin(-t1);t3=ly*sin(-t1+deltaA); %t1是t时刻的角度大小，t2是t时刻x轴方向向量对应的x轴坐标，t3是z轴方向向量对应的z轴坐标
    
    t33=ra*(t-num1);
    if t33>0
        t4=ly*sin(-t33+deltaA+deltaC); %t4是经过玻片后z轴方向向量对应的z轴坐标
    else 
        t4=0;
    end
    
    %更新xz平面上的图像
    set(px,'xData',[0 t2])
    set(pz,'zData',[0 t3])
    set(ps,'xData',[0 t2],'zData',[0 t3])
    set(px1,'xData',[0 pxmx(num1)])
    set(pz1,'zData',[0 t4])
    set(ps1,'xData',[0 pxmx(num1)],'zData',[0 t4])
    
    %更新移动的波的图像
    pxmx=[t2 pxmx(1,1:end-1)];
    pzmz=[t3 pzmz(1,1:num1-1) t4 pzmz(1,num1+1:end-1)]; 
    pxmx1=pxmx(1,num1+1:end);
    pzmz1=pzmz(1,num1+1:end);
    set(pxm,'xData',pxmx)
    set(pzm,'zData',pzmz)
    set(psm,'xData',pxmx(1,1:num1),'zData',pzmz(1,1:num1))
    set(psm1,'xData',pxmx1,'zData',pzmz1)
    
    %更新在基准轴上分布的向量的图像
    for i=1:vd:num
       Vx(i).XData(2)=pxmx(i);
       Vz(i).ZData(2)=pzmz(i);
       Vs(i).XData(2)=pxmx(i); Vs(i).ZData(2)=pzmz(i);
    end
    drawnow
    
    %将图像保存为gif
%     Frame=getframe(gcf);
%     Image=frame2im(Frame);
%     [imind,cm]=rgb2ind(Image,256);
%     if t==num
%         imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',1/fps);
%     elseif t>num
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/fps);
%     end
end
close(1)