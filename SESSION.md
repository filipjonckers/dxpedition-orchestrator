# Session State — DXpedition Orchestrator

## All phases implemented (2-9)

| Phase | Status | Key files |
|---|---|---|
| 2 Windows Installation | Done | `install/Autounattend.xml`, `docs/boot.md` |
| 3 Bootstrap | Done | `scripts/bootstrap.ps1` |
| 4 Core Deployment | Done | `scripts/deploy.ps1`, `scripts/helpers.ps1` |
| 5 Windows Configuration | Done | `scripts/configure-windows.ps1` |
| 6 Drivers | Done | `scripts/install-drivers.ps1` |
| 7 Software | Done | `scripts/install-software.ps1`, `software/*/install.yaml` |
| 8 File Copy | Done | `scripts/copy-files.ps1` |
| 9 Restore | Done | `scripts/restore.ps1` |

## Key decisions made during development

- N1MM (duplicate) removed from software lists — keep only N1MM Logger+
- AGENTS.md directory listing updated to include hardware/, files/, logs/
- YAML configs deferred to Phase 4 (created then, not earlier)
- Hardware type selection menu deferred (future)
- Timezone set to UTC (not Romance Standard Time)
- docs/boot.md lives in docs/ (not install/)
- software/ contains install logic only; actual installer binaries stay on USB

## Bugs fixed during review

- Autounattend.xml now searches for lowercase `autounattend.xml` (matched docs)
- bootstrap.ps1 Git installer uses wildcard `*.exe` (not hardcoded version)
- install-drivers.ps1 checks `$LASTEXITCODE` after pnputil
- helpers.ps1 simplified LogFile assignment
- files/ and drivers/ directories created with .gitkeep
- hostname + timezone wired from system.yml into configure-windows.ps1
- Removed unused `username`/`password` from system.yml

## Current state

- Branch: `deepseek`
- All 9 roadmap phases implemented
- Phase 10 (testing) ready — test plan at `docs/testing.md`
- No Windows environment available for testing yet
- Next real step: prepare USB, boot laptop, run through test plan checkboxes

## File inventory

```
.
├── AGENTS.md               # Project rules for AI
├── PROJECT.md              # Requirements & scope
├── ROADMAP.md              # Phase tracking (all [x])
├── README.md               # User-facing overview
├── SESSION.md              # THIS FILE - pickup state
├── install/
│   └── Autounattend.xml    # Unattended Windows answer file
├── scripts/
│   ├── bootstrap.ps1       # First-boot prep (Git, repo, trigger deploy)
│   ├── deploy.ps1          # Orchestrator (4 phases, critical/non-critical)
│   ├── helpers.ps1         # Write-Log, Read-Yaml
│   ├── configure-windows.ps1  # Scaling, keyboard, desktop, perf, hostname, tz
│   ├── install-drivers.ps1    # Windows Update / local pnputil / skip
│   ├── install-software.ps1   # YAML-driven unattended install
│   ├── copy-files.ps1         # Pipe-format file mapping
│   └── restore.ps1            # Re-runs config + software + files
├── config/
│   ├── system.yml           # Hostname, keyboard, scaling, desktop, tz, driver_mode
│   ├── software.yml         # Package list
│   └── files.yml            # File mappings (commented examples)
├── software/
│   ├── N1MM-Logger-plus/install.yaml
│   ├── WSJT-X/install.yaml
│   ├── MSHV/install.yaml
│   └── DXLog/install.yaml
├── drivers/.gitkeep
├── files/.gitkeep
├── docs/
│   ├── boot.md              # USB preparation guide
│   └── testing.md           # Test plan with checkboxes
└── hardware/
    ├── usb-drive-tiny11.md  # Tiny11 ISO + Rufus guide
    └── HP-Elite-C1030-chromebook.md
```

## When resuming

1. Read AGENTS.md + ROADMAP.md + SESSION.md
2. Phase 10 starts — user needs to run tests on Windows/Tiny11 hardware
3. Mark checkboxes in docs/testing.md as tests pass
4. If bugs found during testing, fix them in the relevant script
5. Phase 11 (optional improvements) is deferred — do NOT implement unless asked