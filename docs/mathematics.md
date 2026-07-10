# Mathematics and Model Structure

This page explains the main mathematical equations and computational structures used across CFD1–CFD12. Symbols are kept consistent where possible, although individual notebooks may use simplified constants or different coordinate orientations.

## 1. Flow variables

The three-dimensional velocity field is

```math
\mathbf{u}(\mathbf{x},t)
=
\begin{bmatrix}
u(\mathbf{x},t)\\
v(\mathbf{x},t)\\
w(\mathbf{x},t)
\end{bmatrix},
\qquad
\mathbf{x}=\begin{bmatrix}x&y&z\end{bmatrix}^{\mathsf T}.
```

The pressure, temperature, and absolute-humidity fields are written as

```math
p(\mathbf{x},t),
\qquad
T(\mathbf{x},t),
\qquad
H(\mathbf{x},t).
```

The early 2D notebooks use

```math
\mathbf{u}(x,y,t)=\begin{bmatrix}u(x,y,t)&v(x,y,t)\end{bmatrix}^{\mathsf T}.
```

## 2. Conservation of mass

For an incompressible fluid with constant density, conservation of mass becomes the divergence-free condition

```math
\nabla\cdot\mathbf{u}=0.
```

In three dimensions,

```math
\frac{\partial u}{\partial x}
+\frac{\partial v}{\partial y}
+\frac{\partial w}{\partial z}=0.
```

In the 2D notebooks, this reduces to

```math
\frac{\partial u}{\partial x}
+\frac{\partial v}{\partial y}=0.
```

This constraint is why pressure must be solved even when pressure itself is not the main quantity of interest.

## 3. Incompressible Navier–Stokes momentum equation

The airflow model is based on

```math
\frac{\partial\mathbf{u}}{\partial t}
+(\mathbf{u}\cdot\nabla)\mathbf{u}
=
-\frac{1}{\rho}\nabla p
+\nu\nabla^2\mathbf{u}
+\mathbf{f},
```

where

```math
\rho=\text{fluid density},
\qquad
\nu=\frac{\mu}{\rho}=\text{kinematic viscosity},
```

and \(\mathbf{f}\) represents any body force per unit mass.

The nonlinear convection term is

```math
(\mathbf{u}\cdot\nabla)\mathbf{u}
=
u\frac{\partial\mathbf{u}}{\partial x}
+v\frac{\partial\mathbf{u}}{\partial y}
+w\frac{\partial\mathbf{u}}{\partial z}.
```

The viscous diffusion term is

```math
\nu\nabla^2\mathbf{u}
=
\nu\left(
\frac{\partial^2\mathbf{u}}{\partial x^2}
+\frac{\partial^2\mathbf{u}}{\partial y^2}
+\frac{\partial^2\mathbf{u}}{\partial z^2}
\right).
```

## 4. Projection method used in the Python prototypes

CFD1–CFD7A use a pressure-projection structure. First, the momentum equation is advanced without the new pressure to obtain a provisional velocity \(\mathbf{u}^{*}\):

```math
\frac{\mathbf{u}^{*}-\mathbf{u}^{n}}{\Delta t}
=
-(\mathbf{u}^{n}\cdot\nabla)\mathbf{u}^{n}
+\nu\nabla^2\mathbf{u}^{n}
+\mathbf{f}^{n}.
```

The corrected velocity is

```math
\mathbf{u}^{n+1}
=
\mathbf{u}^{*}
-\frac{\Delta t}{\rho}\nabla p^{n+1}.
```

Imposing

```math
\nabla\cdot\mathbf{u}^{n+1}=0
```

produces the pressure Poisson equation

```math
\nabla^2p^{n+1}
=
\frac{\rho}{\Delta t}\nabla\cdot\mathbf{u}^{*}.
```

After the Poisson equation is iteratively solved, its pressure gradient removes the divergent part of the provisional velocity.

## 5. Finite-difference structure

For a uniform grid, a centered first derivative can be written as

```math
\left.\frac{\partial\phi}{\partial x}\right|_{i,j,k}
\approx
\frac{\phi_{i+1,j,k}-\phi_{i-1,j,k}}{2\Delta x}.
```

A one-sided/upwind derivative for positive \(u\) is

```math
\left.\frac{\partial\phi}{\partial x}\right|_{i,j,k}
\approx
\frac{\phi_{i,j,k}-\phi_{i-1,j,k}}{\Delta x}.
```

The three-dimensional Laplacian is approximated by

