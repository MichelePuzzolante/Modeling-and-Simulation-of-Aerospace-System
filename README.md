# Modeling & Simulation of Aerospace Systems

A collection of MATLAB, Modelica, and Simulink implementations and written reports for the **Modeling & Simulation of Aerospace Systems** course at [Politecnico di Milano](https://www.polimi.it), A.Y. 2024/25.

> **Instructors:** Prof. Mauro Massari & Prof. Franco Bernelli-Zazzera &nbsp;|&nbsp; **Teaching Assistants:** course staff

---

## Overview

This repository contains the course assignments covering two complementary macro-areas of modern aerospace modeling:

| Macro-area | Topics |
|---|---|
| **Simulation** | Numerical methods for nonlinear equations and ODEs, stability analysis, RK2/RK4/IEX4/BI2 integrators |
| **Modeling** | Causal and acausal (Modelica/Dymola) modeling of aerospace systems, Simulink block diagrams |

Both assignments include a MATLAB implementation and a written report.

---

## Repository Structure

```
Modeling-and-Simulation-of-Aerospace-Systems/
├── Simulation/
│   ├── pareschi252142_Assign1.m      # Six-exercise simulation assignment
│   └── pareschi252142_Assign1.pdf    # Written report for Assignment 1
└── Modeling/
    ├── Pareschi252142_Assign2_Ex1.m  # Causal thermal control simulation (MATLAB)
    ├── pareschi252142_Assign2_ex1.mo # Acausal thermal model (Modelica/Dymola)
    ├── Pareschi252142_Assign2_Ex2.m  # Causal propellant tank model (MATLAB)
    ├── Ass2_Ex2_Part2_sim.slx        # Simulink model for Exercise 2 Part 2
    ├── DymolaResults.csv             # Simulation results exported from Dymola
    ├── exportedVariables.csv         # Exported variables for post-processing
    └── MSAS____Assignment_2__Modeling.pdf  # Written report for Assignment 2
```

---

## Features

### Assignment 1 — Simulation

#### Exercise 1 — Freudenstein Equation

Solves the Freudenstein equation for the output angle α given a range of input angles β for a four-bar linkage (rod lengths a1 = 10, a2 = 13, a3 = 8, a4 = 10 cm):

- **Newton's method** with both analytical and finite-difference Jacobians; convergence tolerance 1e-10.
- Validation against MATLAB's `fzero`; error analysis and convergence plots.

#### Exercise 2 — ODE for a Moving Object with Decreasing Mass

Solves the variable-mass ODE dv/dt = (F(v) + f(t) − α·v) / m(t) using:

- **RK2 and RK4** explicit integrators with multiple step sizes.
- Comparison against an analytical solution; accuracy and execution-time analysis.
- Stability test under high fluid-density conditions.

#### Exercise 3 — Stability Analysis of Numerical Methods

Computes and visualises the stability regions of RK2, RK4, and BI2 methods for a linear test system dx/dt = A·x with eigenvalues dependent on α:

- Stability boundary computed in the complex z-plane.
- Comparison of absolute stability regions across methods.

#### Exercise 4 — Temperature Evolution of a Cooling Body

Integrates the nonlinear cooling ODE dT/dt = −K_c/C · T − K_r/C · T⁴ + (1/C)·(K_r·T_a⁴ + K_c·T_a) combining convective and radiative heat exchange:

- **RK2 and RK4** with varying step sizes; reference solution via `ode89`.
- Accuracy vs. number of function evaluations trade-off analysis.

#### Exercise 5 — RLC Circuit Simulation and Stability Analysis

Solves the state-space system dx/dt = A·x for a second-order RLC circuit:

- **RK2** (explicit, conditionally stable) vs **IEX4** (implicit extrapolation, A-stable).
- Stability-region comparison; accuracy and computational effort benchmarked against the matrix-exponential exact solution (`expmv`).

#### Exercise 6 — Bouncing Ball Simulation

Simulates the free-flight and impact phases of a bouncing ball using `integrate_ball` and RK4:

- Effect of air density ρ on trajectory and energy dissipation.
- RK4 stability analysis for the ball dynamics system.

---

### Assignment 2 — Modeling

#### Exercise 1 — Satellite Thermal Control System

Models a multi-node satellite thermal system with an actuated radiator in two paradigms:

**Causal model (`Pareschi252142_Assign2_Ex1.m`)**

- Five-node temperature state vector (T1–T5) plus radiator angle θ and angular velocity ω.
- Proportional control law with gain k_p = 6×10⁻⁵; total simulation horizon 50 hours.
- Equations of motion integrated via MATLAB's ODE solver with event detection for radiator limits.

**Acausal model (`pareschi252142_Assign2_ex1.mo`)**

- Modelica/Dymola implementation of the same thermal network using acausal components.
- `Thermal_model` encapsulates the nodal heat-balance equations; `Var_eps` block computes emissivity ε as a function of the radiator angle θ.
- Simulation results exported to `DymolaResults.csv` for comparison with the causal model.

#### Exercise 2 — Propellant Tank Causal Model

Causal MATLAB model of a pressurised propellant tank using a Van der Waals gas description:

- **State variables**: tank pressure P_tank, temperature T_tank, and propellant fill level.
- Thermodynamic constants loaded via `constant()` helper; adiabatic speed of sound C derived from the real-gas equation of state.
- Equilibrium initial conditions computed from the Van der Waals isotherm; dynamics propagated with MATLAB's ODE solver.
- Part 2 implemented as a Simulink block diagram (`Ass2_Ex2_Part2_sim.slx`) for block-oriented simulation.

---

## Getting Started

### Requirements

- MATLAB R2023b or later.
- Dymola or OpenModelica (for `.mo` files).
- MATLAB Simulink (for `.slx` files).

---

## Academic Context

These codes were developed as part of the coursework for the **Modeling & Simulation of Aerospace Systems** course at Politecnico di Milano. The assignments cover classical numerical analysis benchmark problems — including four-bar linkage kinematics, variable-mass rocket dynamics, and RLC circuit state-space analysis — as well as aerospace-specific modeling case studies such as satellite thermal regulation and on-board propellant management.

---

                                             ## License

                                             This repository is shared for educational purposes. If you use or adapt this code, please acknowledge the source.
