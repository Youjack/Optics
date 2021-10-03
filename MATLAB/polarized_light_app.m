classdef polarized_light_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PolarizedLightAppUIFigure   matlab.ui.Figure
        deltaAEditField             matlab.ui.control.NumericEditField
        thickofplateEditField       matlab.ui.control.NumericEditField
        rateofdotsamountSpinner     matlab.ui.control.Spinner
        updateaxesButton            matlab.ui.control.Button
        intervalofvectorsEditField  matlab.ui.control.NumericEditField
        rateofchangingEditField     matlab.ui.control.NumericEditField
        lengthofareaEditField       matlab.ui.control.NumericEditField
        positionofplateEditField    matlab.ui.control.NumericEditField
        startButton                 matlab.ui.control.Button
        pauseButton_2               matlab.ui.control.Button
        showvectorsCheckBox         matlab.ui.control.CheckBox
        showcomponentCheckBox       matlab.ui.control.CheckBox
        HTML                        matlab.ui.control.HTML
        Slider                      matlab.ui.control.Slider
        changecolorDropDown         matlab.ui.control.DropDown
        RSliderLabel                matlab.ui.control.Label
        RSlider                     matlab.ui.control.Slider
        GSliderLabel                matlab.ui.control.Label
        GSlider                     matlab.ui.control.Slider
        BSliderLabel                matlab.ui.control.Label
        BSlider                     matlab.ui.control.Slider
        RField                      matlab.ui.control.NumericEditField
        BField                      matlab.ui.control.NumericEditField
        GField                      matlab.ui.control.NumericEditField
        ColorLabel                  matlab.ui.control.Label
        ChangeColorButton           matlab.ui.control.Button
        hideButton                  matlab.ui.control.Button
        lengthofxEditField          matlab.ui.control.Spinner
        lengthofyEditField          matlab.ui.control.Spinner
        messageEditField            matlab.ui.control.EditField
        IknowButton                 matlab.ui.control.Button
        goodLabel                   matlab.ui.control.Label
        HTML2                       matlab.ui.control.HTML
        HTML3                       matlab.ui.control.HTML
        HTML3_2                     matlab.ui.control.HTML
        HTML3_3                     matlab.ui.control.HTML
        HTML3_4                     matlab.ui.control.HTML
        HTML3_5                     matlab.ui.control.HTML
        HTML3_6                     matlab.ui.control.HTML
        HTML3_7                     matlab.ui.control.HTML
        HTML3_8                     matlab.ui.control.HTML
        HTML3_9                     matlab.ui.control.HTML
        HTML3_10                    matlab.ui.control.HTML
        EditField                   matlab.ui.control.NumericEditField
        HTML3_12                    matlab.ui.control.HTML
        EditField_2                 matlab.ui.control.EditField
        HTML3_13                    matlab.ui.control.HTML
        azimuthSliderLabel          matlab.ui.control.Label
        azimuthSlider               matlab.ui.control.Slider
        elevationSliderLabel        matlab.ui.control.Label
        elevationSlider             matlab.ui.control.Slider
        UIAxes                      matlab.ui.control.UIAxes
    end

    properties (Access = private)
        t
        deltaA
        deltaC
        vd
        px
        pz
        ps
        px1
        pz1
        ps1
        pxm
        pzm
        psm
        psm1
        Vx
        Vz
        Vs
        lx
        ly
        ra
        num
        num1
        pxmx
        pxmy
        pzmz
        ptimer
        showvectors
        showcom
        xcolor=[0 0.4470 0.7410]
        zcolor=[0.8500 0.3250 0.0980]
        scolor=[0.9290 0.6940 0.1250]
    end
    
    methods (Access = private)
        function ptimerFcn(app,~,~) %timer调用的timerFcn，用于更新图像
            t1=app.ra*app.t;t2=app.lx*cos(-t1);t3=app.ly*cos(-t1+app.deltaA); %t1是t时刻的角度大小，t2是t时刻x轴方向向量对应的x轴坐标，t3是z轴方向向量对应的z轴坐标
                
            t31=app.ra*(app.t-app.num1);
            if t31>0
                t4=app.ly*cos(-t31+app.deltaA+app.deltaC); %t4是经过玻片后z轴方向向量对应的z轴坐标
            else 
                t4=0;
            end
            
            %更新xz平面上的图像
            app.px.XData=[0 t2];
            app.pz.ZData=[0 t3];
            app.ps.XData=[0 t2]; app.ps.ZData=[0 t3];
            app.px1.XData=[0 app.pxmx(app.num1)];
            app.pz1.ZData=[0 t4];
            app.ps1.XData=[0 app.pxmx(app.num1)]; app.ps1.ZData=[0 t4];
            
            %更新移动的波的图像
            app.pxmx=[t2 app.pxmx(1,1:end-1)];
            app.pzmz=[t3 app.pzmz(1,1:app.num1-1) t4 app.pzmz(1,app.num1+1:end-1)]; 
            pxmx1=app.pxmx(1,app.num1+1:end);
            pzmz1=app.pzmz(1,app.num1+1:end);
            if app.showcom %判断是否显示分量
                app.pxm.XData=app.pxmx;
                app.pzm.ZData=app.pzmz;
                if app.showvectors %判断是否显示向量
                    for i=1:app.vd:app.num
                        app.Vx(i).XData(2)=app.pxmx(i);
                        app.Vz(i).ZData(2)=app.pzmz(i);
                    end
                end
            end
            app.psm.XData=app.pxmx(1,1:app.num1); app.psm.ZData=app.pzmz(1,1:app.num1);
            app.psm1.XData=pxmx1; app.psm1.ZData=pzmz1;
            
            if app.showvectors
                %更新在基准轴上分布的向量的图像
                for i=1:app.vd:app.num
                   app.Vs(i).XData(2)=app.pxmx(i); app.Vs(i).ZData(2)=app.pzmz(i);
                end
            end
            
            app.t=app.t+1;
        end
        
        function updateAx(app) %更新坐标区
            app.t=1; stop(app.ptimer); %当在未停止timer时更新坐标区，切记停止timer，否则命令行会一直报错，只有退出程序才能解决的那种
            app.showvectors=0; app.showvectorsCheckBox.Value=0;
            app.showcom=1; app.showcomponentCheckBox.Value=1;
            app.lx=app.lengthofxEditField.Value; app.ly=app.lengthofyEditField.Value; %初始时x方向和y方向光矢量的长度
            app.deltaA=pi*app.deltaAEditField.Value; %初始x和y方向的相位差（实际在这里是x和z方向）
            thick=app.thickofplateEditField.Value; %玻片的类型
            app.deltaC=2*pi*thick; %玻片引起的相位差
            xmin=-app.lx-1; xmax=app.lx+1; %坐标轴范围
            ymin=-app.lengthofareaEditField.Value; ymax=0;
            zmin=-app.ly-1; zmax=app.ly+1;
            app.vd=app.intervalofvectorsEditField.Value; %显示向量的数据间隔，每隔12个点显示一个向量
            app.ra=app.rateofchangingEditField.Value; %每一个时间单位长度对应角度变化大小
            Q=app.rateofdotsamountSpinner.Value; %设置显示点的倍数，或者说一个周期长度缩减至原来的1/Q倍
            app.num=floor(Q*(0-ymin)/app.ra)+1; %在坐标轴范围内点的个数
            yb=-app.positionofplateEditField.Value; %玻片所处位置
            app.num1=ceil(app.num*yb/ymin); %玻片所处位置对应点个数
            app.pxmy=(0:-app.ra/Q:ymin); %每一个对应点的y坐标
            app.pxmx=zeros(1,app.num); app.pzmz=app.pxmx; %玻片前方的图像坐标
            %pxmx1=zeros(1,app.num-app.num1); %pzmz1=pxmx1; %玻片后方的图像坐标
            
            app.px=plot3(app.UIAxes,[0 0],[0 0],[0 0],'LineWidth',1.5,'Color',app.xcolor); app.px.Color(4)=0.7; hold(app.UIAxes,'on')
            app.pz=plot3(app.UIAxes,[0 0],[0 0],[0 0],'LineWidth',1.5,'Color',app.zcolor); app.pz.Color(4)=0.7;
            app.ps=plot3(app.UIAxes,[0 0],[0 0],[0 0],'LineWidth',1.5,'Color',app.scolor);
            app.px1=plot3(app.UIAxes,[0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',app.xcolor); app.px1.Color(4)=0.7;
            app.pz1=plot3(app.UIAxes,[0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',app.zcolor); app.pz1.Color(4)=0.7;
            app.ps1=plot3(app.UIAxes,[0 0],[yb yb],[0 0],'LineWidth',1.5,'Color',app.scolor);
            plot3(app.UIAxes,[0 0],[0 yb],[0 0],'.','MarkerSize',15,'Color',[0 0 0]);
            line(app.UIAxes,[-app.lx 0 0 -app.lx 0;app.lx 0 0 app.lx 0],[0 0 0 yb yb;0 0 ymin yb yb],[0 -app.ly 0 0 -app.ly;0 app.ly 0 0 app.ly],'LineStyle','--','Color',[0.4,0.4,0.4]);
            
            %移动的波的图像
            app.pxm=plot3(app.UIAxes,zeros(1,app.num),app.pxmy,zeros(1,app.num),'--','LineWidth',1,'Color',app.xcolor);app.pxm.Color(4)=0.5;
            app.pzm=plot3(app.UIAxes,zeros(1,app.num),app.pxmy,zeros(1,app.num),'--','LineWidth',1,'Color',app.zcolor);app.pzm.Color(4)=0.5;
            app.psm=plot3(app.UIAxes,zeros(1,app.num1),app.pxmy(1,1:app.num1),zeros(1,app.num1),'LineWidth',1.5,'Color',app.scolor);
            app.psm1=plot3(app.UIAxes,zeros(1,app.num-app.num1),app.pxmy(1,app.num1+1:end),zeros(1,app.num-app.num1),'LineWidth',1.5,'Color',app.scolor);
            
            %跟随波移动而做周期运动的一些向量
            app.Vx=line(app.UIAxes,zeros(2,app.num),[app.pxmy;app.pxmy],zeros(2,app.num),'LineStyle','-.','Color',app.xcolor,'LineWidth',0.3);
            app.Vz=line(app.UIAxes,zeros(2,app.num),[app.pxmy;app.pxmy],zeros(2,app.num),'LineStyle','-.','Color',app.zcolor,'LineWidth',0.3);
            app.Vs=line(app.UIAxes,zeros(2,app.num),[app.pxmy;app.pxmy],zeros(2,app.num),'LineStyle','-.','Color',app.scolor,'LineWidth',0.8);
            
            %玻片的图像
            [X,Z]=meshgrid([xmin+0.5,xmax-0.5],[zmin+0.5,zmax-0.5]);
            Y = X.^0*yb;
            surf(app.UIAxes,X,Y,Z,'FaceAlpha',0.1)
            
            %图像的一些属性的设置
            app.UIAxes.DataAspectRatio=[1 1 1];
            app.UIAxes.XGrid='on'; app.UIAxes.YGrid='on'; app.UIAxes.ZGrid='on';
            app.UIAxes.XLim=[xmin xmax]; app.UIAxes.YLim=[ymin ymax]; app.UIAxes.ZLim=[zmin zmax];
            app.UIAxes.XLabel=[]; app.UIAxes.XTick=(xmin:0.5:xmax); app.UIAxes.XTickLabel=[];
            app.UIAxes.YLabel=[]; app.UIAxes.YTick=(ymin:0.5:ymax); app.UIAxes.YTickLabel=[];
            app.UIAxes.ZLabel=[]; app.UIAxes.ZTick=(zmin:0.5:zmax); app.UIAxes.ZTickLabel=[];
            hold(app.UIAxes,'off')
            app.azimuthSlider.Value=app.UIAxes.View(1); app.elevationSlider.Value=app.UIAxes.View(2);
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.ptimer = timer(...
                'ExecutionMode', 'fixedRate', ...    % 执行模式为立即执行
                'Period', 0.1, ...                     % TimerFcn执行的间隔，大于0.001。如果值太小matlab很可能陷入不响应任何操作的状态，只能在任务管理器中清除进程。
                'BusyMode', 'queue',...              % 忙碌模式
                'TimerFcn', @app.ptimerFcn);      % 计时器回调函数
            app.updateAx;
        end

        % Button pushed function: updateaxesButton
        function updateaxesButtonPushed(app, event)
            app.updateAx;
        end

        % Button pushed function: startButton
        function startButtonPushed(app, event)
            if strcmp(app.ptimer.Running, 'off')
               start(app.ptimer); %开始调用timer对象更新图像
            end
        end

        % Button pushed function: pauseButton_2
        function pauseButton_2Pushed(app, event)
            stop(app.ptimer); %停止调用timer
        end

        % Value changed function: showvectorsCheckBox
        function showvectorsCheckBoxValueChanged(app, event)
            %是否显示向量
            if app.showvectorsCheckBox.Value
                app.showvectors=1;
                set(app.Vs,'Visible','on');
                if app.showcom
                    set(app.Vx,'Visible','on');
                    set(app.Vz,'Visible','on');
                end
            else
                app.showvectors=0;
                set(app.Vx,'Visible','off');
                set(app.Vz,'Visible','off');
                set(app.Vs,'Visible','off');
            end
        end

        % Close request function: PolarizedLightAppUIFigure
        function PolarizedLightAppUIFigureCloseRequest(app, event)
            % 关闭图窗时执行的命令。如果在退出app时没有停止timer的话会在命令行一直报错！
            stop(app.ptimer);
            delete(app.ptimer);
            delete(app);
        end

        % Value changed function: showcomponentCheckBox
        function showcomponentCheckBoxValueChanged(app, event)
            %判断是否显示分量
            if app.showcomponentCheckBox.Value
                app.showcom=1;
                set(app.pxm,'Visible','on');
                set(app.pzm,'Visible','on');
                if app.showvectors
                    set(app.Vx,'Visible','on');
                    set(app.Vz,'Visible','on');
                end
            else
                app.showcom=0;
                set(app.Vx,'Visible','off');
                set(app.Vz,'Visible','off');
                set(app.pxm,'Visible','off');
                set(app.pzm,'Visible','off');
            end
        end

        % Value changed function: rateofdotsamountSpinner
        function rateofdotsamountSpinnerValueChanged(app, event)
            if app.rateofdotsamountSpinner.Value<=0
                app.rateofdotsamountSpinner.Value=1;
            end       
        end

        % Value changed function: Slider
        function SliderValueChanged(app, event)
            app.ra=app.Slider.Value;
        end

        % Value changing function: Slider
        function SliderValueChanging(app, event)
            app.rateofchangingEditField.Value = event.Value;
        end

        % Drop down opening function: changecolorDropDown
        function changecolorDropDownOpening(app, event)
            %下放选项栏时显示以下控件
            app.RSlider.Visible='on'; app.RSliderLabel.Visible = 'on'; app.RField.Visible='on';
            app.GSlider.Visible='on'; app.GSliderLabel.Visible = 'on'; app.GField.Visible='on';
            app.BSlider.Visible='on'; app.BSliderLabel.Visible = 'on'; app.BField.Visible='on';
            app.ColorLabel.Visible='on'; app.ChangeColorButton.Visible='on'; app.hideButton.Visible='on';
        end

        % Value changing function: RSlider
        function RSliderValueChanging(app, event)
            %更新关联控件状态
            R=event.Value;
            app.RField.Value=R;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.RField.FontColor=[app.RField.Value 0 0];
        end

        % Value changing function: GSlider
        function GSliderValueChanging(app, event)
            G=event.Value;
            app.GField.Value=G;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.GField.FontColor=[0 app.GField.Value 0];
        end

        % Value changing function: BSlider
        function BSliderValueChanging(app, event)
            B=event.Value;
            app.BField.Value=B;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.BField.FontColor=[0 0 app.BField.Value];
        end

        % Button pushed function: hideButton
        function hideButtonPushed(app, event)
            %隐藏指定控件
            app.RSlider.Visible='off'; app.RSliderLabel.Visible = 'off'; app.RField.Visible='off';
            app.GSlider.Visible='off'; app.GSliderLabel.Visible = 'off'; app.GField.Visible='off';
            app.BSlider.Visible='off'; app.BSliderLabel.Visible = 'off'; app.BField.Visible='off';
            app.ColorLabel.Visible='off'; app.ChangeColorButton.Visible='off'; app.hideButton.Visible='off';
        end

        % Button pushed function: ChangeColorButton
        function ChangeColorButtonPushed(app, event)
            %指定对象改变颜色
            if strcmp(app.changecolorDropDown.Value,'X vector')
                app.xcolor=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.px,'Color',app.xcolor);
                set(app.px1,'Color',app.xcolor);
                set(app.pxm,'Color',app.xcolor);
                set(app.Vx,'Color',app.xcolor);
            elseif strcmp(app.changecolorDropDown.Value,'Y vector')
                app.zcolor=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.pz,'Color',app.zcolor);
                set(app.pz1,'Color',app.zcolor);
                set(app.pzm,'Color',app.zcolor);
                set(app.Vz,'Color',app.zcolor);
            else
                app.scolor=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.ps,'Color',app.scolor);
                set(app.ps1,'Color',app.scolor);
                set(app.psm,'Color',app.scolor);
                set(app.psm1,'Color',app.scolor);
                set(app.Vs,'Color',app.scolor);
            end
        end

        % Value changed function: changecolorDropDown
        function changecolorDropDownValueChanged(app, event)
            %DropDown选定对象改变时更改关联控件状态
            if strcmp(app.changecolorDropDown.Value,'X vector')
                app.RField.Value=app.xcolor(1); app.GField.Value=app.xcolor(2); app.BField.Value=app.xcolor(3);
                app.RSlider.Value=app.xcolor(1); app.GSlider.Value=app.xcolor(2); app.BSlider.Value=app.xcolor(3);
            elseif strcmp(app.changecolorDropDown.Value,'Y vector')
                app.RField.Value=app.zcolor(1); app.GField.Value=app.zcolor(2); app.BField.Value=app.zcolor(3);
                app.RSlider.Value=app.zcolor(1); app.GSlider.Value=app.zcolor(2); app.BSlider.Value=app.zcolor(3);
            else
                app.RField.Value=app.scolor(1); app.GField.Value=app.scolor(2); app.BField.Value=app.scolor(3);
                app.RSlider.Value=app.scolor(1); app.GSlider.Value=app.scolor(2); app.BSlider.Value=app.scolor(3);
            end
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.RField.FontColor=[app.RField.Value 0 0]; app.GField.FontColor=[0 app.GField.Value 0]; app.BField.FontColor=[0 0 app.BField.Value];
        end

        % Button pushed function: IknowButton
        function IknowButtonPushed(app, event)
            %没事干，于是整了点活...
            app.IknowButton.Visible='off';
            app.messageEditField.Visible='off';
            app.goodLabel.Visible='on';
            ii=75;
            for i=1:ii
                app.goodLabel.Position=[903,480+i,97,59];
                app.goodLabel.FontColor=[1-(1-0.57)*i/ii,0.84*i/ii,0.85*i/ii];
                pause(0.02);
            end
            app.goodLabel.Visible='off';
        end

        % Value changing function: azimuthSlider
        function azimuthSliderValueChanging(app, event)
            %更改视角
            app.UIAxes.View(1)=event.Value;
        end

        % Value changing function: elevationSlider
        function elevationSliderValueChanging(app, event)
            app.UIAxes.View(2)=event.Value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PolarizedLightAppUIFigure and hide until all components are created
            app.PolarizedLightAppUIFigure = uifigure('Visible', 'off');
            app.PolarizedLightAppUIFigure.Color = [0.5686 0.8392 0.851];
            app.PolarizedLightAppUIFigure.Position = [100 100 1078 653];
            app.PolarizedLightAppUIFigure.Name = 'Polarized Light App';
            app.PolarizedLightAppUIFigure.CloseRequestFcn = createCallbackFcn(app, @PolarizedLightAppUIFigureCloseRequest, true);
            app.PolarizedLightAppUIFigure.Pointer = 'hand';

            % Create deltaAEditField
            app.deltaAEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.deltaAEditField.ValueDisplayFormat = '%.4f';
            app.deltaAEditField.FontName = 'Times New Roman';
            app.deltaAEditField.FontSize = 15;
            app.deltaAEditField.FontColor = [0 0.451 0.7412];
            app.deltaAEditField.Position = [147 474 76 22];
            app.deltaAEditField.Value = 1.2;

            % Create thickofplateEditField
            app.thickofplateEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.thickofplateEditField.FontName = 'Times New Roman';
            app.thickofplateEditField.FontSize = 15;
            app.thickofplateEditField.FontColor = [0 0.4471 0.7412];
            app.thickofplateEditField.Position = [148 439 75 22];
            app.thickofplateEditField.Value = -0.25;

            % Create rateofdotsamountSpinner
            app.rateofdotsamountSpinner = uispinner(app.PolarizedLightAppUIFigure);
            app.rateofdotsamountSpinner.Step = 0.5;
            app.rateofdotsamountSpinner.ValueChangedFcn = createCallbackFcn(app, @rateofdotsamountSpinnerValueChanged, true);
            app.rateofdotsamountSpinner.FontName = 'Times New Roman';
            app.rateofdotsamountSpinner.FontSize = 15;
            app.rateofdotsamountSpinner.FontColor = [0 0.4471 0.7412];
            app.rateofdotsamountSpinner.Position = [149 324 100 22];
            app.rateofdotsamountSpinner.Value = 1.5;

            % Create updateaxesButton
            app.updateaxesButton = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.updateaxesButton.ButtonPushedFcn = createCallbackFcn(app, @updateaxesButtonPushed, true);
            app.updateaxesButton.BackgroundColor = [1 1 1];
            app.updateaxesButton.FontAngle = 'italic';
            app.updateaxesButton.FontColor = [1 0.4118 0.1608];
            app.updateaxesButton.Position = [423 71 100 22];
            app.updateaxesButton.Text = 'update axes';

            % Create intervalofvectorsEditField
            app.intervalofvectorsEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.intervalofvectorsEditField.FontName = 'Times New Roman';
            app.intervalofvectorsEditField.FontSize = 15;
            app.intervalofvectorsEditField.FontColor = [0 0.4471 0.7412];
            app.intervalofvectorsEditField.Position = [149 401 100 22];
            app.intervalofvectorsEditField.Value = 12;

            % Create rateofchangingEditField
            app.rateofchangingEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.rateofchangingEditField.ValueDisplayFormat = '%.4f';
            app.rateofchangingEditField.FontName = 'Times New Roman';
            app.rateofchangingEditField.FontSize = 15;
            app.rateofchangingEditField.FontColor = [0 0.4471 0.7412];
            app.rateofchangingEditField.Position = [148 364 100 22];
            app.rateofchangingEditField.Value = 0.05;

            % Create lengthofareaEditField
            app.lengthofareaEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.lengthofareaEditField.FontName = 'Times New Roman';
            app.lengthofareaEditField.FontSize = 15;
            app.lengthofareaEditField.FontColor = [0 0.4471 0.7412];
            app.lengthofareaEditField.Position = [147 289 100 22];
            app.lengthofareaEditField.Value = 10;

            % Create positionofplateEditField
            app.positionofplateEditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.positionofplateEditField.FontName = 'Times New Roman';
            app.positionofplateEditField.FontSize = 15;
            app.positionofplateEditField.FontColor = [0 0.4471 0.7412];
            app.positionofplateEditField.Position = [148 254 100 22];
            app.positionofplateEditField.Value = 5;

            % Create startButton
            app.startButton = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.startButton.ButtonPushedFcn = createCallbackFcn(app, @startButtonPushed, true);
            app.startButton.BackgroundColor = [1 1 1];
            app.startButton.FontAngle = 'italic';
            app.startButton.FontColor = [1 0.4118 0.1608];
            app.startButton.Position = [634 71 100 22];
            app.startButton.Text = 'start';

            % Create pauseButton_2
            app.pauseButton_2 = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.pauseButton_2.ButtonPushedFcn = createCallbackFcn(app, @pauseButton_2Pushed, true);
            app.pauseButton_2.BackgroundColor = [1 1 1];
            app.pauseButton_2.FontAngle = 'italic';
            app.pauseButton_2.FontColor = [1 0.4118 0.1608];
            app.pauseButton_2.Position = [847 71 100 22];
            app.pauseButton_2.Text = 'pause';

            % Create showvectorsCheckBox
            app.showvectorsCheckBox = uicheckbox(app.PolarizedLightAppUIFigure);
            app.showvectorsCheckBox.ValueChangedFcn = createCallbackFcn(app, @showvectorsCheckBoxValueChanged, true);
            app.showvectorsCheckBox.Text = 'show vectors';
            app.showvectorsCheckBox.Position = [742 32 92 22];

            % Create showcomponentCheckBox
            app.showcomponentCheckBox = uicheckbox(app.PolarizedLightAppUIFigure);
            app.showcomponentCheckBox.ValueChangedFcn = createCallbackFcn(app, @showcomponentCheckBoxValueChanged, true);
            app.showcomponentCheckBox.Text = 'show component';
            app.showcomponentCheckBox.Position = [522 32 113 22];
            app.showcomponentCheckBox.Value = true;

            % Create HTML
            app.HTML = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML.HTMLSource = '<h1>Polarized Light App</h1>';
            app.HTML.Position = [17 577 367 64];

            % Create Slider
            app.Slider = uislider(app.PolarizedLightAppUIFigure);
            app.Slider.Limits = [0.01 0.1];
            app.Slider.MajorTicks = [];
            app.Slider.MajorTickLabels = {''};
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.ValueChangingFcn = createCallbackFcn(app, @SliderValueChanging, true);
            app.Slider.MinorTicks = [];
            app.Slider.Position = [152 355 99 3];
            app.Slider.Value = 0.05;

            % Create changecolorDropDown
            app.changecolorDropDown = uidropdown(app.PolarizedLightAppUIFigure);
            app.changecolorDropDown.Items = {'X vector', 'Y vector', 'Sum Vector'};
            app.changecolorDropDown.DropDownOpeningFcn = createCallbackFcn(app, @changecolorDropDownOpening, true);
            app.changecolorDropDown.ValueChangedFcn = createCallbackFcn(app, @changecolorDropDownValueChanged, true);
            app.changecolorDropDown.FontName = 'Times New Roman';
            app.changecolorDropDown.FontSize = 15;
            app.changecolorDropDown.FontColor = [0 0.4471 0.7412];
            app.changecolorDropDown.Position = [145 221 103 22];
            app.changecolorDropDown.Value = 'X vector';

            % Create RSliderLabel
            app.RSliderLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.RSliderLabel.HorizontalAlignment = 'right';
            app.RSliderLabel.FontName = 'Times New Roman';
            app.RSliderLabel.FontSize = 17;
            app.RSliderLabel.FontColor = [1 0 0];
            app.RSliderLabel.Visible = 'off';
            app.RSliderLabel.Position = [8 174 25 22];
            app.RSliderLabel.Text = 'R';

            % Create RSlider
            app.RSlider = uislider(app.PolarizedLightAppUIFigure);
            app.RSlider.Limits = [0 1];
            app.RSlider.MajorTicks = [];
            app.RSlider.ValueChangingFcn = createCallbackFcn(app, @RSliderValueChanging, true);
            app.RSlider.MinorTicks = [];
            app.RSlider.Visible = 'off';
            app.RSlider.FontName = 'Times New Roman';
            app.RSlider.FontSize = 17;
            app.RSlider.FontColor = [1 0 0];
            app.RSlider.Position = [54 183 105 3];

            % Create GSliderLabel
            app.GSliderLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.GSliderLabel.HorizontalAlignment = 'right';
            app.GSliderLabel.FontName = 'Times New Roman';
            app.GSliderLabel.FontSize = 17;
            app.GSliderLabel.FontColor = [0 1 0];
            app.GSliderLabel.Visible = 'off';
            app.GSliderLabel.Position = [8 144 25 22];
            app.GSliderLabel.Text = 'G';

            % Create GSlider
            app.GSlider = uislider(app.PolarizedLightAppUIFigure);
            app.GSlider.Limits = [0 1];
            app.GSlider.MajorTicks = [];
            app.GSlider.ValueChangingFcn = createCallbackFcn(app, @GSliderValueChanging, true);
            app.GSlider.MinorTicks = [];
            app.GSlider.Visible = 'off';
            app.GSlider.FontName = 'Times New Roman';
            app.GSlider.FontSize = 17;
            app.GSlider.Position = [54 153 105 3];
            app.GSlider.Value = 0.447;

            % Create BSliderLabel
            app.BSliderLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.BSliderLabel.HorizontalAlignment = 'right';
            app.BSliderLabel.FontName = 'Times New Roman';
            app.BSliderLabel.FontSize = 17;
            app.BSliderLabel.FontColor = [0 0 1];
            app.BSliderLabel.Visible = 'off';
            app.BSliderLabel.Position = [7 115 25 22];
            app.BSliderLabel.Text = 'B';

            % Create BSlider
            app.BSlider = uislider(app.PolarizedLightAppUIFigure);
            app.BSlider.Limits = [0 1];
            app.BSlider.MajorTicks = [];
            app.BSlider.ValueChangingFcn = createCallbackFcn(app, @BSliderValueChanging, true);
            app.BSlider.MinorTicks = [];
            app.BSlider.Visible = 'off';
            app.BSlider.FontName = 'Times New Roman';
            app.BSlider.FontSize = 17;
            app.BSlider.FontColor = [0 0 1];
            app.BSlider.Position = [53 124 106 3];
            app.BSlider.Value = 0.741;

            % Create RField
            app.RField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.RField.ValueDisplayFormat = '%.4f';
            app.RField.FontWeight = 'bold';
            app.RField.Visible = 'off';
            app.RField.Position = [170 174 53 22];

            % Create BField
            app.BField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.BField.ValueDisplayFormat = '%.4f';
            app.BField.FontWeight = 'bold';
            app.BField.FontColor = [0 0 0.7412];
            app.BField.Visible = 'off';
            app.BField.Position = [170 115 53 22];
            app.BField.Value = 0.741;

            % Create GField
            app.GField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.GField.ValueDisplayFormat = '%.4f';
            app.GField.FontWeight = 'bold';
            app.GField.FontColor = [0 0.4471 0];
            app.GField.Visible = 'off';
            app.GField.Position = [170 143 53 22];
            app.GField.Value = 0.447;

            % Create ColorLabel
            app.ColorLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.ColorLabel.BackgroundColor = [0 0.4471 0.7412];
            app.ColorLabel.HorizontalAlignment = 'center';
            app.ColorLabel.FontSize = 15;
            app.ColorLabel.FontColor = [1 1 1];
            app.ColorLabel.Visible = 'off';
            app.ColorLabel.Position = [236 123 63 62];
            app.ColorLabel.Text = 'Color';

            % Create ChangeColorButton
            app.ChangeColorButton = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.ChangeColorButton.ButtonPushedFcn = createCallbackFcn(app, @ChangeColorButtonPushed, true);
            app.ChangeColorButton.BackgroundColor = [1 1 1];
            app.ChangeColorButton.FontWeight = 'bold';
            app.ChangeColorButton.FontColor = [0 0.4471 0.7412];
            app.ChangeColorButton.Visible = 'off';
            app.ChangeColorButton.Position = [41 71 100 22];
            app.ChangeColorButton.Text = 'Change Color';

            % Create hideButton
            app.hideButton = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.hideButton.ButtonPushedFcn = createCallbackFcn(app, @hideButtonPushed, true);
            app.hideButton.BackgroundColor = [1 1 1];
            app.hideButton.FontWeight = 'bold';
            app.hideButton.Visible = 'off';
            app.hideButton.Position = [185 71 100 22];
            app.hideButton.Text = 'hide';

            % Create lengthofxEditField
            app.lengthofxEditField = uispinner(app.PolarizedLightAppUIFigure);
            app.lengthofxEditField.Limits = [1 Inf];
            app.lengthofxEditField.FontName = 'Times New Roman';
            app.lengthofxEditField.FontSize = 15;
            app.lengthofxEditField.FontColor = [0 0.451 0.7412];
            app.lengthofxEditField.Position = [147 548 100 22];
            app.lengthofxEditField.Value = 1;

            % Create lengthofyEditField
            app.lengthofyEditField = uispinner(app.PolarizedLightAppUIFigure);
            app.lengthofyEditField.Limits = [1 Inf];
            app.lengthofyEditField.FontName = 'Times New Roman';
            app.lengthofyEditField.FontSize = 15;
            app.lengthofyEditField.FontColor = [0 0.4471 0.7412];
            app.lengthofyEditField.Position = [147 511 100 22];
            app.lengthofyEditField.Value = 1;

            % Create messageEditField
            app.messageEditField = uieditfield(app.PolarizedLightAppUIFigure, 'text');
            app.messageEditField.Editable = 'off';
            app.messageEditField.Position = [350 619 673 22];
            app.messageEditField.Value = '温馨提示：如果将某些参数调整过大会导致同屏出现的元素过多进而导致程序卡顿、响应操作时间变长，因此请合理设置参数';

            % Create IknowButton
            app.IknowButton = uibutton(app.PolarizedLightAppUIFigure, 'push');
            app.IknowButton.ButtonPushedFcn = createCallbackFcn(app, @IknowButtonPushed, true);
            app.IknowButton.Position = [946 590 76 23];
            app.IknowButton.Text = '我知道了';

            % Create goodLabel
            app.goodLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.goodLabel.FontName = '幼圆';
            app.goodLabel.FontSize = 30;
            app.goodLabel.FontWeight = 'bold';
            app.goodLabel.FontColor = [1 0 0];
            app.goodLabel.Visible = 'off';
            app.goodLabel.Position = [903 521 97 59];
            app.goodLabel.Text = '真棒!';

            % Create HTML2
            app.HTML2 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML2.HTMLSource = '<head><style>div:hover {color:#4DBEEE}</style></head><body><div style="line-height:12px;font-size:1px;"><small>版权所有&copy 知乎--多说无益 </small></div><body>';
            app.HTML2.Position = [930 1 149 23];

            % Create HTML3
            app.HTML3 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="x方向向量的长度" style="text-decoration:none">length of x</a></body>';
            app.HTML3.Position = [66 544 93 24];

            % Create HTML3_2
            app.HTML3_2 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_2.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="y方向向量的长度" style="text-decoration:none">length of y</a></body>';
            app.HTML3_2.Position = [66 512 93 21];

            % Create HTML3_3
            app.HTML3_3 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_3.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="初始时y和x方向的相位差" style="text-decoration:none">&delta;A</a></body>';
            app.HTML3_3.Position = [113 475 49 20];

            % Create HTML3_4
            app.HTML3_4 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_4.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="波片的类型" style="text-decoration:none">type of plate</a></body>';
            app.HTML3_4.Position = [56 440 103 20];

            % Create HTML3_5
            app.HTML3_5 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_5.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="每隔n个点显示一个向量" style="text-decoration:none">interval of vectors</a></body>';
            app.HTML3_5.Position = [20 402 145 20];

            % Create HTML3_6
            app.HTML3_6 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_6.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="每一个时间单位变化的角度大小" style="text-decoration:none">rate of changing</a></body>';
            app.HTML3_6.Position = [32 357 162 24];

            % Create HTML3_7
            app.HTML3_7 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_7.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="同屏点的倍数，对应周期长度缩减至原来的1/n倍" style="text-decoration:none">rate of dots'' amount</a></body>';
            app.HTML3_7.Position = [10 324 149 23];

            % Create HTML3_8
            app.HTML3_8 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_8.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="坐标区的长度" style="text-decoration:none">length of area</a></body>';
            app.HTML3_8.Position = [49 290 113 20];

            % Create HTML3_9
            app.HTML3_9 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_9.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="波片的位置" style="text-decoration:none">position of plate</a></body>';
            app.HTML3_9.Position = [32 256 130 18];

            % Create HTML3_10
            app.HTML3_10 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_10.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; background-color:#FFFFB2;}</style></head><body><a href="#" title="改变线条颜色" style="text-decoration:none">change color</a></body>';
            app.HTML3_10.Position = [53 223 100 19];

            % Create EditField
            app.EditField = uieditfield(app.PolarizedLightAppUIFigure, 'numeric');
            app.EditField.Position = [222 474 22 22];

            % Create HTML3_12
            app.HTML3_12 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_12.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#0073BD; background-color:#FFFFFF; font-size:17px;}</style></head><body><p>&pi;</p></body>';
            app.HTML3_12.Position = [221 452 18 43];

            % Create EditField_2
            app.EditField_2 = uieditfield(app.PolarizedLightAppUIFigure, 'text');
            app.EditField_2.Position = [221 439 23 22];

            % Create HTML3_13
            app.HTML3_13 = uihtml(app.PolarizedLightAppUIFigure);
            app.HTML3_13.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#0073BD; background-color:#FFFFFF; font-size:17px;}</style></head><body><p>&lambda;</p></body>';
            app.HTML3_13.Position = [221 417 18 43];

            % Create azimuthSliderLabel
            app.azimuthSliderLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.azimuthSliderLabel.HorizontalAlignment = 'right';
            app.azimuthSliderLabel.FontName = 'Times New Roman';
            app.azimuthSliderLabel.FontSize = 15;
            app.azimuthSliderLabel.FontColor = [0.4706 0.1137 0.1137];
            app.azimuthSliderLabel.Position = [953 394 58 22];
            app.azimuthSliderLabel.Text = 'azimuth ';

            % Create azimuthSlider
            app.azimuthSlider = uislider(app.PolarizedLightAppUIFigure);
            app.azimuthSlider.Limits = [-180 180];
            app.azimuthSlider.Orientation = 'vertical';
            app.azimuthSlider.ValueChangingFcn = createCallbackFcn(app, @azimuthSliderValueChanging, true);
            app.azimuthSlider.FontName = 'Times New Roman';
            app.azimuthSlider.FontSize = 10;
            app.azimuthSlider.FontColor = [0.4706 0.1137 0.1137];
            app.azimuthSlider.Position = [958 423 3 150];

            % Create elevationSliderLabel
            app.elevationSliderLabel = uilabel(app.PolarizedLightAppUIFigure);
            app.elevationSliderLabel.HorizontalAlignment = 'right';
            app.elevationSliderLabel.FontName = 'Times New Roman';
            app.elevationSliderLabel.FontSize = 15;
            app.elevationSliderLabel.FontColor = [0.4706 0.1098 0.1098];
            app.elevationSliderLabel.Position = [1010 394 60 22];
            app.elevationSliderLabel.Text = 'elevation';

            % Create elevationSlider
            app.elevationSlider = uislider(app.PolarizedLightAppUIFigure);
            app.elevationSlider.Limits = [-90 90];
            app.elevationSlider.Orientation = 'vertical';
            app.elevationSlider.ValueChangingFcn = createCallbackFcn(app, @elevationSliderValueChanging, true);
            app.elevationSlider.FontName = 'Times New Roman';
            app.elevationSlider.FontSize = 10;
            app.elevationSlider.FontColor = [0.4706 0.1098 0.1098];
            app.elevationSlider.Position = [1016 424 3 150];

            % Create UIAxes
            app.UIAxes = uiaxes(app.PolarizedLightAppUIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.TickLength = [0 0];
            app.UIAxes.Position = [285 112 751 489];

            % Show the figure after all components are created
            app.PolarizedLightAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = polarized_light_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PolarizedLightAppUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PolarizedLightAppUIFigure)
        end
    end
end