```math
\begin{aligned}
\left.\nabla^2\phi\right|_{i,j,k}
\approx{}&
\frac{\phi_{i+1,j,k}-2\phi_{i,j,k}+\phi_{i-1,j,k}}{\Delta x^2}\\
&+\frac{\phi_{i,j+1,k}-2\phi_{i,j,k}+\phi_{i,j-1,k}}{\Delta y^2}\\
&+\frac{\phi_{i,j,k+1}-2\phi_{i,j,k}+\phi_{i,j,k-1}}{\Delta z^2}.
\end{aligned}
```

## 6. Pressure iteration and Gauss–Seidel structure

For a discrete Poisson equation

```math
A p=b,
```

the Gauss–Seidel update uses newly calculated values as soon as they become available:

```math
p_i^{(m+1)}
=
\frac{1}{a_{ii}}
\left(
b_i
-\sum_{j<i}a_{ij}p_j^{(m+1)}
-\sum_{j>i}a_{ij}p_j^{(m)}
\right).
```

The 3D Python prototypes use this iterative structure for the pressure Poisson equation.

## 7. Stability conditions

An explicit convection step is constrained by a Courant-type condition:

```math
\mathrm{CFL}
=
\max\left(
\frac{|u|\Delta t}{\Delta x},
\frac{|v|\Delta t}{\Delta y},
\frac{|w|\Delta t}{\Delta z}
\right)
\lesssim 1.
```

An explicit diffusion step also requires approximately

```math
\nu\Delta t
\left(
\frac{1}{\Delta x^2}
+\frac{1}{\Delta y^2}
+\frac{1}{\Delta z^2}
\right)
\lesssim \frac{1}{2}.
```

These restrictions explain why increasing spatial resolution can sharply increase runtime in the custom Python solver.

## 8. Temperature energy equation

With constant properties and no viscous heating, temperature transport is modeled as

```math
\frac{\partial T}{\partial t}
+\mathbf{u}\cdot\nabla T
=
\alpha\nabla^2T
+\frac{\dot q}{\rho c_p},
```

where thermal diffusivity is

```math
\alpha=\frac{k}{\rho c_p}.
```

Here, \(k\) is thermal conductivity, \(c_p\) is specific heat capacity, and \(\dot q\) is a volumetric heat source.

## 9. Absolute-humidity transport

Humidity is treated as an Eulerian scalar:

```math
\frac{\partial H}{\partial t}
+\mathbf{u}\cdot\nabla H
=
D_H\nabla^2H
+S_H,
```

where \(D_H\) is the effective humidity diffusivity and \(S_H\) is a source term.

In CFD11 and CFD12, humidity is exported from OpenFOAM-related processing but is intentionally excluded from the saved IAFNO training state.

## 10. Boundary and initial conditions

An initial-value problem specifies

```math
\mathbf{u}(\mathbf{x},0)=\mathbf{u}_0(\mathbf{x}),
\qquad
T(\mathbf{x},0)=T_0(\mathbf{x}),
\qquad
H(\mathbf{x},0)=H_0(\mathbf{x}).
```

A prescribed inlet uses a Dirichlet condition such as

```math
\mathbf{u}|_{\Gamma_{\mathrm{in}}}=\mathbf{u}_{\mathrm{in}}.
```

A no-slip wall uses

```math
\mathbf{u}|_{\Gamma_{\mathrm{wall}}}=\mathbf{0}.
```

A zero-gradient outlet approximation is

```math
\left.\frac{\partial\mathbf{u}}{\partial n}\right|_{\Gamma_{\mathrm{out}}}=0,
```

often combined with a pressure reference such as

```math
p|_{\Gamma_{\mathrm{out}}}=0.
```

## 11. OpenFOAM finite-volume structure

OpenFOAM integrates each conservation law over a control volume \(V_P\). For a scalar \(\phi\),

```math
\int_{V_P}\frac{\partial\phi}{\partial t}\,dV
+\int_{V_P}\nabla\cdot(\mathbf{u}\phi)\,dV
=
\int_{V_P}\nabla\cdot(\Gamma_\phi\nabla\phi)\,dV
+\int_{V_P}S_\phi\,dV.
```

Using the divergence theorem,

```math
\int_{V_P}\nabla\cdot\mathbf{F}\,dV
=
\oint_{\partial V_P}\mathbf{F}\cdot\mathbf{n}\,dA
\approx
\sum_f \mathbf{F}_f\cdot\mathbf{S}_f.
```

This converts volume divergence terms into fluxes through cell faces. The resulting algebraic system has the general form

