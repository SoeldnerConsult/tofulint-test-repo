# TofuLint CI/CD Integration Demo


## Project Overview

This repository serves as a practical demonstration of integrating **[TofuLint](https://github.com/SoeldnerConsult/tofulint)** into a standard GitHub Actions workflow.

It showcases two distinct CI/CD pipeline strategies:

1.  **Simple Check:** Fails the pull request/push check if any linter errors are found, enforcing a strict linting policy.
2.  **Security Reporting:** Passes the check but reports all linter findings directly to the GitHub **Security** tab using the SARIF format, providing a less intrusive, dedicated view for code quality issues.

The repository contains example `.tf` and `.tofu` files designed to trigger TofuLint warnings and errors, allowing you to observe the pipeline behavior.

## What is TofuLint?

**[TofuLint](https://github.com/SoeldnerConsult/tofulint)** is an experimental fork of TFLint, adapted to work with **OpenTofu** (an open-source alternative to Terraform). It helps ensure the quality, correctness, and adherence to best practices in your Infrastructure-as-Code (IaC) files by:

  * Detecting potential errors (e.g., invalid cloud resource types).
  * Warning about deprecated syntax and unused declarations.
  * Enforcing community and custom coding conventions.

## GitHub Actions Workflows

This project configures two separate workflows located in the `.github/workflows/` directory.

### 1\. Simple TofuLint Check

  * **File:** `.github/workflows/simple-tofulint-check.yml`
  * **Purpose:** To enforce a strict linting gate. If TofuLint finds any issues (by default, *error* severity issues will cause a non-zero exit code), the entire GitHub Actions job will **fail**.
  * **TofuLint Command:**
    ```bash
    tofulint --init
    tofulint --recursive
    ```

| Step | Description | Key Configuration Detail |
| :--- | :--- | :--- |
| **Install TofuLint** | Downloads and installs the `tofulint` binary. | Uses the recommended `install_linux.sh` script. |
| **Configure Plugin** | Creates the `.tofulint.hcl` file. | **Crucial Workaround** for the known bug that prevents the `opentofu` plugin from installing automatically. |
| **Run TofuLint** | Executes the linter. | Runs `tofulint --recursive` to check all subdirectories. **Fails on any issue** that triggers a non-zero exit code. |

### 2\. TofuLint Security Reporting (SARIF)

  * **File:** `.github/workflows/tofulint-security-reporting.yml`
  * **Purpose:** To report linter findings to a dedicated security dashboard without necessarily failing the main branch protection checks.
  * **TofuLint Commands (with fix):**
    ```bash
    tofulint --init
    tofulint --recursive --format=sarif --force > tofulint-results.sarif
    ```

| Step | Description | Key Configuration Detail |
| :--- | :--- | :--- |
| **Install TofuLint** | Downloads and installs the `tofulint` binary. | Uses the recommended `install_linux.sh` script. |
| **Configure Plugin** | Creates the `.tofulint.hcl` file. | **Crucial Workaround** for the known bug that prevents the `opentofu` plugin from installing automatically. |
| **Run TofuLint** | Executes the linter. | Runs `tofulint --recursive` to check all subdirectories. **Fails on any issue** that triggers a non-zero exit code. |
| **Upload SARIF Report** | Uploads the results to GitHub. | Uses the `github/codeql-action/upload-sarif@v3` action to publish the findings to your repository's **Security \> Code Scanning** tab. |

## TofuLint Configuration (`.tofulint.hcl/.tflint.hcl`)

Due to a known issue in TofuLint (described in the official documentation), the pre-bundled `opentofu` plugin fails to initialize automatically.

Both pipelines include a step to dynamically create the necessary configuration file (`.tofulint.hcl`) to manually enable the plugin, ensuring the linter can run correctly.

```hcl
plugin "opentofu" {
  enabled = true
  version = "0.0.9"
  source = "github.com/SoeldnerConsult/tofulint-ruleset-opentofu"
}
```

If you wish to add more plugins (e.g., for AWS or GCP) or set custom rules, you should commit a permanent `.tofulint.hcl` file to the root of this repository.