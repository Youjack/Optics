classdef waves_superposition_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        changecolorDropDown          matlab.ui.control.DropDown
        RField                       matlab.ui.control.NumericEditField
        BField                       matlab.ui.control.NumericEditField
        GField                       matlab.ui.control.NumericEditField
        ColorLabel                   matlab.ui.control.Label
        ChangeColorButton            matlab.ui.control.Button
        HTML3                        matlab.ui.control.HTML
        RSliderLabel                 matlab.ui.control.Label
        RSlider                      matlab.ui.control.Slider
        GSliderLabel                 matlab.ui.control.Label
        GSlider                      matlab.ui.control.Slider
        BSliderLabel                 matlab.ui.control.Label
        BSlider                      matlab.ui.control.Slider
        HTML4                        matlab.ui.control.HTML
        w1EditField                  matlab.ui.control.NumericEditField
        HTML5                        matlab.ui.control.HTML
        k1EditField                  matlab.ui.control.NumericEditField
        w2EditField                  matlab.ui.control.NumericEditField
        k2EditField                  matlab.ui.control.NumericEditField
        HTML5_2                      matlab.ui.control.HTML
        HTML5_4                      matlab.ui.control.HTML
        HTML5_5                      matlab.ui.control.HTML
        HTML5_7                      matlab.ui.control.HTML
        delta0EditField              matlab.ui.control.NumericEditField
        onoffButton                  matlab.ui.control.StateButton
        Slider                       matlab.ui.control.Slider
        Slider_2                     matlab.ui.control.Slider
        Slider_3                     matlab.ui.control.Slider
        Slider_4                     matlab.ui.control.Slider
        Slider_5                     matlab.ui.control.Slider
        numberofperiodsSpinnerLabel  matlab.ui.control.Label
        numberofperiodsSpinner       matlab.ui.control.Spinner
        Slider_6                     matlab.ui.control.Slider
        Slider_7                     matlab.ui.control.Slider
        ckLabel                      matlab.ui.control.Label
        cwLabel                      matlab.ui.control.Label
        D2DButton                    matlab.ui.control.StateButton
        Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel  matlab.ui.control.Label
        E1Axes                       matlab.ui.control.UIAxes
        E2Axes                       matlab.ui.control.UIAxes
        E3Axes                       matlab.ui.control.UIAxes
        EtAxes                       matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        t=0
        x
        s
        num=5
        p1
        p2
        p3
        p11
        p21
        p31
        ptimer
        tk
        e1color=[0 0.4470 0.7410]
        e2color=[0.4660 0.6740 0.1880]
        e3color=[0.8500 0.3250 0.0980]
        etcolor=[0 0 0]
    end
    
    methods (Access = private)
        
        function ptimerFcn(app,~,~)
            y1=sin(app.k1EditField.Value*app.x-app.w1EditField.Value*app.t);
            y2=sin(app.k2EditField.Value*app.x-app.w2EditField.Value*app.t+app.delta0EditField.Value);
            y3=y1+y2;
            set(app.p1,'Ydata',y1); set(app.p11,'Ydata',y1(1));
            set(app.p2,'Ydata',y2); set(app.p21,'Ydata',y2(1));
            set(app.p3,'Ydata',y3); set(app.p31,'Ydata',y3(1));
            if app.t+1<=100
                app.tk(app.t+1,:)=y3;
            else
                app.tk=[app.tk(2:100,:);y3]; 
            end
            if app.D2DButton.Value==1
                set(app.s,'ZData',app.tk)
            end
            app.t=app.t+1;
        end
        
        function changepic(app)
            app.x=linspace(0,app.num*2*pi,app.num*100);
            y1=sin(app.k1EditField.Value*app.x-app.w1EditField.Value*app.t);
            y2=sin(app.k2EditField.Value*app.x-app.w2EditField.Value*app.t+app.delta0EditField.Value);
            y3=y1+y2;
            set(app.p1,'Xdata',app.x)
            set(app.p2,'Xdata',app.x)
            set(app.p3,'Xdata',app.x)
            set(app.p1,'Ydata',y1); set(app.p11,'Ydata',y1(1));
            set(app.p2,'Ydata',y2); set(app.p21,'Ydata',y2(1));
            set(app.p3,'Ydata',y3); set(app.p31,'Ydata',y3(1));
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           app.tk=zeros(100,app.num*100);
            app.ptimer = timer(...
                'ExecutionMode', 'fixedRate', ...    
                'Period', 0.05, ...                     
                'BusyMode', 'queue',...              
                'TimerFcn', @app.ptimerFcn);      
            app.E1Axes.YLim=[-1 1];app.E2Axes.YLim=[-1 1];app.E3Axes.YLim=[-2 2];
            grid(app.E1Axes,"minor"); grid(app.E2Axes,"minor"); grid(app.E3Axes,"minor");
            app.EtAxes.XGrid='on'; app.EtAxes.YGrid='on'; app.EtAxes.ZGrid='on';
            app.x=linspace(0,app.num*2*pi,app.num*100);
            y1=sin(app.k1EditField.Value*app.x); y2=sin(app.k2EditField.Value*app.x+app.delta0EditField.Value);
            app.p1=plot(app.E1Axes,app.x,y1,'LineWidth',1.2); hold(app.E1Axes,'on'); 
            app.p11=plot(app.E1Axes,app.x(1),y1(1),'.','MarkerSize',15,"Color",[0.3 0.3 0.3]); hold(app.E1Axes,'off'); 
            app.p2=plot(app.E2Axes,app.x,y2,'LineWidth',1.2); hold(app.E2Axes,'on'); 
            app.p21=plot(app.E2Axes,app.x(1),y2(1),'.','MarkerSize',15,"Color",[0.3 0.3 0.3]); hold(app.E2Axes,'off'); 
            app.p3=plot(app.E3Axes,app.x,y1+y2,'LineWidth',1.2); hold(app.E3Axes,'on'); 
            app.p31=plot(app.E3Axes,app.x(1),y1(1)+y2(1),'.','MarkerSize',15,"Color",[0.3 0.3 0.3]); hold(app.E3Axes,'off'); 
            
            set(app.E1Axes,'XLim',[0 app.num*2*pi]); set(app.E2Axes,'XLim',[0 app.num*2*pi]); set(app.E3Axes,'XLim',[0 app.num*2*pi])
            set(app.EtAxes,'ZLim',[-2,2])
            set(app.p1,'Color',app.e1color); set(app.p2,'Color',app.e2color); set(app.p3,'Color',app.e3color)
        end

        % Value changed function: onoffButton
        function onoffButtonValueChanged(app, event)
            if app.onoffButton.Value
                start(app.ptimer)
            else
                stop(app.ptimer)
            end
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            stop(app.ptimer);
            delete(app.ptimer);
            delete(app)
        end

        % Value changing function: Slider
        function SliderValueChanging(app, event)
            app.k1EditField.Value=event.Value;
            app.changepic;
        end

        % Value changing function: Slider_2
        function Slider_2ValueChanging(app, event)
            app.w1EditField.Value=event.Value;
            app.changepic;
        end

        % Value changing function: Slider_3
        function Slider_3ValueChanging(app, event)
            app.k2EditField.Value=event.Value;
            app.changepic;
        end

        % Value changing function: Slider_4
        function Slider_4ValueChanging(app, event)
            app.w2EditField.Value=event.Value;
            app.changepic;
        end

        % Value changing function: Slider_5
        function Slider_5ValueChanging(app, event)
            app.delta0EditField.Value=event.Value;
            app.changepic;
        end

        % Value changed function: numberofperiodsSpinner
        function numberofperiodsSpinnerValueChanged(app, event)
            app.num=app.numberofperiodsSpinner.Value;
            app.tk=zeros(100,app.num*100);
            app.changepic;
            if app.D2DButton.Value==1
                app.s=mesh(app.EtAxes,app.x,diag((1:100))*ones(100,app.num*100),app.tk,'EdgeColor',app.etcolor);
            end
            set(app.E1Axes,'XLim',[0 app.num*2*pi])
            set(app.E2Axes,'XLim',[0 app.num*2*pi])
            set(app.E3Axes,'XLim',[0 app.num*2*pi])
        end

        % Value changed function: k1EditField
        function k1EditFieldValueChanged(app, event)
            app.Slider.Value=app.k1EditField.Value;
            app.changepic;
        end

        % Value changed function: k2EditField
        function k2EditFieldValueChanged(app, event)
            app.Slider_3.Value=app.k2EditField.Value;
            app.changepic;
        end

        % Value changed function: delta0EditField
        function delta0EditFieldValueChanged(app, event)
            app.Slider_5.Value=app.delta0EditField.Value;
            app.changepic;
        end

        % Value changed function: w1EditField
        function w1EditFieldValueChanged(app, event)
            app.Slider_2.Value=app.w1EditField.Value;
            app.changepic;
        end

        % Value changed function: w2EditField
        function w2EditFieldValueChanged(app, event)
            app.Slider_4.Value=app.w2EditField.Value;
            app.changepic;
        end

        % Value changing function: Slider_6
        function Slider_6ValueChanging(app, event)
            app.ckLabel.Visible='on';
            if abs(app.k1EditField.Value-event.Value)<=5
                app.k2EditField.Value=app.k1EditField.Value-event.Value;
                app.Slider_3.Value=app.k2EditField.Value;
                app.changepic;
            end
        end

        % Value changed function: Slider_6
        function Slider_6ValueChanged(app, event)
            app.ckLabel.Visible='off';
        end

        % Value changing function: Slider_7
        function Slider_7ValueChanging(app, event)
            app.cwLabel.Visible='on';
            if abs(app.w1EditField.Value-event.Value)<=0.2
                app.w2EditField.Value=app.w1EditField.Value-event.Value;
                app.Slider_4.Value=app.w2EditField.Value;
                app.changepic;
            end
        end

        % Value changed function: Slider_7
        function Slider_7ValueChanged(app, event)
            app.cwLabel.Visible='off';
        end

        % Value changed function: changecolorDropDown
        function changecolorDropDownValueChanged(app, event)
            if strcmp(app.changecolorDropDown.Value,'E1')
                app.RField.Value=app.e1color(1); app.GField.Value=app.e1color(2); app.BField.Value=app.e1color(3);
                app.RSlider.Value=app.e1color(1); app.GSlider.Value=app.e1color(2); app.BSlider.Value=app.e1color(3);
            elseif strcmp(app.changecolorDropDown.Value,'E2')
                app.RField.Value=app.e2color(1); app.GField.Value=app.e2color(2); app.BField.Value=app.e2color(3);
                app.RSlider.Value=app.e2color(1); app.GSlider.Value=app.e2color(2); app.BSlider.Value=app.e2color(3);
            elseif strcmp(app.changecolorDropDown.Value,'E3')
                app.RField.Value=app.e3color(1); app.GField.Value=app.e3color(2); app.BField.Value=app.e3color(3);
                app.RSlider.Value=app.e3color(1); app.GSlider.Value=app.e3color(2); app.BSlider.Value=app.e3color(3);
            else
                app.RField.Value=app.etcolor(1); app.GField.Value=app.etcolor(2); app.BField.Value=app.etcolor(3);
                app.RSlider.Value=app.etcolor(1); app.GSlider.Value=app.etcolor(2); app.BSlider.Value=app.etcolor(3);
            end
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.RField.FontColor=[app.RField.Value 0 0]; app.GField.FontColor=[0 app.GField.Value 0]; app.BField.FontColor=[0 0 app.BField.Value];
        end

        % Button pushed function: ChangeColorButton
        function ChangeColorButtonPushed(app, event)
            if strcmp(app.changecolorDropDown.Value,'E1')
                app.e1color=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.p1,'Color',app.e1color);
            elseif strcmp(app.changecolorDropDown.Value,'E2')
                app.e2color=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.p2,'Color',app.e2color);
            elseif strcmp(app.changecolorDropDown.Value,'E3')
                app.e3color=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.p3,'Color',app.e3color);
            else
                app.etcolor=[app.RField.Value app.GField.Value app.BField.Value];
                set(app.s,'EdgeColor',app.etcolor);
            end
        end

        % Value changing function: RSlider
        function RSliderValueChanging(app, event)
            app.RField.Value=event.Value;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.RField.FontColor=[app.RField.Value 0 0];
        end

        % Value changing function: GSlider
        function GSliderValueChanging(app, event)
            app.GField.Value=event.Value;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.GField.FontColor=[0 app.RField.Value 0];
        end

        % Value changing function: BSlider
        function BSliderValueChanging(app, event)
            app.BField.Value=event.Value;
            app.ColorLabel.BackgroundColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.ChangeColorButton.FontColor=[app.RField.Value app.GField.Value app.BField.Value];
            app.BField.FontColor=[0 0 app.RField.Value];
        end

        % Value changed function: D2DButton
        function D2DButtonValueChanged(app, event)
            if app.D2DButton.Value
                stop(app.ptimer);
                app.onoffButton.Value=0;
                app.E1Axes.Visible='off';
                app.E2Axes.Visible='off';
                app.E3Axes.Visible='off';
                app.p1.Visible='off';
                app.p2.Visible='off';
                app.p3.Visible='off';
                app.p11.Visible='off';
                app.p21.Visible='off';
                app.p31.Visible='off';
                app.EtAxes.Visible='on';
                app.s.Visible='on';
                app.s=mesh(app.EtAxes,app.x,diag((1:100))*ones(100,app.num*100),app.tk);
            else
                app.EtAxes.Visible='off';
                app.s.Visible='off';
                app.E1Axes.Visible='on';
                app.E2Axes.Visible='on';
                app.E3Axes.Visible='on';
                app.p1.Visible='on';
                app.p2.Visible='on';
                app.p3.Visible='on';
                app.p11.Visible='on';
                app.p21.Visible='on';
                app.p31.Visible='on';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Color = [0.7294 0.9294 0.851];
            app.UIFigure.Position = [100 100 1117 687];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create changecolorDropDown
            app.changecolorDropDown = uidropdown(app.UIFigure);
            app.changecolorDropDown.Items = {'E1', 'E2', 'E3', 'Et'};
            app.changecolorDropDown.ValueChangedFcn = createCallbackFcn(app, @changecolorDropDownValueChanged, true);
            app.changecolorDropDown.FontName = 'Times New Roman';
            app.changecolorDropDown.FontSize = 15;
            app.changecolorDropDown.FontColor = [0 0.4471 0.7412];
            app.changecolorDropDown.Position = [163 257 103 22];
            app.changecolorDropDown.Value = 'E1';

            % Create RField
            app.RField = uieditfield(app.UIFigure, 'numeric');
            app.RField.ValueDisplayFormat = '%.4f';
            app.RField.FontWeight = 'bold';
            app.RField.Position = [188 210 53 22];

            % Create BField
            app.BField = uieditfield(app.UIFigure, 'numeric');
            app.BField.ValueDisplayFormat = '%.4f';
            app.BField.FontWeight = 'bold';
            app.BField.FontColor = [0 0 0.7412];
            app.BField.Position = [188 151 53 22];
            app.BField.Value = 0.741;

            % Create GField
            app.GField = uieditfield(app.UIFigure, 'numeric');
            app.GField.ValueDisplayFormat = '%.4f';
            app.GField.FontWeight = 'bold';
            app.GField.FontColor = [0 0.4471 0];
            app.GField.Position = [188 179 53 22];
            app.GField.Value = 0.447;

            % Create ColorLabel
            app.ColorLabel = uilabel(app.UIFigure);
            app.ColorLabel.BackgroundColor = [0 0.4471 0.7412];
            app.ColorLabel.HorizontalAlignment = 'center';
            app.ColorLabel.FontSize = 15;
            app.ColorLabel.FontColor = [1 1 1];
            app.ColorLabel.Position = [254 159 63 62];
            app.ColorLabel.Text = 'Color';

            % Create ChangeColorButton
            app.ChangeColorButton = uibutton(app.UIFigure, 'push');
            app.ChangeColorButton.ButtonPushedFcn = createCallbackFcn(app, @ChangeColorButtonPushed, true);
            app.ChangeColorButton.BackgroundColor = [1 1 1];
            app.ChangeColorButton.FontWeight = 'bold';
            app.ChangeColorButton.FontColor = [0 0.4471 0.7412];
            app.ChangeColorButton.Position = [111 110 100 22];
            app.ChangeColorButton.Text = 'Change Color';

            % Create HTML3
            app.HTML3 = uihtml(app.UIFigure);
            app.HTML3.HTMLSource = '<style type="text/css">a {font-family:"Times New Roman",Times,serif; color:#3D2BCC; }</style></head><body><a href="#" title="改变线条颜色" style="text-decoration:none">change color</a></body>';
            app.HTML3.Position = [66 259 100 19];

            % Create RSliderLabel
            app.RSliderLabel = uilabel(app.UIFigure);
            app.RSliderLabel.HorizontalAlignment = 'right';
            app.RSliderLabel.FontName = 'Times New Roman';
            app.RSliderLabel.FontSize = 17;
            app.RSliderLabel.FontColor = [1 0 0];
            app.RSliderLabel.Position = [26 210 25 22];
            app.RSliderLabel.Text = 'R';

            % Create RSlider
            app.RSlider = uislider(app.UIFigure);
            app.RSlider.Limits = [0 1];
            app.RSlider.MajorTicks = [];
            app.RSlider.ValueChangingFcn = createCallbackFcn(app, @RSliderValueChanging, true);
            app.RSlider.MinorTicks = [];
            app.RSlider.FontName = 'Times New Roman';
            app.RSlider.FontSize = 17;
            app.RSlider.FontColor = [1 0 0];
            app.RSlider.Position = [72 219 105 3];

            % Create GSliderLabel
            app.GSliderLabel = uilabel(app.UIFigure);
            app.GSliderLabel.HorizontalAlignment = 'right';
            app.GSliderLabel.FontName = 'Times New Roman';
            app.GSliderLabel.FontSize = 17;
            app.GSliderLabel.FontColor = [0 1 0];
            app.GSliderLabel.Position = [26 180 25 22];
            app.GSliderLabel.Text = 'G';

            % Create GSlider
            app.GSlider = uislider(app.UIFigure);
            app.GSlider.Limits = [0 1];
            app.GSlider.MajorTicks = [];
            app.GSlider.ValueChangingFcn = createCallbackFcn(app, @GSliderValueChanging, true);
            app.GSlider.MinorTicks = [];
            app.GSlider.FontName = 'Times New Roman';
            app.GSlider.FontSize = 17;
            app.GSlider.Position = [72 189 105 3];
            app.GSlider.Value = 0.447;

            % Create BSliderLabel
            app.BSliderLabel = uilabel(app.UIFigure);
            app.BSliderLabel.HorizontalAlignment = 'right';
            app.BSliderLabel.FontName = 'Times New Roman';
            app.BSliderLabel.FontSize = 17;
            app.BSliderLabel.FontColor = [0 0 1];
            app.BSliderLabel.Position = [25 151 25 22];
            app.BSliderLabel.Text = 'B';

            % Create BSlider
            app.BSlider = uislider(app.UIFigure);
            app.BSlider.Limits = [0 1];
            app.BSlider.MajorTicks = [];
            app.BSlider.ValueChangingFcn = createCallbackFcn(app, @BSliderValueChanging, true);
            app.BSlider.MinorTicks = [];
            app.BSlider.FontName = 'Times New Roman';
            app.BSlider.FontSize = 17;
            app.BSlider.FontColor = [0 0 1];
            app.BSlider.Position = [71 160 106 3];
            app.BSlider.Value = 0.741;

            % Create HTML4
            app.HTML4 = uihtml(app.UIFigure);
            app.HTML4.HTMLSource = '<h1>Waves Superposition</h1>';
            app.HTML4.Position = [17 577 504 100];

            % Create w1EditField
            app.w1EditField = uieditfield(app.UIFigure, 'numeric');
            app.w1EditField.Limits = [-0.2 0.2];
            app.w1EditField.ValueDisplayFormat = '%.3f';
            app.w1EditField.ValueChangedFcn = createCallbackFcn(app, @w1EditFieldValueChanged, true);
            app.w1EditField.FontName = 'Times New Roman';
            app.w1EditField.FontSize = 18;
            app.w1EditField.FontColor = [0 0.4471 0.7412];
            app.w1EditField.Position = [223 521 100 30];
            app.w1EditField.Value = 0.05;

            % Create HTML5
            app.HTML5 = uihtml(app.UIFigure);
            app.HTML5.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#3D2BCC;  font-size:30px;}</style></head><body><p>&omega;<sub>1</sub></p></body>';
            app.HTML5.Position = [190 472 90 84];

            % Create k1EditField
            app.k1EditField = uieditfield(app.UIFigure, 'numeric');
            app.k1EditField.Limits = [-5 5];
            app.k1EditField.ValueDisplayFormat = '%.3f';
            app.k1EditField.ValueChangedFcn = createCallbackFcn(app, @k1EditFieldValueChanged, true);
            app.k1EditField.FontName = 'Times New Roman';
            app.k1EditField.FontSize = 18;
            app.k1EditField.FontColor = [0 0.4471 0.7412];
            app.k1EditField.Position = [39 521 100 30];
            app.k1EditField.Value = 1;

            % Create w2EditField
            app.w2EditField = uieditfield(app.UIFigure, 'numeric');
            app.w2EditField.Limits = [-0.2 0.2];
            app.w2EditField.ValueDisplayFormat = '%.3f';
            app.w2EditField.ValueChangedFcn = createCallbackFcn(app, @w2EditFieldValueChanged, true);
            app.w2EditField.FontName = 'Times New Roman';
            app.w2EditField.FontSize = 18;
            app.w2EditField.FontColor = [0 0.4471 0.7412];
            app.w2EditField.Position = [223 464 100 30];
            app.w2EditField.Value = -0.05;

            % Create k2EditField
            app.k2EditField = uieditfield(app.UIFigure, 'numeric');
            app.k2EditField.Limits = [-5 5];
            app.k2EditField.ValueDisplayFormat = '%.3f';
            app.k2EditField.ValueChangedFcn = createCallbackFcn(app, @k2EditFieldValueChanged, true);
            app.k2EditField.FontName = 'Times New Roman';
            app.k2EditField.FontSize = 18;
            app.k2EditField.FontColor = [0 0.4471 0.7412];
            app.k2EditField.Position = [39 464 100 30];
            app.k2EditField.Value = 1;

            % Create HTML5_2
            app.HTML5_2 = uihtml(app.UIFigure);
            app.HTML5_2.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#3D2BCC;  font-size:30px;}</style></head><body><p>&omega;<sub>2</sub></p></body>';
            app.HTML5_2.Position = [190 415 90 84];

            % Create HTML5_4
            app.HTML5_4 = uihtml(app.UIFigure);
            app.HTML5_4.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#3D2BCC;  font-size:30px;}</style></head><body><p>k<sub>2</sub></p></body>';
            app.HTML5_4.Position = [9 415 90 84];

            % Create HTML5_5
            app.HTML5_5 = uihtml(app.UIFigure);
            app.HTML5_5.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#3D2BCC;  font-size:30px;}</style></head><body><p>k<sub>1</sub></p></body>';
            app.HTML5_5.Position = [9 472 90 84];

            % Create HTML5_7
            app.HTML5_7 = uihtml(app.UIFigure);
            app.HTML5_7.HTMLSource = '<style type="text/css">p {font-family:"Times New Roman",Times,serif; color:#3D2BCC;  font-size:30px;}</style></head><body><p>&delta;<sub>0</sub></p></body>';
            app.HTML5_7.Position = [111 364 90 84];

            % Create delta0EditField
            app.delta0EditField = uieditfield(app.UIFigure, 'numeric');
            app.delta0EditField.Limits = [-6.28318530717959 6.28318530717959];
            app.delta0EditField.ValueDisplayFormat = '%.3f';
            app.delta0EditField.ValueChangedFcn = createCallbackFcn(app, @delta0EditFieldValueChanged, true);
            app.delta0EditField.FontName = 'Times New Roman';
            app.delta0EditField.FontSize = 18;
            app.delta0EditField.FontColor = [0 0.4471 0.7412];
            app.delta0EditField.Position = [141 407 100 30];
            app.delta0EditField.Value = 1.5708;

            % Create onoffButton
            app.onoffButton = uibutton(app.UIFigure, 'state');
            app.onoffButton.ValueChangedFcn = createCallbackFcn(app, @onoffButtonValueChanged, true);
            app.onoffButton.Text = 'on/off';
            app.onoffButton.BackgroundColor = [1 1 1];
            app.onoffButton.FontAngle = 'italic';
            app.onoffButton.FontColor = [1 0.4118 0.1608];
            app.onoffButton.Position = [702 15 100 22];

            % Create Slider
            app.Slider = uislider(app.UIFigure);
            app.Slider.Limits = [-5 5];
            app.Slider.MajorTicks = [];
            app.Slider.MajorTickLabels = {''};
            app.Slider.ValueChangingFcn = createCallbackFcn(app, @SliderValueChanging, true);
            app.Slider.MinorTicks = [];
            app.Slider.Position = [40 511 99 3];
            app.Slider.Value = 1;

            % Create Slider_2
            app.Slider_2 = uislider(app.UIFigure);
            app.Slider_2.Limits = [-0.2 0.2];
            app.Slider_2.MajorTicks = [];
            app.Slider_2.MajorTickLabels = {''};
            app.Slider_2.ValueChangingFcn = createCallbackFcn(app, @Slider_2ValueChanging, true);
            app.Slider_2.MinorTicks = [];
            app.Slider_2.Position = [223 511 99 3];
            app.Slider_2.Value = 0.05;

            % Create Slider_3
            app.Slider_3 = uislider(app.UIFigure);
            app.Slider_3.Limits = [-5 5];
            app.Slider_3.MajorTicks = [];
            app.Slider_3.MajorTickLabels = {''};
            app.Slider_3.ValueChangingFcn = createCallbackFcn(app, @Slider_3ValueChanging, true);
            app.Slider_3.MinorTicks = [];
            app.Slider_3.Position = [40 454 99 3];
            app.Slider_3.Value = 1;

            % Create Slider_4
            app.Slider_4 = uislider(app.UIFigure);
            app.Slider_4.Limits = [-0.2 0.2];
            app.Slider_4.MajorTicks = [];
            app.Slider_4.MajorTickLabels = {''};
            app.Slider_4.ValueChangingFcn = createCallbackFcn(app, @Slider_4ValueChanging, true);
            app.Slider_4.MinorTicks = [];
            app.Slider_4.Position = [223 454 99 3];
            app.Slider_4.Value = -0.05;

            % Create Slider_5
            app.Slider_5 = uislider(app.UIFigure);
            app.Slider_5.Limits = [-6.28318530717959 6.28318530717959];
            app.Slider_5.MajorTicks = [];
            app.Slider_5.MajorTickLabels = {''};
            app.Slider_5.ValueChangingFcn = createCallbackFcn(app, @Slider_5ValueChanging, true);
            app.Slider_5.MinorTicks = [];
            app.Slider_5.Position = [142 397 99 3];
            app.Slider_5.Value = 1.5707963267949;

            % Create numberofperiodsSpinnerLabel
            app.numberofperiodsSpinnerLabel = uilabel(app.UIFigure);
            app.numberofperiodsSpinnerLabel.HorizontalAlignment = 'right';
            app.numberofperiodsSpinnerLabel.FontName = 'Times New Roman';
            app.numberofperiodsSpinnerLabel.FontSize = 15;
            app.numberofperiodsSpinnerLabel.FontColor = [0.1686 0.1216 0.851];
            app.numberofperiodsSpinnerLabel.Position = [36 290 115 22];
            app.numberofperiodsSpinnerLabel.Text = 'number of periods';

            % Create numberofperiodsSpinner
            app.numberofperiodsSpinner = uispinner(app.UIFigure);
            app.numberofperiodsSpinner.Limits = [1 15];
            app.numberofperiodsSpinner.ValueChangedFcn = createCallbackFcn(app, @numberofperiodsSpinnerValueChanged, true);
            app.numberofperiodsSpinner.FontName = 'Times New Roman';
            app.numberofperiodsSpinner.FontSize = 15;
            app.numberofperiodsSpinner.FontColor = [0 0.4471 0.7412];
            app.numberofperiodsSpinner.Position = [166 290 100 22];
            app.numberofperiodsSpinner.Value = 5;

            % Create Slider_6
            app.Slider_6 = uislider(app.UIFigure);
            app.Slider_6.Limits = [-1 1];
            app.Slider_6.MajorTickLabels = {''};
            app.Slider_6.Orientation = 'vertical';
            app.Slider_6.ValueChangedFcn = createCallbackFcn(app, @Slider_6ValueChanged, true);
            app.Slider_6.ValueChangingFcn = createCallbackFcn(app, @Slider_6ValueChanging, true);
            app.Slider_6.MinorTicks = [];
            app.Slider_6.FontName = 'Times New Roman';
            app.Slider_6.FontSize = 10;
            app.Slider_6.Position = [146 456 3 92];

            % Create Slider_7
            app.Slider_7 = uislider(app.UIFigure);
            app.Slider_7.Limits = [-0.1 0.1];
            app.Slider_7.MajorTickLabels = {''};
            app.Slider_7.Orientation = 'vertical';
            app.Slider_7.ValueChangedFcn = createCallbackFcn(app, @Slider_7ValueChanged, true);
            app.Slider_7.ValueChangingFcn = createCallbackFcn(app, @Slider_7ValueChanging, true);
            app.Slider_7.MinorTicks = [];
            app.Slider_7.FontName = 'Times New Roman';
            app.Slider_7.FontSize = 10;
            app.Slider_7.Position = [331 456 3 92];

            % Create ckLabel
            app.ckLabel = uilabel(app.UIFigure);
            app.ckLabel.FontColor = [0.6784 0.4902 0.4902];
            app.ckLabel.Visible = 'off';
            app.ckLabel.Position = [107 556 179 22];
            app.ckLabel.Text = 'calibrate k1&k2 and adjust k1-k2';

            % Create cwLabel
            app.cwLabel = uilabel(app.UIFigure);
            app.cwLabel.FontColor = [0.6784 0.4902 0.4902];
            app.cwLabel.Visible = 'off';
            app.cwLabel.Position = [107 556 191 22];
            app.cwLabel.Text = 'calibrate w1&w2 and adjust w1-w2';

            % Create D2DButton
            app.D2DButton = uibutton(app.UIFigure, 'state');
            app.D2DButton.ValueChangedFcn = createCallbackFcn(app, @D2DButtonValueChanged, true);
            app.D2DButton.Text = '3D/2D';
            app.D2DButton.BackgroundColor = [1 1 1];
            app.D2DButton.Position = [111 15 100 22];

            % Create Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel
            app.Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel = uilabel(app.UIFigure);
            app.Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel.FontAngle = 'italic';
            app.Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel.FontColor = [0.302 0.7451 0.9333];
            app.Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel.Position = [223 12 205 27];
            app.Ifyouwanttocheckthe3DimagepleasereducethenumberofperiodsLabel.Text = {'If you want to check the 3D image, '; 'please reduce the number of periods.'};

            % Create E1Axes
            app.E1Axes = uiaxes(app.UIFigure);
            title(app.E1Axes, 'E1')
            zlabel(app.E1Axes, 'Z')
            app.E1Axes.FontName = 'Times New Roman';
            app.E1Axes.XTickLabel = '';
            app.E1Axes.YTick = [-1 0 1];
            app.E1Axes.FontSize = 12;
            app.E1Axes.Position = [354 448 756 197];

            % Create E2Axes
            app.E2Axes = uiaxes(app.UIFigure);
            title(app.E2Axes, 'E2')
            zlabel(app.E2Axes, 'Z')
            app.E2Axes.FontName = 'Times New Roman';
            app.E2Axes.XTickLabel = '';
            app.E2Axes.YTick = [-1 0 1];
            app.E2Axes.Position = [354 251 756 197];

            % Create E3Axes
            app.E3Axes = uiaxes(app.UIFigure);
            title(app.E3Axes, 'E3')
            zlabel(app.E3Axes, 'Z')
            app.E3Axes.FontName = 'Times New Roman';
            app.E3Axes.XTickLabel = '';
            app.E3Axes.YTick = [-2 0 2];
            app.E3Axes.YTickLabel = {'-2'; '0'; '2'};
            app.E3Axes.Position = [354 55 756 197];

            % Create EtAxes
            app.EtAxes = uiaxes(app.UIFigure);
            xlabel(app.EtAxes, 'x')
            ylabel(app.EtAxes, 't')
            zlabel(app.EtAxes, 'y')
            app.EtAxes.Visible = 'off';
            app.EtAxes.Position = [333 110 769 411];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = waves_superposition_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end