```math
a_P\phi_P=\sum_N a_N\phi_N+b_P.
```

`blockMesh` creates the background hexahedral mesh, while `snappyHexMesh` refines and conforms that mesh around the STL CAD surface.

## 12. Planned Building-Cube Method structure

The deferred CFD9 comparison was intended to use a hierarchy of Cartesian cubes. A simplified refinement relation is

```math
h_{\ell+1}=\frac{h_{\ell}}{2},
```

where \(h_\ell\) is the cube size at refinement level \(\ell\). In three dimensions, refining one cube into two parts per coordinate direction produces

```math
N_{\mathrm{children}}=2^3=8.
```

The future CFD8-versus-CFD9 study must keep the physics and geometry fixed so differences can be attributed to meshing strategy rather than changed boundary conditions.

## 13. Lagrangian particle position and velocity

Each particle has position and velocity

```math
\mathbf{x}_p(t),
\qquad
\mathbf{v}_p(t).
```

Its position evolves according to

```math
\frac{d\mathbf{x}_p}{dt}=\mathbf{v}_p.
```

For a small spherical particle with Stokes drag,

```math
\frac{d\mathbf{v}_p}{dt}
=
\frac{\mathbf{u}(\mathbf{x}_p,t)-\mathbf{v}_p}{\tau_p}
+\mathbf{g}_{\mathrm{eff}}.
```

The particle response time is

```math
\tau_p=\frac{\rho_p d_p^2}{18\mu},
```

where \(\rho_p\) is particle density, \(d_p\) is diameter, and \(\mu\) is dynamic viscosity.

For very small \(tau_p\),

```math
\mathbf{v}_p\approx\mathbf{u}(\mathbf{x}_p,t),
```

so the particle behaves approximately as a passive tracer.

## 14. Interpolation from the Eulerian grid

The particle velocity requires the airflow at a non-grid position. Trilinear interpolation can be written as

```math
\mathbf{u}(\mathbf{x}_p)
\approx
\sum_{a=0}^{1}\sum_{b=0}^{1}\sum_{c=0}^{1}
w_{abc}\,\mathbf{u}_{i+a,j+b,k+c},
```

with weights

```math
w_{abc}
=
\left[a\xi+(1-a)(1-\xi)\right]
\left[b\eta+(1-b)(1-\eta)\right]
\left[c\zeta+(1-c)(1-\zeta)\right].
```

The local coordinates satisfy

```math
0\le\xi,\eta,\zeta\le1,
\qquad
\sum_{a,b,c}w_{abc}=1.
```

## 15. Particle time integration

A first-order explicit update is

```math
\mathbf{v}_p^{n+1}
=
\mathbf{v}_p^n
+\Delta t\left[
\frac{\mathbf{u}(\mathbf{x}_p^n,t^n)-\mathbf{v}_p^n}{\tau_p}
+\mathbf{g}_{\mathrm{eff}}
\right],
```

followed by

```math
\mathbf{x}_p^{n+1}
=
\mathbf{x}_p^n+\Delta t\,\mathbf{v}_p^{n+1}.
```

Collision logic then classifies each particle as active, deposited, escaped, or attached to a moving object.

## 16. CAD segment–triangle collision

For a particle segment

```math
\mathbf{r}(s)=\mathbf{x}_p^n+s(\mathbf{x}_p^{n+1}-\mathbf{x}_p^n),
\qquad 0\le s\le1,
```

collision detection tests whether \(\mathbf{r}(s)\) intersects a CAD triangle

```math
\mathbf{q}(\lambda_1,\lambda_2)
=
\mathbf{v}_0
+\lambda_1(\mathbf{v}_1-\mathbf{v}_0)
+\lambda_2(\mathbf{v}_2-\mathbf{v}_0),
```

subject to

```math
\lambda_1\ge0,
\qquad
\lambda_2\ge0,
\qquad
\lambda_1+\lambda_2\le1.
```

Testing the complete segment prevents fast particles from moving through a thin obstacle between two saved positions.

## 17. Neural-operator learning problem

Let a complete state be

```math
q^n(\mathbf{x})
=
\begin{bmatrix}
u^n(\mathbf{x})&v^n(\mathbf{x})&w^n(\mathbf{x})&p^n(\mathbf{x})&T^n(\mathbf{x})
\end{bmatrix}.
```

The available channels depend on the notebook:

```math
q_{\mathrm{CFD10}}=[u,v,w,p],
\qquad
q_{\mathrm{CFD11/12}}=[u,v,w,p,T].
```

