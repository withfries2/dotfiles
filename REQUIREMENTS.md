# Dotfiles Infrastructure Requirements: Source of Truth

## 1. Objective
To maintain a unified, portable environment across a heterogeneous fleet of devices. The configuration must intelligently adapt to different Operating Systems and functional Roles while maintaining a shared "developer experience" (aliases, paths, and tools).

## 2. Target Fleet Matrix

### OS Variants & Contexts
| OS ID | Base | Hardware / Platform | Key Characteristics |
| :--- | :--- | :--- | :--- |
| **arch** | Arch | Omarchy Desktop/Laptop | Hyprland, `pacman` + AUR. |
| **pop** | Ubuntu | System76 Laptop | GNOME/COSMIC, `apt`, `system76-power`. |
| **darwin** | BSD | Work MacBook | `brew`, Zsh-first. |
| **chromeos** | Debian | Chromebook (Crostini) | `apt` in container, limited hardware access. |
| **debian** | Debian | Proxmox, LXC, WSL | Minimal footprint, stable `apt`. |

### Functional Roles
* **`desktop`**: Fixed workstations. Priority on performance, full GUI suites, and complete TUI stacks.
* **`laptop`**: Portable machines. Adds power management, brightness control, and touchpad optimizations.
* **`server`**: Headless environments. Minimalist; zero GUI configuration or font installation.



## 3. Implementation Strategy

### 3.1 Data-Driven Installation (.chezmoidata.yaml)
* **Logic Separation**: Move package lists out of shell scripts and into a YAML manifest.
* **Priority**: 
    1. Native Package Manager (`apt`, `pacman`, `brew`).
    2. Pre-built Binaries (GitHub) to ensure modern tools (e.g., `yazi`, `eza`) on stable distros.
    3. Cargo/Source only as a last resort.

### 3.2 Shell Synchronization (The "No-Drift" Policy)
* **Partial Templates**: All aliases, shared paths, and common functions reside in `~/.local/share/chezmoi/.chezmoitemplates/`.
* **Injection**: Both `.bashrc.tmpl` and `.zshrc.tmpl` must "include" these partials to ensure feature parity.
* **OS-Aware Aliases**: Handle naming discrepancies (e.g., `bat` vs `batcat`) at the template level.

### 3.3 Hardware & Power Management
* **Laptops**: Trigger `system76-power` profiles on Pop!_OS.
* **WSL**: Detect `microsoft` kernel to trigger Windows Terminal configuration sync.

## 4. Security & Secret Management
* **Public Repository**: Zero plaintext secrets or private keys.
* **Bitwarden Integration**: Use `bw` CLI for sensitive credential injection and SSH key management.
* **SSH**: Use unique keys per machine or automated recovery via Bitwarden.

## 5. Maintenance Workflow
1.  **Modify Source**: Edit templates in `~/.local/share/chezmoi`.
2.  **Verify**: Use `chezmoi diff` to check generated files.
3.  **Apply**: `chezmoi apply` to update the home directory.
4.  **Sync**: Git push to public GitHub repository.
