<p align="center">
  <img src="https://repository-images.githubusercontent.com/692780762/0ca1031a-ffad-434b-8fab-f6074d020b94" width="300px" height="300px"/>
</p>
<h1 align="center">Nix Configurations for MacOS + NixOS</h1>
<p align="center">

<a href="http://unlicense.org/">
<img src="https://img.shields.io/badge/license-Unlicense-blue.svg" alt="License: Unlicense">
</a>

<a href="https://github.com/michaelkeates/nixos-config/issues">
<img src="https://img.shields.io/github/issues/michaelkeates/nixos-config.svg" alt="Issues">
</a>

<a href="https://github.com/michaelkeates/nixos-config/fork">
<img src="https://img.shields.io/github/forks/michaelkeates/nixos-config.svg" alt="Forks">
</a>

<a href="https://github.com/michaelkeates/nixos-config">
<img src="https://img.shields.io/github/stars/michaelkeates/nixos-config.svg" alt="Stars">
</a>

</p>
This is a group of personal configuration files using Nix that runs on MacOS as well as NixOS. This is 100% Flake driven with no configuration.nix as well as channels.
This is my first time delving into everything that is Nix and while so far has been tested on a MacOS VM and a NixOS VM running on unRaid, this will soon become my daily driver. 🤓
Please note this is a work in progress so there are bugs as I am learning to improve and set up for my personal needs.
<br></br>
<h1 align="left">Installing</h1>
<h2 align="left">MacOS</h2>
<p>Change name for Mac and enable Full Disk Access for Terminal in settings</p>
<h3 align="left">Install Dependencies</h3>
<ul>
<li>So far this has been tested on a clean VM running MacOS Sonoma on a Macbook Air (M1)</li>
	<pre>xcode-select --install</pre>
</ul>

<h3 align="left">Install Nix</h3>
<ul>
	<pre>curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install</pre>
</ul>

<h3 align="left">Create Keys</h3>
<ul>
	<pre>nix run github:michaelkeates/nixos-config#createKeys</pre>
</ul>

<h3 align="left">Initialize</h3>
<ul>
	<pre>nix flake init -t github:michaelkeates/nixos-config#default</pre>
</ul>

<h3 align="left">Installation</h3>
<ul>
<li>For the first-time, it is required to move the current /etc/nix/nix.conf out of the way</li>
<pre>sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin</pre>
<li>Then finally run the script below. This wraps the Nix commands, builds and deploys a new Nix Generation as well as removes files that will crash the script.</li>
<pre>chmod +x bin/darwin-build && chmod +x bin/build && bin/build</pre>
</ul>
<br></br>
<h2 align="left">NixOS</h2>
<h3 align="left">ETA</h3>

<h3 align="left">Mentions</h3>
<ul>
<p>dustinlyons for his Nix configuration files that this is heavily based on and what I learnt from so all rights to him <a href="https://github.com/dustinlyons/nixos-config">Repository</a>.</p>
</ul>
<h3 align="left">Author</h3>
<ul>
Michael Keates <a href="https://www.michaelkeates.co.uk">Website</a>
</ul>