Using five previous states, IAFNO predicts a next-state increment:

```math
\mathcal{G}_{\theta}:
\left[q^m,q^{m+1},q^{m+2},q^{m+3},q^{m+4}\right]
\mapsto
\widehat{\Delta q}^{m+5}.
```

The supervised target is

```math
\Delta q^{m+5}=q^{m+5}-q^{m+4},
```

and the predicted next state is

```math
\widehat q^{m+5}
=
q^{m+4}+\widehat{\Delta q}^{m+5}.
```

## 18. Fourier neural operator structure

For a latent field \(z(\mathbf{x})\), a spectral operator layer has the form

```math
z_{\ell+1}(\mathbf{x})
=
\sigma\left(
W_{\ell}z_{\ell}(\mathbf{x})
+\mathcal{F}^{-1}
\left[
R_{\ell}(\mathbf{k})\,\mathcal{F}[z_{\ell}](\mathbf{k})
\right](\mathbf{x})
\right).
```

Here,

```math
\mathcal{F}=\text{Fourier transform},
\qquad
R_{\ell}(\mathbf{k})=\text{learned spectral weights},
```

and \(W_\ell\) is a local channel-mixing transformation.

## 19. AFNO structure

AFNO reduces spectral cost by dividing Fourier channels into blocks. For block \(b\),

```math
\widehat z_b'
=
\widehat z_b
+W_{2,b}\,\sigma(W_{1,b}\widehat z_b+b_{1,b})
+b_{2,b}.
```

Soft thresholding promotes sparsity:

```math
\mathcal{S}_{\lambda}(a)
=
\mathrm{sgn}(a)\,\max\left(|a|-\lambda,0\right).
```

The inverse transform returns the mixed latent field to physical space.

## 20. IAFNO implicit iteration

IAFNO repeatedly applies a shared or structurally repeated AFNO update. A simplified iteration is

```math
z^{(r+1)}
=
z^{(r)}
+\Delta s\,\Phi_{\theta}\left(z^{(r)},x\right),
\qquad
r=0,1,\ldots,R-1.
```

This resembles an iterative residual integration structure: \(R\) internal iterations refine the latent field before it is decoded to the predicted physical increment.

## 21. Autoregressive rollout

After predicting one state, the five-state window is advanced:

```math
\left[q^m,q^{m+1},q^{m+2},q^{m+3},q^{m+4}\right]
\rightarrow
\left[q^{m+1},q^{m+2},q^{m+3},q^{m+4},\widehat q^{m+5}\right].
```

Repeating this operation creates a long rollout. Prediction error can accumulate because later inputs contain earlier model predictions.

## 22. Normalization

For channel \(c\), standard normalization is

```math
q_c^{\mathrm{norm}}
=
\frac{q_c-\mu_c}{\sigma_c+\varepsilon}.
```

Denormalization is

```math
q_c
=
q_c^{\mathrm{norm}}(\sigma_c+\varepsilon)+\mu_c.
```

Velocity, pressure, and temperature must use their own statistics because their physical scales differ.

## 23. Relative field-data loss

The relative \(L_2\) loss is

```math
\mathcal{L}_{\mathrm{data}}
=
\frac{
\left\|\widehat{\Delta q}-\Delta q\right\|_2
}{
\left\|\Delta q\right\|_2+\varepsilon
}.
```

A fluid mask \(M_f\) can exclude solid cells:

```math
\mathcal{L}_{\mathrm{data,fluid}}
=
\frac{
\left\|M_f\odot(\widehat{\Delta q}-\Delta q)\right\|_2
}{
\left\|M_f\odot\Delta q\right\|_2+\varepsilon
}.
```

## 24. Divergence loss

Predicted airflow is encouraged to remain incompressible through

```math
\mathcal{L}_{\mathrm{div}}
=
\frac{1}{N_f}
\sum_{\mathbf{x}\in\Omega_f}
\left|
\nabla\cdot\widehat{\mathbf{u}}(\mathbf{x})
\right|^2.
```

This loss does not replace the CFD pressure solve; it penalizes nonphysical divergence in the surrogate prediction.

## 25. Solid-velocity loss

With solid mask \(M_s\), no motion inside CAD/solid cells is encouraged by

```math
\mathcal{L}_{\mathrm{solid}}
=
\frac{
\sum_{\mathbf{x}}M_s(\mathbf{x})
\left\|\widehat{\mathbf{u}}(\mathbf{x})\right\|_2^2
}{
\sum_{\mathbf{x}}M_s(\mathbf{x})+\varepsilon
}.
```

