
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
> * You can also join the [discord server](https://discord.gg/eRDPxNqnPZ) for help.
> * **Before reporting an issue:**
  If you encounter a problem in the current release, please first test against the latest source code by cloning the repository (`git clone ...`). This ensures you are not reporting an issue that has already been fixed.
  Only open an issue if the problem is still reproducible on the latest source.
> * Head over to the [colorschemes](https://github.com/xZepyx/nucleus-colorschemes) repo to get some custom themes for nucleus-shell
> * Also have a look at the [plugins](https://github.com/xZepyx/nucleus-plugins) repo to get some plugins for nucleus-shell

> [!CAUTION]
> Using llms inside the shell requires installing and setting up [zenith](https://github.com/xZepyx/zenith) into `/usr/bin` or `~/.local/bin`.
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

<h2 align="center">✦ Repository layout ✦</h2>


- /quickshell/     — Primary shell
- /license/        — License and contributing docs
- /previews/       — Example screenshots used in this README
- /install/          — Installer scripts and bootstrap utilities
- /.github/        — README and other stuff

---

<h2 align="center">✦ Installation ✦</h2>


Follow these steps to install the collection. The automated setup is conservative and will prompt before making destructive changes.

1. Clone the repository:
    ```bash
    git clone https://github.com/xZepyx/nucleus-shell.git ~/.nucleus-shell
    cd ~/.nucleus-shell
    ```

2. Inspect configuration and optional modules:
    - Review files in `system/` if needed.

3. Run the installer:
    ```bash
    cd install && bash unified.sh
    ```
    - The installer will guide you through dependency checks and optional modules.
    - The script will either let to install the complete dotfiles or only the shell itself.

4. Open a fresh shell session or source your shell profile to apply changes.

Notes:
- Manual installation (symlinking files yourself) is supported and recommended for cautious users.
- Back up your existing dotfiles (e.g. ~/.config/ ~/.bashrc, ~/.zshrc, ~/.profile) before running the bootstrap.
- Other files under the install directory: `pkg.sh`, `update.sh` and `files.sh` read `install/README.md`.

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

- [x] Redesign config layout and widget system for improved modularity and discoverability
- [ ] Add more curated optional modules and theme variants 
- [x] Improve installer prompts and backup behavior
- [ ] Add inbuilt-ai
- [x] Improve shell performance (currently a big laggy on my machine)

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
* [caelestia-dots/shell](https://github.com/caelestia-dots/shell) (No code but almost copied the vertical bar design)
* [corecathx/whisker](https://github.com/corecathx/whisker) (Took lots of inspiration and code)

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
