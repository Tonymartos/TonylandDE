<div align="center">


<img src="Source/assets/tonylandde_logo.svg" alt="TonylandDE Logo" width="400"/>

<h2>TonylandDE - Hyprland Desktop Environment</h2>

<br>

> [!NOTE]
> TonylandDE is a customized template based on [HyDE (Hyprland Desktop Environment)](https://github.com/HyDE-Project/HyDE).
> We recommend visiting the original HyDE repository first to understand the base system before using this template.

<br>

<div align="center">

<br>

<a id="installation"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&size=28&pause=1000&color=A78BFA&vCenter=true&width=435&height=30&lines=INSTALLATION" width="450"/>

---

```shell
sudo pacman -S --needed git base-devel
git clone --depth 1 https://github.com/Tonymartos/TonylandDE ~/TonylandDE
cd ~/TonylandDE/Scripts
./install.sh
```

<div align="right">
  <br>
  <a href="#-design-by-t2"><kbd> <br> 🡅 <br> </kbd></a>
</div>

<a id="updating"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&size=28&pause=1000&color=A78BFA&vCenter=true&width=435&height=30&lines=UPDATING" width="450"/>

---

To update TonylandDE, you will need to pull the latest changes from GitHub and restore the configs by running the following commands:

```shell
cd ~/TonylandDE/Scripts
git pull origin master
./install.sh -r
```

> TonylandDE includes custom themes and supports all official HyDE themes.
