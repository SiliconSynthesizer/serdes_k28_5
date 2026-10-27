# serdes_k28_5 — Verilog-2005 8b/10b SerDes

Pure Verilog-2005, single master clock, SDR serial TX/RX, complete data/K coding, running disparity, adjacent-word alignment and automatic symbol-lock recovery.

From the original workspace root:

```bash
cd serdes_k28_5
bash scripts/compile.sh
bash scripts/run_tests.sh
bash scripts/run_wave.sh
```

For a standalone GitHub clone, enter the cloned `serdes_k28_5` directory once, then run the scripts from that repository root.

Ubuntu dependencies, if needed:

```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

Compilation always uses `iverilog -g2005 -Wall`; simulation uses `vvp`. Three self-checking testbenches terminate with `$fatal(1, ...)` on failure and include timeouts. The terminal prints named `[RUN ]`, `[PASS]` and `[FAIL]` results, including individual coverage groups and a final suite summary. The complete terminal report is saved as `build/test_summary.log`. Logs, executables and VCDs are under `build/`. The test runner returns nonzero on compilation failure, simulation failure or missing PASS completion.

```text
serdes_k28_5/
├── rtl/
│   ├── serdes_top.v          # TX buffer, RX window, pipeline integration
│   ├── encoder_8b10b.v       # 256 data + 12 K, running disparity
│   ├── decoder_8b10b.v       # Complete-code legality/disparity checks
│   ├── tx_serializer.v       # MSB-first, ten bits, ready/valid acceptance
│   ├── rx_deserializer.v     # Bit-valid-qualified raw ten-bit words
│   ├── k28_5_detector.v      # Both comma polarities, offsets 0..9
│   ├── rx_word_aligner.v     # Adjacent-word reconstruction
│   └── rx_symbol_lock.v      # Search, verify, lock, loss and recovery
├── tb/
│   ├── tb_encoder_decoder.v
│   ├── tb_comma_alignment.v
│   └── tb_serdes_loopback.v
├── scripts/
│   ├── clean.sh             # Remove generated simulation files
│   ├── compile.sh
│   ├── run_tests.sh
│   ├── run_wave.sh
│   └── upload_github.sh      # Verify, export and upload to an empty repo
├── build/                    # Generated logs, .vvp and .vcd files
├── docs/
│   ├── architecture.md
│   └── verification_report.md
└── README.md
```

Bit 9 (a) goes first. K28.5 is BC with K=1. The TX accepts symbols only on valid && ready; supply filler when modeling a continuous line. RX samples when rx_bit_valid=1. `serial_tx_valid` is available for a paused simulation transport. Exposed controls include force_realign; diagnostics include TX invalid K, RX code/disparity error, comma, offset and lock. Consumers qualify decoded data with rx_valid. See [architecture](docs/architecture.md) for exact stage timing and acquisition behavior.

Actual verification: three testbenches pass; 3,139 codec checks, twenty comma offset/polarity cases and 5,010 loopback symbol matches. See the [verification report](docs/verification_report.md) for coverage and limits. GTKWave is installed; opening the GUI requires a graphical desktop. The project makes no GHz-rate, DDR-PHY, synthesis timing, or hardware BER claims.

## Upload this project to GitHub

### Create the repository and upload using one script

If the repository does not exist, first authenticate GitHub CLI:

```bash
sudo apt-get install gh
gh auth login --hostname github.com
gh auth setup-git
```

Then create a **private** repository and upload the verified project:

```bash
bash scripts/upload_github.sh --create-private \
  https://github.com/SiliconSynthesizer/serdes_k28_5.git
```

For a repository visible to everyone, use `--create-public` instead. Creation uses [`gh repo create`](https://cli.github.com/manual/gh_repo_create). Without a creation flag, the script expects an existing empty repository, as described below. Do not use a creation flag if the repository already exists.


These instructions publish the portable Verilog-2005 project as its own repository. The upload script creates a separate checkout containing this README, RTL, testbenches, scripts and documentation. Generated VCDs, simulator executables and logs are excluded; users regenerate them by running the tests. The original workspace and its existing Git remote are retained.

1. Sign in to GitHub and create a repository, for example `serdes_k28_5`. Leave it **empty**: do not initialize a README, license or `.gitignore`.
2. Install Git and set your commit identity if it is not configured:

   ```bash
   sudo apt-get install git
   git config --global user.name "Your Name"
   git config --global user.email "your-email@example.com"
   ```

3. For GitHub user `SiliconSynthesizer`, run from this project's directory after creating the empty `serdes_k28_5` repository:

   ```bash
   bash scripts/upload_github.sh https://github.com/SiliconSynthesizer/serdes_k28_5.git
   ```

   With an SSH key already configured for GitHub, use:

   ```bash
   bash scripts/upload_github.sh git@github.com:SiliconSynthesizer/serdes_k28_5.git
   ```

The script checks that the remote is accessible and empty, runs all three required testbenches, copies the source to a new sibling directory named `serdes_k28_5_github`, initializes branch `main`, commits, and pushes. The second argument optionally selects a different **new, nonexistent** local directory:

```bash
bash scripts/upload_github.sh \
  https://github.com/SiliconSynthesizer/serdes_k28_5.git \
  "$HOME/serdes_k28_5-publish"
```

GitHub authentication must already be available through your Git credential manager or SSH agent. For HTTPS terminal prompts, use a GitHub personal access token in place of an account password. Do not place tokens in this script, in repository URLs or in committed files.

The Git commands executed in the new checkout are:

```bash
git init -b main
git add README.md .gitignore rtl tb docs scripts build/.gitkeep
git commit -m "Add verified Verilog-2005 8b/10b SerDes TX/RX project"
git remote add origin https://github.com/SiliconSynthesizer/serdes_k28_5.git
git push -u origin main
```

For later updates, work in the newly created checkout:

```bash
cd /path/to/serdes_k28_5_github
bash scripts/run_tests.sh
git status
git add README.md .gitignore rtl tb docs scripts
git commit -m "Describe your changes"
git push
```

After uploading, another user can clone and verify it with:

```bash
git clone https://github.com/SiliconSynthesizer/serdes_k28_5.git
cd serdes_k28_5
bash scripts/run_tests.sh
bash scripts/run_wave.sh
```

## Clean generated files before uploading

```bash
bash scripts/clean.sh
```

This removes generated `.vvp`, `.vcd`, `.fst` and `.log` files from `build/`, preserving `build/.gitkeep`. Run `bash scripts/run_tests.sh` to regenerate simulation results and waveforms. These artifacts are also excluded by `.gitignore` and by the upload script's source-only copy.
