%% 夫琅禾费衍射:非连通孔径
% 光强：
% 
% $$I_{\theta}=I_0(\frac{\sin{\alpha}}{\alpha})^2(\frac{\sin{N\gamma}}{\sin{\gamma}})^2$$
% 
% 包络线：
% 
% $$I_{\theta}=I_0(N\frac{\sin{\alpha}}{\alpha})^2$$
% 
% 其中：
% 
% $$\alpha=\frac{\pi}{\lambda}a\sin{\theta}$$
% 
% $$\gamma=\frac{\pi}{\lambda}d\sin{\theta}$$
% 
% a为缝宽，d为缝间距，$\theta$为衍射角，N为缝数目

%fdna(光波长(nm),缝宽(μm),缝间距(μm),缝数目,是否显示包络线)
lambda=440;
a=0.99;
d=2.39;
N=6;
flag=true;
%%
if d<a
    d=3*a;
end
dp(fdna(lambda,a,d,N,flag));
%% 
% fdna()函数计算光强分布

function intensity=fdna(lambda,a,d,N,flag)
%% 
% 创建坐标区，获取句柄

    fig1=figure("Color","w");
    ax1=axes(fig1);
    hold(ax1,'on');
%% 
% 将各项参数转换为标准单位制下的长度

    lambda=lambda*1e-9;
    a=a*1e-6;
    d=d*1e-6;
%% 
% 确定作图区间，划分作图区间计算每个节点的光强值

    span=linspace(-1,1,2000);
    alpha=pi*a*span/lambda; 
    gamma=pi*d*span/lambda;
    env=(sin(alpha)./alpha).^2; 
    intensity=env.*(sin(N*gamma)./sin(gamma)).^2; %光强
    env=env*N^2; %包络线
%% 
% 绘制光强和包络线

    plot(ax1,span,intensity,'Color',[0.8500 0.3250 0.0980]);
    plot(ax1,span,env,'LineWidth',1.2,'Color',[0 0.4470 0.7410],'Visible',flag); %通过Visible属性控制是否显示包络线
    hold(ax1,"off");
%% 
% 坐标区设置

    xlabel('$\sin{\theta}$',"Interpreter","latex","FontSize",18)
    ylabel('$I_{\theta}$',"Interpreter","latex","FontSize",18)
    title('夫琅禾费衍射：多连通孔径',"FontSize",15)
end
%% 
% dp()函数绘制衍射图样

function dp(intensity)
    fig2=figure("Color","w");
    ax2=axes(fig2);
    imagesc(ax2,intensity); %根据光强值大小显示颜色
    g=gray;
    g=g(60:end,:); %截取gray的一部分
    colormap(g); %设置数值-颜色映射方式（越大颜色越白）
    ax2.XTick=[];ax2.YTick=[]; %清除刻度线
    ax2.XTickLabel=[];ax2.YTickLabel=[]; %清除刻度标签
    ax2.OuterPosition=[0,0.85,1,0.15]; %调整坐标区大小和位置
end