# Cantilever Beam Subjected to Harmonic Loading at the Tip

Nonharmonic periodic loading is applied at the tip of the cantilever beam.<br/>
*STEADY STATE DYNAMICS, HARMONIC=NO

### Files
File| Contents|                        
:-------------| :-------------|                   
[bdy3d_pre.fbd](bdy3d_pre.fbd)| Pre-processing script for CalculiX GraphiX|
[bdy3d.inp](bdy3d.inp) | CalculiX input file|
[bdy3d_run.fbd](bdy3d_run.fbd)| CalculiX GraphiX script to run the analysis and save result plots|               


## Pre-processing
<p align="center">
    <img src="images/cantilever_beam.png" height="400">  <br />
    <b>Figure</b> FE model of the cantilever beam subject to harmonic loading at the tip.
</p>

### Result plots
<p align="center">
    <img src="images/sresmc.png" height="400">  <br />
    <b>Figure</b> Stress at the root vs. frequency. -c.
</p>

<p align="center">
    <img src="images/srespc.png" height="400">  <br />
    <b>Figure</b> Stress at the root vs. frequency. +c.
</p>

<p align="center">
    <img src="images/dres.png" height="400">  <br />
    <b>Figure</b> Displacement at the tip vs. frequency.
</p>
