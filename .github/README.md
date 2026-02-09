
<div align="center">

# ✦ nucleus-shell ✦

<p>
  <img src="https://img.shields.io/github/last-commit/xzepyx/nucleus-shell?style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B" alt="Last Commit" />
  <img src="https://img.shields.io/github/stars/xZepyx/nucleus-shell?style=for-the-badge&logo=andela&color=86dbd7&logoColor=D9E0EE&labelColor=1E202B" alt="Stars" />
  <img src="https://img.shields.io/github/repo-size/xZepyx/nucleus-shell?color=86dbce&label=SIZE&logo=protondrive&style=for-the-badge&logoColor=D9E0EE&labelColor=1E202B" alt="Repo Size" />
  &nbsp;
  <img src="https://img.shields.io/badge/Maintenance-Active%20-6BCB77?style=for-the-badge&logo=vercel&logoColor=D9E0EE&labelColor=1E202B" alt="Maintenance" />
</p>

</div>

---
<h2 align="center">✦ Overview ✦ </h2>

#### A shell built to get things done.

Key goals:
- Minimal, script-centric configuration
- Easy to review and selectively apply
- Composable modules for prompts, completions, and UI widgets

> [!IMPORTANT]
> * If you want to access the older releases refer to the [archive branch](https://github.com/xZepyx/nucleus-shell/tree/archive)
> * You can also join the [discord server](https://discord.gg/SvQMhuMXXa) for help.
> * **Before reporting an issue:**
  If you encounter a problem in the current release, please first test against the latest source code by cloning the repository (`git clone ...`). This ensures you are not reporting an issue that has already been fixed.
  Only open an issue if the problem is still reproducible on the latest source.

---

<h2 align="center">✦ Previews ✦</h2>


<div align="center">

| Top Bar                                         | Bottom Bar                                           |
|--------------------------------------------------|----------------------------------------------------|
| ![TopBar](/previews/3.png)                       | ![BottomBar](/previews/2.png)                        |
| **Left Bar**                                         | **Right Bar**                                           |
| ![LeftBar](/previews/1.png)                       | ![RightBar](/previews/4.png)                        |

</div>

---

<h2 align="center">✦ Related Projects ✦</h2>

* [nucleus-cli](https://github.com/unf6/nucleus): CLI for nucleus-shell
* [nucleus-plugins](https://github.com/xZepyx/nucleus-plugins): Plugins for nucleus-shell
* [nucleus-colorschemes](https://github.com/xZepyx/nucleus-colorschemes): Colorschemes for nucleus-shell
* [zenith](https://github.com/xZepyx/zenith): Intelligence backend for nucleus-shell (required to use intelligence)

---

<h2 align="center">✦ Repository layout ✦</h2>


- /quickshell/     — Primary shell
- /license/        — License and contributing docs
- /previews/       — Example screenshots used in this README
- /install/          — Installer scripts and bootstrap utilities
- /.github/        — README and other stuff

---

<h2 align="center">✦ Installation ✦</h2>


Follow these steps to install the collection. The automated setup is conservative and will prompt before making destructive changes.

### Using the cli:
```bash
yay -S nucleus-cli
nucleus install
```
### Using the install script
```bash
git clone https://github.com/xZepyx/nucleus-shell
cd nucleus-shell
cd install
./unified.sh
```
Notes:
- Manual installation (symlinking files yourself) is supported and recommended for cautious users.
- Install Script is preffered over the cli installation. 
- Back up your existing dotfiles (e.g. ~/.config/ ~/.bashrc, ~/.zshrc, ~/.profile) before running the bootstrap.

---

<h2 align="center">✦ Configuration &amp; customization ✦</h2>

- Primary config: `~/.config/nucleus-shell/config/configuration.json`
- Modular settings: prompt, completion, and widget modules are separated for easy replacement.
- To customize:
  - Edit the primary config or use the provided settings app (if installed).
  - Enable/disable modules by editing the module list in the `~/.config/quickshell/nucleus-shell/shell.qml` file.

---

<h2 align="center">✦ Recommended environment ✦</h2>

- Compositor: Hyprland
- Terminal: Kitty
- Fonts: JetBrainsMono

---

<h2 align="center">✦ Troubleshooting ✦</h2>

- Missing/Unloaded Modules:
  - Ensure the module file is loaded in the correct order. Check `~/.config/quickshell/nucleus-shell/shell.qml`.
- Broken visuals:
  - Check `~/.local/share/nucleus/user/config.json`
- Slow startup:
  - Disable unused modules or lazy-load heavy features (e.g., prompt segments that query network/state).
- Conflicting user configs:
  - Inspect existing profile files (`~/.bashrc`, `~.zshrc`, `~/.profile`, `~/.config`) before applying changes.
- Installer failures:
  - Re-run the installer with verbose output or check `install/` scripts for dependency checks.

---

<h2 align="center">✦ To-Do ✦</h2>

- Read [Todo.md](../docs/Todo.md)

---
<div align="center">
  
## ✦ Weird Tentacles ✦
<a href="https://www.star-history.com/#xZepyx/nucleus-shell&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=xZepyx/nucleus-shell&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=xZepyx/nucleus-shell&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=xZepyx/nucleus-shell&type=date&legend=top-left" />
 </picture>
</a>

</div>

---

<h2 align="center">✦ Contributing ✦</h2>

Contributions are welcome. When contributing:
- Open concise issues after confirming the problem isn't caused by local configuration.
- Submit focused PRs with clear descriptions and tests where applicable.
- Follow code structure and naming conventions used in `dots/`.

- See `license/CONTRIBUTING.md` for full contribution guidelines.
- If you are a collaborator make sure to read `license/COLLABORATORS.md`

---

<h2 align="center">✦ Maintainer ✦</h2>

- Maintainer: xZepyx (Aditya Yadav) 
- Contact: [zepyxunderscore@gmail.com](mailto:zepyxunderscore@gmail.com)

---

<h2 align="center">✦ Acknowledgments ✦</h2>

- QuickShell and its contributors
- Hyprland and its developers/contributors

---

<h2 align="center">✦ Inspiration / Copying ✦</h2>

#### I did copy some code from other repositories and took design inspirations which are listed here:
* [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (Copied some services, took some design inspirations)
* [etherealboi/twinshell](https://github.com/etherealboi/twinshell) (Some widgets)
* [bgibson72/yahr-quickshell](https://github.com/bgibson72/yahr-quickshell) (A script that lists installed apps)
* [caelestia-dots/shell](https://github.com/caelestia-dots/shell) (Didn't copy any code, but yoinked a lot of design from caelestia's vertical bar design)

---

<h2 align="center">✦ Thank You ✦</h2>

* [@xr3tc](https://github.com/unf6): For helping me out on cli and lot of other web and stuff (and being a great friend)
* [@end4](https://github.com/end-4): For his great projects. (I yoinked a lot of stuff)
* [@ivan](https://github.com/SavingFrame): Thanks bro for being our first "actual" contributor.
* [@soramanew](https://github.com/soramanew): We haven't talked but I was greatly inspired by his project **caelestia-shell**
* [@Axenide](https://github.com/axenide): I also haven't talked to him but his project **Ax-Shell** led me into hyprland shells for the first time.

---

<h2 align="center">✦ License ✦</h2>

© 2025 xZepyx (Aditya Yadav) — Licensed under the MIT License. See `license/` for details.

---
