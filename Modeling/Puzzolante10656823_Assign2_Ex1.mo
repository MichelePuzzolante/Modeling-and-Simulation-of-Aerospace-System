within ;
package Puzzolante10656823_Assign2_Ex1
  model ThermalSystem
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor SC_Body(C=1.5e5, T(
        displayUnit="K",
        fixed=true,
        start=298.15))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              -100,80})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor SC_SolarPanel_R(C=
          1187.5, T(
        displayUnit="K",
        fixed=true,
        start=298.15))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              -180,80})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor SC_SolarPanel_L(C=
          1187.5, T(
        displayUnit="K",
        fixed=true,
        start=298.15))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              -260,80})));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qsun_SP_L(Q_flow=1350*0.5
          *0.95*0.78)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -304,42})));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qsun_SP_R(Q_flow=1350*0.5
          *0.95*0.78)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -220,42})));
    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Qsun_SC_Body(Q_flow=1350*
          0.5*0.5*0.6)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -142,42})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor G12(G=10)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -140,0})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor G13(G=10)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -140,-34})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor SC_Radiator_R(C=30, T(
        displayUnit="K",
        fixed=true,
        start=298.15))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              -180,-80})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor SC_Radiator_L(C=30, T(
        displayUnit="K",
        fixed=true,
        start=298.15))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              -260,-80})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor G14(G=10)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -138,-122})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor G15(G=10)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -138,-172})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TDS_SC_Body(T(
          displayUnit="K") = 3) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-46,40})));
    Modelica.Thermal.HeatTransfer.Components.BodyRadiation SC_Body_radiation(Gr=(
          2*0.5*0.5 + 2*1.5*0.5 + 2*0.5*1.49)*0.45)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -78,40})));
    Modelica.Thermal.HeatTransfer.Components.BodyRadiation SC_SP_R_radiation(Gr=(
          0.95*0.5 + 2*0.95*0.01 + 0.01*0.5)*0.75)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-200,0})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TDS_SC_SP_R(T(
          displayUnit="K") = 3) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-234,0})));
    Modelica.Thermal.HeatTransfer.Components.BodyRadiation SC_SP_L_radiation(Gr=(
          0.95*0.5 + 2*0.95*0.01 + 0.01*0.5)*0.75)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -278,-34})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TDS_SC_SP_L(T(
          displayUnit="K") = 3) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-324,-34})));
    Modelica.Thermal.HeatTransfer.Components.Convection SC_R_R_radiation
      annotation (Placement(transformation(
          origin={-208,-122},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    Modelica.Thermal.HeatTransfer.Components.Convection SC_R_L_radiation
      annotation (Placement(transformation(
          origin={-288,-172},
          extent={{-10,-10},{10,10}},
          rotation=180)));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TDS_SC_R_L(T(
          displayUnit="K") = 3) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-324,-172})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TDS_SC_R_R(T(
          displayUnit="K") = 3) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-240,-122})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T1_sensor
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              -20,12})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R=0.1) annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={272,-38})));
    Modelica.Electrical.Analog.Basic.Inductor inductor(i(start=0, fixed=true), L=
          0.001) annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={272,-98})));
    Modelica.Electrical.Analog.Basic.RotationalEMF emf(k=0.3) annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={338,-138})));
    Modelica.Electrical.Analog.Basic.Ground ground annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={158,58})));
    Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={272,20})));
    Modelica.Mechanics.Rotational.Components.Inertia RadiatorInertia(
      J=1/3*0.2*0.5*0.5,
      phi(
        start=-0.4*Modelica.Constants.pi,
        fixed=true,
        displayUnit="rad"),
      w(start=0, fixed=true))
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, origin={
              220,-246})));
    Radiation2Convection radiation2Convection annotation (Placement(
          transformation(
          extent={{-16,-15.5},{16,15.5}},
          rotation=180,
          origin={-178,-237.5})));
    Radiation2Convection radiation2Convection1 annotation (Placement(
          transformation(
          extent={{-16,-15.5},{16,15.5}},
          rotation=180,
          origin={-252,-291.5})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T4_sensor
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-188,-302})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T5_sensor
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-122,-246})));
    f_epsilon f_epsilon1 annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=180,
          origin={12,-246})));
    Modelica.Mechanics.Rotational.Sensors.AngleSensor theta_sensor annotation (
        Placement(transformation(
          origin={128,-246},
          extent={{-20,-20},{20,20}},
          rotation=180)));
    ControlBlock controlBlock annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={176,20})));
    Modelica.Blocks.Math.Gain kp(k=1.2e-4)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              104,36})));
    Modelica.Blocks.Math.Add add(k2=-1)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              64,36})));
    Modelica.Blocks.Sources.Constant T1_ref(k=294.15)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
              26,16})));
  Modelica.Blocks.Sources.Constant T1_ref2(k = 294.15) annotation (
      Placement(transformation(origin = {26, 16}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(Qsun_SP_L.port, SC_SolarPanel_L.port)
      annotation (Line(points={{-294,42},{-260,42},{-260,60}}, color={191,0,0}));
    connect(Qsun_SP_R.port, SC_SolarPanel_R.port)
      annotation (Line(points={{-210,42},{-180,42},{-180,60}}, color={191,0,0}));
    connect(Qsun_SC_Body.port, SC_Body.port)
      annotation (Line(points={{-132,42},{-100,42},{-100,60}}, color={191,0,0}));
    connect(G12.port_b, SC_Body.port)
      annotation (Line(points={{-130,0},{-100,0},{-100,60}}, color={191,0,0}));
    connect(G13.port_b, SC_Body.port) annotation (Line(points={{-130,-34},{-100,
            -34},{-100,60}}, color={191,0,0}));
    connect(G12.port_a, SC_SolarPanel_R.port)
      annotation (Line(points={{-150,0},{-180,0},{-180,60}}, color={191,0,0}));
    connect(G13.port_a, SC_SolarPanel_L.port) annotation (Line(points={{-150,-34},
            {-260,-34},{-260,60}}, color={191,0,0}));
    connect(G14.port_a, SC_Radiator_R.port) annotation (Line(points={{-148,-122},
            {-148,-124},{-180,-124},{-180,-100}},
                                      color={191,0,0}));
    connect(G15.port_a, SC_Radiator_L.port) annotation (Line(points={{-148,-172},
            {-260,-172},{-260,-100}}, color={191,0,0}));
    connect(G14.port_b, SC_Body.port) annotation (Line(points={{-128,-122},{
            -128,-124},{-100,-124},{-100,60}},
                              color={191,0,0}));
    connect(G15.port_b, SC_Body.port) annotation (Line(points={{-128,-172},{-100,
            -172},{-100,60}}, color={191,0,0}));
    connect(TDS_SC_Body.port, SC_Body_radiation.port_b)
      annotation (Line(points={{-56,40},{-68,40}}, color={191,0,0}));
    connect(SC_Body_radiation.port_a, SC_Body.port)
      annotation (Line(points={{-88,40},{-100,40},{-100,60}}, color={191,0,0}));
    connect(SC_SP_R_radiation.port_b, SC_SolarPanel_R.port)
      annotation (Line(points={{-190,0},{-180,0},{-180,60}}, color={191,0,0}));
    connect(SC_SP_R_radiation.port_a, TDS_SC_SP_R.port)
      annotation (Line(points={{-210,0},{-224,0}}, color={191,0,0}));
    connect(SC_SP_L_radiation.port_a, TDS_SC_SP_L.port)
      annotation (Line(points={{-288,-34},{-314,-34}}, color={191,0,0}));
    connect(SC_SP_L_radiation.port_b, SC_SolarPanel_L.port) annotation (Line(
          points={{-268,-34},{-268,-36},{-260,-36},{-260,60}},
                                                    color={191,0,0}));
    connect(SC_R_R_radiation.solid, SC_Radiator_R.port) annotation (Line(points={
            {-198,-122},{-180,-122},{-180,-100}}, color={191,0,0}));
    connect(SC_R_L_radiation.solid, SC_Radiator_L.port) annotation (Line(points={
            {-278,-172},{-260,-172},{-260,-100}}, color={191,0,0}));
    connect(TDS_SC_R_L.port, SC_R_L_radiation.fluid)
      annotation (Line(points={{-314,-172},{-298,-172}}, color={191,0,0}));
    connect(TDS_SC_R_R.port, SC_R_R_radiation.fluid)
      annotation (Line(points={{-230,-122},{-218,-122}}, color={191,0,0}));
    connect(T1_sensor.port, SC_Body.port)
      annotation (Line(points={{-30,12},{-100,12},{-100,60}}, color={191,0,0}));
    connect(ground.p, signalVoltage.n)
      annotation (Line(points={{178,58},{272,58},{272,40}}, color={0,0,255}));
    connect(RadiatorInertia.flange_b, emf.flange) annotation (Line(points={{240,
            -246},{240,-248},{338,-248},{338,-158}}, color={0,0,0}));
    connect(radiation2Convection.h_Rad, SC_R_R_radiation.Gc) annotation (Line(
          points={{-197.04,-237.345},{-208,-237.345},{-208,-132}}, color={0,0,127}));
    connect(radiation2Convection1.h_Rad, SC_R_L_radiation.Gc) annotation (Line(
          points={{-271.04,-291.345},{-288,-291.345},{-288,-182}}, color={0,0,127}));
    connect(T4_sensor.T, radiation2Convection1.T_Body) annotation (Line(points=
            {{-199,-302},{-199,-300.8},{-232.8,-300.8}}, color={0,0,127}));
    connect(T4_sensor.port, SC_Radiator_L.port) annotation (Line(points={{-178,
            -302},{-172,-302},{-172,-264},{-260,-264},{-260,-100}}, color={191,
            0,0}));
    connect(T5_sensor.T, radiation2Convection.T_Body) annotation (Line(points={
            {-133,-246},{-133,-246.8},{-158.8,-246.8}}, color={0,0,127}));
    connect(T5_sensor.port, SC_Radiator_R.port) annotation (Line(points={{-112,
            -246},{-112,-248},{-104,-248},{-104,-100},{-180,-100}}, color={191,
            0,0}));
    connect(f_epsilon1.eps, radiation2Convection.epsilon) annotation (Line(points={{-10,
            -246},{-28,-246},{-28,-226},{-100,-226},{-100,-225.1},{-158.8,
            -225.1}},                                              color={0,0,127}));
    connect(radiation2Convection1.epsilon, f_epsilon1.eps) annotation (Line(
          points={{-232.8,-279.1},{-28,-279.1},{-28,-246},{-10,-246}}, color={0,0,
            127}));
    connect(theta_sensor.flange, RadiatorInertia.flange_a)
      annotation (Line(points={{148,-246},{200,-246}}, color={0,0,0}));
    connect(f_epsilon1.theta, theta_sensor.phi)
      annotation (Line(points={{34,-246},{106,-246}}, color={0,0,127}));
    connect(controlBlock.Theta, theta_sensor.phi) annotation (Line(points={{152,6.4},
            {128,6.4},{128,-216},{96,-216},{96,-246},{106,-246}},
                                                     color={0,0,127}));
    connect(add.y, kp.u)
      annotation (Line(points={{75,36},{92,36}}, color={0,0,127}));
    connect(add.u1, T1_sensor.T) annotation (Line(points={{52,42},{4,42},{4,12},
            {-9,12}}, color={0,0,127}));
    connect(T1_ref.y, add.u2) annotation (Line(points={{37,16},{52,16},{52,30}},
                                      color={0,0,127}));
    connect(resistor.p, signalVoltage.p)
      annotation (Line(points={{272,-18},{272,0}},           color={0,0,255}));
    connect(inductor.p, resistor.n)
      annotation (Line(points={{272,-78},{272,-58}},           color={0,0,255}));
    connect(emf.p, inductor.n) annotation (Line(points={{358,-138},{364,-138},{
            364,-172},{272,-172},{272,-118}}, color={0,0,255}));
    connect(emf.n, signalVoltage.n) annotation (Line(points={{318,-138},{302,
            -138},{302,-72},{370,-72},{370,78},{272,78},{272,40}},
                                color={0,0,255}));
    connect(controlBlock.T1_sensor, T1_sensor.T) annotation (Line(points={{152,20},
            {124,20},{124,-12},{4,-12},{4,12},{-9,12}},
                                                    color={0,0,127}));
    connect(controlBlock.y, signalVoltage.v) annotation (Line(points={{199.8,
            19.8},{232,19.8},{232,20},{248,20}}, color={0,0,127}));
    connect(controlBlock.V_in, kp.y)
      annotation (Line(points={{152,36},{115,36}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(                           extent={{-340,-320},{400,
              120}}, preserveAspectRatio=false)),
      Diagram(coordinateSystem(                           extent={{-340,-320},{
              400,120}}, preserveAspectRatio=false), graphics={
          Text(
            extent={{172,14},{178,-36}},
            textColor={28,108,200},
            textString="ControlBlock
"),       Text(
            extent={{10,-200},{16,-250}},
            textColor={28,108,200},
            textString="Emissivity
"),       Text(
            extent={{-178,-196},{-172,-246}},
            textColor={28,108,200},
            textString="h_Rad_RR
"),       Text(
            extent={{-254,-250},{-248,-300}},
            textColor={28,108,200},
            textString="h_Rad_RR
")}));
  end ThermalSystem;

  block Radiation2Convection
    Modelica.Blocks.Interfaces.RealInput T_Body
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput epsilon
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Modelica.Blocks.Interfaces.RealOutput h_Rad annotation (Placement(
          transformation(extent={{100,-20},{138,18}}), iconTransformation(extent=
              {{100,-20},{138,18}})));
    Modelica.Blocks.Math.Gain sigma(k=5.67*1e-8)   annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},      rotation=0,     origin={-40,-80})));
    Modelica.Blocks.Math.Gain Area(k=0.25) annotation (Placement(transformation(
          origin={-76,-80},
          extent={{-10,-10},{10,10}},
          rotation=0)));
    Modelica.Blocks.Math.Add add3 annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation=0,     origin={-18,54})));
    Modelica.Blocks.Math.Product TFluid_square annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-64,-38})));
    Modelica.Blocks.Math.Product TBody_square annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-50,24})));
    Modelica.Blocks.Math.Add add1 annotation (
      Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation=0,     origin={-18,2})));
    Modelica.Blocks.Math.Product product3 annotation (
      Placement(transformation(extent={{-11,-11},{11,11}},      rotation=0,     origin={27,45})));
    Modelica.Blocks.Math.Product product1 annotation (
      Placement(transformation(extent={{-11,-11},{11,11}},      rotation=0,     origin={75,1})));
    Modelica.Blocks.Sources.Constant TDs(k=3)
      annotation (Placement(transformation(extent={{-98,-2},{-88,8}})));
  equation
    connect(Area.u, epsilon)
      annotation (Line(points={{-88,-80},{-120,-80}}, color={0,0,127}));
    connect(sigma.u, Area.y)
      annotation (Line(points={{-52,-80},{-65,-80}}, color={0,0,127}));
    connect(add3.u1, T_Body)
      annotation (Line(points={{-30,60},{-120,60}}, color={0,0,127}));
    connect(TBody_square.u1, T_Body) annotation (Line(points={{-62,30},{-90,30},{
            -90,60},{-120,60}}, color={0,0,127}));
    connect(TBody_square.u2, T_Body) annotation (Line(points={{-62,18},{-90,18},{
            -90,60},{-120,60}}, color={0,0,127}));
    connect(add1.u1, TBody_square.y)
      annotation (Line(points={{-30,8},{-30,24},{-39,24}}, color={0,0,127}));
    connect(add1.u2, TFluid_square.y) annotation (Line(points={{-30,-4},{-50,-4},
            {-50,-38},{-53,-38}}, color={0,0,127}));
    connect(product3.u1, add3.y) annotation (Line(points={{13.8,51.6},{-4,51.6},{
            -4,54},{-7,54}}, color={0,0,127}));
    connect(product3.u2, add1.y) annotation (Line(points={{13.8,38.4},{-2,38.4},{
            -2,2},{-7,2}}, color={0,0,127}));
    connect(product1.u1, product3.y) annotation (Line(points={{61.8,7.6},{46,7.6},
            {46,45},{39.1,45}}, color={0,0,127}));
    connect(product1.y, h_Rad) annotation (Line(points={{87.1,1},{94,1},{94,-1},{
            119,-1}}, color={0,0,127}));
    connect(product1.u2, sigma.y) annotation (Line(points={{61.8,-5.6},{-2,-5.6},
            {-2,-80},{-29,-80}}, color={0,0,127}));
    connect(TDs.y, add3.u2) annotation (Line(points={{-87.5,3},{-84,3},{-84,48},{
            -30,48}}, color={0,0,127}));
    connect(TFluid_square.u1, TDs.y)
      annotation (Line(points={{-76,-32},{-76,3},{-87.5,3}}, color={0,0,127}));
    connect(TFluid_square.u2, TDs.y) annotation (Line(points={{-76,-44},{-86,-44},
            {-86,-6},{-76,-6},{-76,3},{-87.5,3}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={238,46,47},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
              extent={{-100,100},{100,-100}}, lineColor={28,108,200})}));
  end Radiation2Convection;

  block f_epsilon
    "function which gives emissivity of the radiator in function of the angle"
    Modelica.Blocks.Interfaces.RealInput theta annotation (Placement(
          transformation(extent={{-120,-10},{-100,10}}),
                                                       iconTransformation(extent={{-120,
              -10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealOutput eps annotation (Placement(
          transformation(extent={{100,-10},{120,10}}),
                                                     iconTransformation(extent={{100,-10},
              {120,10}})));
    parameter Real eps_min = 0.01;
    parameter Real eps_max = 0.98;
    parameter Real theta_min = -0.4*Modelica.Constants.pi;

  equation
    eps = eps_min + (eps_max - eps_min)/(-theta_min)*(theta - theta_min);
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
                                                  lineColor={28,108,200}),
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end f_epsilon;

  block ControlBlock
    Modelica.Blocks.Interfaces.RealInput T1_sensor
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Theta
      annotation (Placement(transformation(extent={{-140,-88},{-100,-48}})));
    Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=-0.4*
          Modelica.Constants.pi)                                                                          annotation (
      Placement(transformation(origin={-50,-50},     extent = {{-10, -10}, {10, 10}}, rotation=0)));
    Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold
      annotation (Placement(transformation(extent={{-60,-94},{-40,-74}})));
    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=294.15)
      annotation (Placement(transformation(extent={{-58,16},{-38,36}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=294.15)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{-16,-20},{4,0}})));
    Modelica.Blocks.Logical.Or or1
      annotation (Placement(transformation(extent={{36,-10},{56,10}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{-18,14},{2,34}})));
    Modelica.Blocks.Interfaces.RealInput V_in
      annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
    Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(
          transformation(extent={{100,-20},{138,18}}), iconTransformation(
            extent={{100,-20},{138,18}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{66,54},{86,74}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{4,68},{24,88}})));
  equation
    connect(lessEqualThreshold.u, Theta) annotation (Line(points={{-62,-50},{-94,
            -50},{-94,-68},{-120,-68}}, color={0,0,127}));
    connect(greaterEqualThreshold.u, Theta) annotation (Line(points={{-62,-84},{
            -94,-84},{-94,-68},{-120,-68}}, color={0,0,127}));
    connect(greaterThreshold.u, T1_sensor) annotation (Line(points={{-60,26},{-96,
            26},{-96,0},{-120,0}}, color={0,0,127}));
    connect(lessThreshold.u, T1_sensor) annotation (Line(points={{-62,-10},{-94,
            -10},{-94,0},{-120,0}}, color={0,0,127}));
    connect(and1.u1, lessThreshold.y)
      annotation (Line(points={{-18,-10},{-39,-10}}, color={255,0,255}));
    connect(and1.u2, lessEqualThreshold.y) annotation (Line(points={{-18,-18},{
            -36,-18},{-36,-50},{-39,-50}}, color={255,0,255}));
    connect(and1.y, or1.u2) annotation (Line(points={{5,-10},{26,-10},{26,-8},{34,
            -8}}, color={255,0,255}));
    connect(and2.u1, greaterThreshold.y) annotation (Line(points={{-20,24},{-34,
            24},{-34,26},{-37,26}}, color={255,0,255}));
    connect(and2.u2, greaterEqualThreshold.y) annotation (Line(points={{-20,16},{
            -30,16},{-30,-84},{-39,-84}}, color={255,0,255}));
    connect(and2.y, or1.u1) annotation (Line(points={{3,24},{24,24},{24,0},{34,0}},
          color={255,0,255}));
    connect(switch1.u2, or1.y) annotation (Line(points={{64,64},{56,64},{56,14},
            {64,14},{64,0},{57,0}}, color={255,0,255}));
    connect(switch1.y, y) annotation (Line(points={{87,64},{96,64},{96,-1},{119,
            -1}}, color={0,0,127}));
    connect(switch1.u3, V_in) annotation (Line(points={{64,56},{-94,56},{-94,80},
            {-120,80}}, color={0,0,127}));
    connect(const.y, switch1.u1) annotation (Line(points={{25,78},{54,78},{54,
            72},{64,72}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={170,255,170},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  end ControlBlock;
  annotation (uses(Modelica(version="4.0.0")));
end Puzzolante10656823_Assign2_Ex1;