## 26. Lagrangian particle loss

Let \(\widehat{\mathbf{x}}_p^{n+1}\) and \(\mathbf{x}_p^{n+1}\) be particle positions obtained from predicted and reference velocity fields. A trajectory loss is

```math
\mathcal{L}_{\mathrm{traj}}
=
\frac{1}{N_p}
\sum_{p=1}^{N_p}
\left\|
\widehat{\mathbf{x}}_p^{n+1}-\mathbf{x}_p^{n+1}
\right\|_2^2.
```

A particle kinetic-energy consistency loss can be written as

```math
\mathcal{L}_{E}
=
\frac{1}{N_p}
\sum_{p=1}^{N_p}
\left|
\frac{1}{2}m_p
\left\|\widehat{\mathbf{v}}_p^{n+1}\right\|_2^2
-
\frac{1}{2}m_p
\left\|\mathbf{v}_p^{n+1}\right\|_2^2
\right|.
```

Depending on the notebook implementation, the Lagrangian term samples predicted/reference grid velocities at particle positions rather than requiring experimentally measured particle paths.

## 27. Boundary-condition and initial-condition losses

The requested but not yet implemented CFD12 boundary-condition loss can be defined as

```math
\mathcal{L}_{\mathrm{BC}}
=
\frac{1}{N_{\Gamma}}
\sum_{\mathbf{x}\in\Gamma}
\left\|
\widehat q(\mathbf{x},t)-q_{\mathrm{BC}}(\mathbf{x},t)
\right|^2.
```

An initial-condition loss can be defined as

```math
\mathcal{L}_{\mathrm{IC}}
=
\frac{1}{N_0}
\sum_{\mathbf{x}\in\Omega}
\left\|
\widehat q(\mathbf{x},0)-q_0(\mathbf{x})
\right|^2.
```

These formulas document the intended next step; they are not claimed as implemented in the archived CFD12 notebook.

## 28. Total training objective

A general combined objective is

```math
\mathcal{L}_{\mathrm{total}}
=
\lambda_{\mathrm{data}}\mathcal{L}_{\mathrm{data}}
+\lambda_{\mathrm{div}}\mathcal{L}_{\mathrm{div}}
+\lambda_{\mathrm{solid}}\mathcal{L}_{\mathrm{solid}}
+\lambda_{\mathrm{traj}}\mathcal{L}_{\mathrm{traj}}
+\lambda_E\mathcal{L}_E
+\lambda_{\mathrm{BC}}\mathcal{L}_{\mathrm{BC}}
+\lambda_{\mathrm{IC}}\mathcal{L}_{\mathrm{IC}}.
```

Only terms actually enabled in a notebook contribute to that notebook's training. BC/IC terms are shown as planned extensions.

## 29. Gradient-based loss balancing

When several losses have very different numerical scales, their weights may be adjusted using gradient norms. For loss \(\mathcal{L}_i\), define

```math
g_i
=
\left\|
\nabla_{\theta}\left(\lambda_i\mathcal{L}_i\right)
\right\|_2.
```

A balancing rule aims for

```math
g_i\approx\overline g
=
\frac{1}{K}\sum_{j=1}^{K}g_j.
```

This prevents one physics term from dominating only because its raw magnitude is larger.

## 30. Evaluation quantities

Field error may be reported as

```math
\varepsilon_{L_2}(q)
=
\frac{\|\widehat q-q\|_2}{\|q\|_2+\varepsilon}.
```

Particle displacement error is

```math
\varepsilon_x(t)
=
\frac{1}{N_p}
\sum_{p=1}^{N_p}
\left\|\widehat{\mathbf{x}}_p(t)-\mathbf{x}_p(t)\right\|_2.
```

The computational speedup of the surrogate relative to CFD is

```math
S
=
\frac{t_{\mathrm{CFD}}}{t_{\mathrm{IAFNO}}}.
```

A scientifically useful comparison should report speed and error together rather than speed alone.

## 31. Structure summary

The complete project can be summarized as

```math
\boxed{
\text{CAD + BC/IC}
\xrightarrow{\text{mesh}}
\text{OpenFOAM CFD}
\xrightarrow{\text{regular-grid export}}
\text{IAFNO training}
\xrightarrow{\text{rollout}}
\widehat{\mathbf{u}},\widehat p,\widehat T
\xrightarrow{\text{Lagrangian integration}}
\widehat{\mathbf{x}}_p(t)
}
```

This equation chain is the central structure connecting the CFD and AI parts of the repository.
