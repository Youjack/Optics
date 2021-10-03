interval=0.08; %interval为timer执行回调函数之间的时间间隔。由于timer的执行效果受硬件影响较大，请结合自身硬件谨慎设置时间间隔。
num=76; %图线节点数，控制图像精度
main(interval,num);
%%
function main(interval,num)
    %% 创建控件
    fig1=uifigure('WindowState','maximized','Color','w');

    ax1=uiaxes(fig1,'Position',[20 530 350 250]);
    ax2=uiaxes(fig1,'Position',[400 530 350 250]);
    ax3=uiaxes(fig1,'Position',[770 10 750 750]);

    slider_Es0=uislider(fig1,'Position',[120 450 150 3],'Limits',[0 1],'Value',0.5);
    uilabel(fig1,"Position",[85 435 35 40],'Text','Es0');
    slider_Ep0=uislider(fig1,'Position',[400 450 150 3],'Limits',[0 1],'Value',0.5);
    uilabel(fig1,"Position",[365 435 35 40],'Text','Ep0');

    slider_n1=uislider(fig1,'Position',[120 380 150 3],'Limits',[1 2],"Value",1);
    uilabel(fig1,"Position",[85 365 35 40],'Text','n1');
    slider_n2=uislider(fig1,'Position',[400 380 150 3],'Limits',[1 2],'Value',1.5);
    uilabel(fig1,"Position",[365 365 35 40],'Text','n2');

    slider_i1=uislider(fig1,'Position',[120 310 150 3],'Limits',[0 pi/2],"Value",pi/6);
    uilabel(fig1,"Position",[85 295 35 40],'Text','i1');
    slider_k1=uislider(fig1,'Position',[400 310 150 3],'Limits',[1 10],'Value',4);
    uilabel(fig1,"Position",[365 295 35 40],'Text','k1');
    slider_w=uislider(fig1,'Position',[120 240 150 3],'Limits',[0.01 0.15],"Value",0.08);
    uilabel(fig1,"Position",[85 225 35 40],'Text','w');

    bt1=uibutton(fig1,'state','Text','开始/中止','Value',1,'Position',[720 360 70 20]);
    bt2=uibutton(fig1,'Text','查看ib','Position',[720 320 70 20]); %查看布儒斯特角情况
    bt3=uibutton(fig1,'Text','切换正视','Position',[720 280 70 20]);
    bt4=uibutton(fig1,'Text','切换俯视','Position',[720 240 70 20]);
    bt5=uibutton(fig1,'Text','切换侧视','Position',[720 200 70 20]);
    
    tb1=uitable(fig1,'Data',[0,0,0,0,0,0;0,0,0,0,0,0],'Position',[75 80 505 74],'ColumnName',{'振幅反射率','振幅透射率','光强反射率',...
        '光强透射率','能流反射率','能流透射率'},'RowName',{'s分量','p分量'});

    timer1=timer("BusyMode","queue","ExecutionMode","fixedSpacing","Period",interval); %用于更新图像的timer 
    %% 初始化
    %一些基本参数
    Es0=slider_Es0.Value; Ep0=slider_Ep0.Value; %r和p分量振幅
    k1=slider_k1.Value; w=slider_w.Value; %角频率
    n1=slider_n1.Value; n2=slider_n2.Value; n21=n2/n1; %介质折射率以及相对折射率
    k2=n21*k1; %介质2中的空间角频率
    in_angle=slider_i1.Value; %入射角
    r=linspace(0,5,num); t=0; %绘制的空间以及时间范围
    node_num=num; %需要连接的节点数
    cnone=zeros(1,node_num); %用于作图
    l_num=2; %l_num代表光线数目（全反射下不绘制隐失波）
    RMs=zeros(6); %RMs是存储旋转矩阵的准对角阵
    rs=0; ts=0; rp=0; tp=0; %振幅比
    delta_s=0; delta_p=0; %s和p分量的相移

    %一些用到的匿名函数
    RM=@(theta)[cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)]; %绕y轴顺时针旋转的矩阵（从y轴负向看去）
    p_handle=@(ax,coords) plot3(ax,coords(1,:),coords(2,:),coords(3,:)); %利用坐标矩阵绘图的函数

    %% 作图，创建图像句柄
    %振幅比部分
    p_ax1s(1)=plot(ax1,0,0,'--','LineWidth',1.2,'Color',[0.6,0.7,0.9]); %标注当前角度的竖直虚线的句柄
    hold(ax1,'on')
    p_ax1s(2:5)=plot(ax1,[0;0],[0 0 0 0;1 1 1 1],'LineWidth',1.2); %振幅比曲线的图像句柄
    legend(ax1,p_ax1s(2:5),{'$r_s$','$t_s$','$r_p$','$t_p$'},'Location',"best",'Interpreter',"latex",'FontSize',13,'NumColumns',2)
    grid(ax1,'on')
    title(ax1,'振幅比')
    xlabel(ax1,'入射角')
    ylabel(ax1,'比值')
    xlim(ax1,[0 90])
    hold(ax1,'off')
    
    %能流反射率、透射率部分
    p_ax2s(1)=plot(ax2,0,0,'--','LineWidth',1.2,'Color',[0.6,0.7,0.9]); %标注当前角度的竖直虚线的句柄
    hold(ax2,'on')
    p_ax2s(2:7)=plot(ax2,[0;0],[0 0 0 0 0 0;1 1 1 1 1 1],'LineWidth',1.2); %能流反射率、透射率曲线的图像句柄
    p_ax2s(end-1).LineStyle='--'; p_ax2s(end).LineStyle='--'; %设置总能流反射率、透射率为虚线
    legend(ax2,p_ax2s(2:7),{'$\mathcal{R}_s$','$\mathcal{J}_s$','$\mathcal{R}_p$','$\mathcal{J}_p$','$\mathcal{R}$','$\mathcal{J}$'},'Location',"best",'Interpreter',"latex",'FontSize',12,'NumColumns',2)
    grid(ax2,'on')
    title(ax2,'能流反射率及能流透射率')
    xlabel(ax2,'入射角')
    ylabel(ax2,'大小')
    xlim(ax2,[0 90])
    hold(ax2,'off')
    
    %主要部分
    plot3(ax3,0,0,0,'k.') %确保先创建一个三维图形对象再使用hold，否则会一直保持默认的二维坐标轴状态
    hold(ax3,'on')
    %创建水平面和法向平面
    surf(ax3,[-10,10;-10,10],[2,2;-2,-2],[0,0;0,0],'FaceAlpha',0.4,'EdgeColor','none','FaceColor',[0.3010 0.7450 0.9330])
    surf(ax3,[0,0;0,0],[2,-2;2,-2],[10,10;-10,-10],'FaceAlpha',0.4,'EdgeColor','none','FaceColor','y')
    %光线s分量
    [P(1,1),P(2,1),P(3,1)]=creat_p(ax3,[r;cnone;cnone],[r;cnone;cnone],[r;cnone;cnone],{'--',0.8,1});
    %光线p分量
    [P(1,2),P(2,2),P(3,2)]=creat_p(ax3,[r;cnone;cnone],[r;cnone;cnone],[r;cnone;cnone],{'--',0.8,2});
    %光线合矢量
    [P(1,3),P(2,3),P(3,3)]=creat_p(ax3,[r;cnone;cnone],[r;cnone;cnone],[r;cnone;cnone],{'-',1.2,3});
    %波矢所在直线
    P(1,4)=line(ax3,[0 r(end)],[0 0],[0 0],'Color','k','LineWidth',0.5);
    P(2,4)=copyobj(P(1,4),ax3); %复制对象
    P(3,4)=copyobj(P(1,4),ax3);
    linkprop(P(3,:),{'Visible'}); %链接折射光图像的visible属性
    %P是一个图形句柄矩阵，第一行保存入射光的图形句柄，第二行保存反射光的图形句柄，第三行保存折射光的图形句柄
    %P的第一列对应s分量，第二列对应p分量，第三列对应合成量，第四列对应波矢所在基准线
    % P储存句柄:
    % 入射光s 入射光p 入射光 入射光波矢
    % 反射光s 反射光p 反射光 反射光波矢
    % 折射光s 折射光p 折射光 折射光波矢
    
    axis(ax3,'equal'); grid(ax3,'on'); hold(ax3,'off')

    main1(0,0); main2(0,0); %调用main1、main2初始化
    %% 设置控件的回调
    fig1.CloseRequestFcn=@close_figure_func;
    timer1.TimerFcn={@timer_func,@update_coords};
    bt1.ValueChangedFcn=@button_func1;
    bt2.ButtonPushedFcn={@button_func2,@main2};
    bt3.ButtonPushedFcn={@(~,~,ax) set(ax,'View',[0 0]),ax3};
    bt4.ButtonPushedFcn={@(~,~,ax) set(ax,'View',[0 90]),ax3};
    bt5.ButtonPushedFcn={@(~,~,ax) set(ax,'View',[-90 0]),ax3};
    slider_n1.ValueChangedFcn={@value_changed_func1,@main1,@main2};
    slider_n2.ValueChangedFcn={@value_changed_func1,@main1,@main2};
    slider_Es0.ValueChangedFcn={@value_changed_func2,@main2};
    slider_Ep0.ValueChangedFcn={@value_changed_func2,@main2};
    slider_i1.ValueChangedFcn={@value_changed_func2,@main2};
    slider_k1.ValueChangedFcn={@value_changed_func2,@main2};
    slider_w.ValueChangedFcn={@value_changed_func2,@main2};
    start(timer1);
    %%
    function main1(~,~) %更新左上坐标区
        n1=slider_n1.Value; n2=slider_n2.Value; n21=n2/n1;
        if n21>1
            i=0:0.01:90;
        else
            i=0:0.01:asin(n21)*180/pi;
        end
        i1=i*pi/180;
        
        %计算不同角度下的参数
        rss=(cos(i1)-sqrt(n21^2-sin(i1).^2))./(cos(i1)+sqrt(n21^2-sin(i1).^2));
        tss=(2*cos(i1))./(cos(i1)+sqrt(n21^2-sin(i1).^2));
        rps=(n21^2*cos(i1)-sqrt(n21^2-sin(i1).^2))./(n21^2*cos(i1)+sqrt(n21^2-sin(i1).^2));
        tps=(2*n21*cos(i1))./(n21^2*cos(i1)+sqrt(n21^2-sin(i1).^2));
        Rs=rss.^2; Rp=rps.^2; Js=1-Rs; Jp=1-Rp; R=(Rs+Rp)/2; J=(Js+Jp)/2;
        %更新振幅比（全反射下|r|为1，图中未作出）
        set(p_ax1s(2:end),'XData',i);
        set(p_ax1s(2),'YData',rss');
        set(p_ax1s(3),'YData',tss');
        set(p_ax1s(4),'YData',rps');
        set(p_ax1s(5),'YData',tps');
        %更新能流透射率和能流反射率（全反射下R为1，图中未作出）
        set(p_ax2s(2:end),'XData',i);
        set(p_ax2s(2),'YData',Rs');
        set(p_ax2s(3),'YData',Js');
        set(p_ax2s(4),'YData',Rp');
        set(p_ax2s(5),'YData',Jp');
        set(p_ax2s(6),'YData',R');
        set(p_ax2s(7),'YData',J');
    end

    function main2(~,~)
        Es0=slider_Es0.Value; Ep0=slider_Ep0.Value; %r和p分量振幅
        k1=slider_k1.Value; w=slider_w.Value; %角频率
        k2=n21*k1; %介质2中的空间角频率
        in_angle=slider_i1.Value; %入射角
        %更新左上坐标区表征入射角大小的虚线的位置
        set(p_ax1s(1),{'XData','YData'},{[in_angle*180/pi in_angle*180/pi],ax1.YLim}); 
        set(p_ax2s(1),{'XData','YData'},{[in_angle*180/pi in_angle*180/pi],ax2.YLim}); 
        coords=[5;0;0;5;0;0]; %coords是存储坐标的矩阵，这里储存基准线端点坐标，暂且只初始化入射光和反射光的波矢
        RMs=zeros(6); %构造一个准对角阵，对角线上储存旋转矩阵
        RMs(1:3,1:3)=RM(-in_angle-pi/2); %入射光的旋转矩阵
        RMs(4:6,4:6)=RM(in_angle-pi/2); %反射光的旋转矩阵

        if n21<1 && in_angle>=asin(n21) %全反射情况
            l_num=2; set(P(3,1),'Visible','off'); %设置折射光线不可见
            coords=RMs*coords; %对坐标进行旋转操作
            x_left=coords(1,1)-0.5; x_right=coords(4,1)+0.5; %x轴坐标区范围
            z_top=coords(3,1)+0.5; z_bottom=-0.5; %z轴坐标区范围
            %更新波矢直线
            set(P(1,4),{'XData','YData','ZData'},{[0 coords(1)],[0 coords(2)],[0 coords(3)]})
            set(P(2,4),{'XData','YData','ZData'},{[0 coords(4)],[0 coords(5)],[0 coords(6)]})
        else
            l_num=3; set(P(3,1),'Visible','on');
            ref_angle=asin(sin(in_angle)/n21); %折射角
            RMs(7:9,7:9)=RM(-ref_angle+pi/2);
            coords(7:9,1)=[5;0;0];
            coords=RMs*coords;
            x_left=coords(1,1)-0.5; x_right=coords(4,1)+0.5;
            z_top=coords(3,1)+0.5; z_bottom=coords(end,1)-0.5;
            set(P(1,4),{'XData','YData','ZData'},{[0 coords(1)],[0 coords(2)],[0 coords(3)]})
            set(P(2,4),{'XData','YData','ZData'},{[0 coords(4)],[0 coords(5)],[0 coords(6)]})
            set(P(3,4),{'XData','YData','ZData'},{[0 coords(7)],[0 coords(8)],[0 coords(9)]})
        end

        set(ax3,{'XLim','YLim','ZLim'},{[x_left,x_right],[-2,2],[z_bottom,z_top]})
        %%
        delta=n21^2-sin(in_angle)^2; % δ=n21²-sin²(i_in) 
        if delta>0 %不处于全反射状态时
            rs=(cos(in_angle)-sqrt(delta))/(cos(in_angle)+sqrt(delta));
            ts=(2*cos(in_angle))/(cos(in_angle)+sqrt(delta));
            rp=(n21^2*cos(in_angle)-sqrt(delta))/(n21^2*cos(in_angle)+sqrt(delta));
            tp=(2*n21*cos(in_angle))/(n21^2*cos(in_angle)+sqrt(delta));
            delta_s=0; %未处于全反射状态时相移通过rs、rp的正负体现，故此处二者置为零
            delta_p=0;
        else
            delta=-delta;
            rs=(cos(in_angle)-1i*sqrt(delta))/(cos(in_angle)+1i*sqrt(delta));
            ts=NaN;
            rp=(n21^2*cos(in_angle)-1i*sqrt(delta))/(n21^2*cos(in_angle)+1i*sqrt(delta));
            tp=NaN;
            %全反射状态下反射光的相移等于rs、rp的幅角，振幅比等于rs、rp的模
            delta_s=angle(rs);
            rs=abs(rs);
            delta_p=angle(rp);
            rp=abs(rp);
        end
        
        tb1.Data=[rs,ts,rs.^2,n21.*ts.^2,rs.^2,1-rs.^2
                  rp,tp,rp.^2,n21.*tp.^2,rp.^2,1-rp.^2]; %更新table数据
    end

    function timer_func(~,~,update_coords)
        t=t+1;
        if l_num==3
            %三道光线初始化于x轴，再绕y轴旋转到指定位置
            %以下关系由边界条件、规定正向、光线相对原点为入射或出射得到，旋转前均假定电场强度相对自身光线指向正向
            new_Esin=-Es0*cos(k1*r+w*t);
            new_Epin=-Ep0*cos(k1*r+w*t);
            new_Esout1=-Es0*cos(k1*r-w*t);
            new_Epout1=Ep0*cos(k1*r-w*t);
            new_Esout2=-Es0*cos(k2*r-w*t);
            new_Epout2=Ep0*cos(k2*r-w*t);
            coords=[[r;new_Esin;cnone],[r;cnone;new_Epin],[r;new_Esin;new_Epin]
                [r;rs*new_Esout1;cnone],[r;cnone;rp*new_Epout1],[r;rs*new_Esout1;rp*new_Epout1]
                [r;ts*new_Esout2;cnone],[r;cnone;tp*new_Epout2],[r;ts*new_Esout2;tp*new_Epout2]];
            %每三行是一条光线的所有成分的x,y,z坐标，1:node_num列为s分量，node_num+1:2*node_num列为p分量...
            update_coords(RMs*coords);
        else
            new_Esin=-Es0*cos(k1*r+w*t);
            new_Epin=-Ep0*cos(k1*r+w*t);
            new_Esout1=-Es0*cos(k1*r-w*t+delta_s);
            new_Epout=Ep0*cos(k1*r-w*t+delta_p);
            coords=[[r;new_Esin;cnone],[r;cnone;new_Epin],[r;new_Esin;new_Epin]
                [r;rs*new_Esout1;cnone],[r;cnone;rp*new_Epout],[r;rs*new_Esout1;rp*new_Epout]];
            update_coords(RMs*coords);
        end
    end

    function [pE1,pE2,pE3]=creat_p(ax,in_coords,out_coords1,out_coords2,prop_cell) %用于创建三条光线的图形句柄
        pE1=p_handle(ax,in_coords); %入射光
        pE2=p_handle(ax,out_coords1); %反射光
        pE3=p_handle(ax,out_coords2); %折射光
        linkprop([pE1,pE2,pE3],{'LineStyle','LineWidth','SeriesIndex'}); %链接部分属性
        set(pE1,{'LineStyle','LineWidth','SeriesIndex'},prop_cell);
    end

    function update_coords(coords)
        for i=1:l_num
           for j=1:3
               set(P(i,j),{'XData','YData','ZData'},{coords(3*i-2,node_num*(j-1)+1:node_num*j),...
                   coords(3*i-1,node_num*(j-1)+1:node_num*j),coords(3*i,node_num*(j-1)+1:node_num*j)})
           end
        end
    end

    function close_figure_func(~,~) %关闭图窗时必须手动清除timer，matlab并不会主动清除
        stop(timer1);
        delete(timer1);
        delete(fig1);
    end

    function button_func1(~,~)
        if bt1.Value==1 && strcmp(timer1.Running,'off') %防止连续点击或卡顿时出错，仅在timer运行状态为off时启动timer
            start(timer1);
        elseif bt1.Value==0 && strcmp(timer1.Running,'on')
            stop(timer1);
        end
    end

    function button_func2(~,~,main2)
        slider_i1.Value=atan(n21); %布儒斯特角大小
        main2(0,0);
        if bt1.Value==0 && strcmp(timer1.Running,'off')
            start(timer1);
            bt1.Value=1;
        end
    end   

    function value_changed_func1(~,~,main1,main2) %对所有坐标区都进行更新
        main1(0,0);
        main2(0,0);
        timer_func(0,0,@update_coords); %调用一次timer_func更新光线
    end

    function value_changed_func2(~,~,main2) %仅更新右侧坐标区
        main2(0,0);
        timer_func(0,0,@update_coords);
    end
end