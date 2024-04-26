<p align="center">
  <img src="https://repository-images.githubusercontent.com/692780762/0ca1031a-ffad-434b-8fab-f6074d020b94" width="300px" height="300px"/>
</p>
<h1 align="center">Nix Configurations for MacOS + NixOS</h1>

This is a group of personal configuration files using Nix that runs on MacOS as well as NixOS. This is 100% Flake driven with no configuration.nix as well as channels.
This is my first time delving into everything that is Nix and while so far has been tested on a MacOS VM and a NixOS VM running on unRaid, this is my daily driver for both. 🤓
Please note this is a work in progress so there are bugs as I am learning to improve and set up for my personal needs.
<br></br>

<table>
    <thead>
        <tr>
            <th></th>
            <th style='text-align:center' >NixOS</th>
            <th style='text-align:center' >MacOS</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Shell</td>
            <td style='text-align:center' colspan=2>zsh</td>
        </tr>
        <tr>
            <td>DE</td>
            <td>none+bspwm</td>
            <td>Aqua</td>
        </tr>
        <tr>
            <td>WM</td>
            <td>bspwm</td>
            <td>Amethyst</td>
        </tr>
        <tr>
            <td>Theme</td>
            <td>WhiteSur-gtk-theme [GTK2/3]</td>
            <td></td>
        </tr>
        <tr>
            <td>Icons</td>
            <td>WhiteSur [GTK2/3]</td>
            <td></td>
        </tr>
        <tr>
            <td>Terminal</td>
            <td style='text-align:center' colspan=2>Alacritty</td>
        </tr>
    </tbody>
</table>
<br>
<h1 align="left">Installing</h1>
<h2 align="left">MacOS</h2>
<p>Change name for Mac and enable Full Disk Access for Terminal in settings</p>
<h3 align="left">Install Dependencies</h3>
<ul>
<li>This is my daily driver on a Macbook Air (M1) running MacOS Sonoma</li>
	<pre class="gitcode">xcode-select --install</pre>
</ul>

<h3 align="left">Install Nix</h3>
<ul>
	<pre class="gitcode">curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install</pre>
</ul>

<h3 align="left">Create Keys</h3>
<ul>
	<pre class="gitcode">nix run github:michaelkeates/nixos-config#createKeys</pre>
</ul>

<h3 align="left">Initialize</h3>
<ul>
	<pre class="gitcode">nix flake init -t github:michaelkeates/nixos-config#default</pre>
</ul>

<h3 align="left">Installation</h3>
<ul>
<li>For the first-time, it is required to move the current /etc/nix/nix.conf out of the way</li>
<pre class="gitcode">sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin</pre>
<li>Then finally run the script below. This wraps the Nix commands, builds and deploys a new Nix Generation as well as removes files that will crash the script.</li>
<pre class="gitcode">chmod +x bin/darwin-build && chmod +x bin/build && bin/build</pre>
</ul>
<br></br>
<h2 align="left">NixOS</h2>
<h3 align="left">Create Keys</h3>
<ul>
	<pre class="gitcode">nix run github:michaelkeates/nixos-config#createKeys</pre>
</ul>
<li>This opens an editor to accept, encrypt, and write your secret to disk. Then push the age file to your private github repo</li>
<ul>
    <pre class="gitcode">EDITOR=vim nix run github:ryantm/agenix -- -e secret.age</pre>
</ul>
<h3 align="left">Installation</h3>
<ul>
	<pre class="gitcode">nix run --experimental-features 'nix-command flakes' github:michaelkeates/nixos-config#install</pre>
</ul>
<br>
<h1 align="left">Rebuild</h1>
<h3 align="left">MacOS & NixOS</h3>
<ul>
	<pre class="gitcode">nix run github:michaelkeates/nixos-config#rebuild</pre>
</ul>
<h3 align="left">Mentions</h3>
<ul>
<p>dustinlyons for his Nix configuration files that this is heavily based on and what I learnt from so all rights to him.</p><a href="https://github.com/dustinlyons/nixos-config">Repository</a>
</ul>
<h3 align="left">Author</h3>
<ul>
Michael Keates <a href="https://www.michaelkeates.co.uk">Website</a>
</ul>
