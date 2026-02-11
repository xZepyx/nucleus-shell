# Contributing to nucleus-shell

Thank you for your interest in contributing. Please follow these guidelines to help us maintain high standards and efficiency.

## How to Contribute

- **Bug Reports:** Please provide clear reproduction steps, error logs, and configuration details.
- **Feature Requests:** Open an issue with a concise description and suggested use-case.
- **Pull Requests:** Keep PRs focused on a single topic. Reference issues when applicable.

### Workflow

1. Fork the repository and create your branch from `main`.
2. Ensure your code adheres to project coding style and formatting.
3. Add or update relevant documentation.
4. If applicable, add or update simple tests (if/when present).
5. Submit your pull request with a clear summary of changes.

### Code Style

* Use clear, descriptive variable and function names.
* Maintain modular, readable configuration files.
* Comment non-obvious sections.
* Note that it is requried to use `Metrics.function(value)` (read [the metrics docs](../shell/config/Metrics.md) for details) whenever you use properties like:
    - Spacing
    - Margin
    - Radius
    - Duration (Not requried for timers) 
* Also prefer using loaders for iniating modules. Especially for the modules which have a enable/disable value in the configuration. Note that this is optional but preferred as it prevents completely crashing the whole shell when one module fails to load and saves ram.

# Collaborating Workflow

This section describes **how collaborators should work on this repository**.

> [!IMPORTANT]
> * All work is done in feature branches; **direct pushes to `main` are not allowed**.

---

## 1. Branch Naming Convention

All branches created by collaborators **must follow this structure**:

```
collaborator/<username>/<type>/<short-description>
```

### Rules:

| Segment               | Description                                     | Example                       |
| --------------------- | ----------------------------------------------- | ----------------------------- |
| `collaborator`        | Always present                                  | collaborator                  |
| `<username>`          | Your GitHub username                            | alice                         |
| `<type>`              | Type of work                                    | feat, chore, improvement, fix |
| `<short-description>` | Short, descriptive name of your work, 1-2 words | settings-ui, typo-fix         |

**Example branch names:**

```
collaborator/alice/feat/settings-ui
collaborator/bob/fix/sidebar-color
collaborator/john/improvement/color-gen
```

> This ensures all branches are organized and easy to identify.

---

## 2. Local Setup (First Time)

Clone the repository if you haven’t already:

```bash
git clone git@github.com:xZepyx/nucleus-shell.git
cd nucleus-shell
```

Set `main` as the default branch:

```bash
git checkout main
git pull origin main
```

---

## 3. Creating a New Branch

Create a new branch from `main` using the naming convention:

```bash
git checkout -b collaborator/<your-username>/<type>/<short-description>
```

**Example:**

```bash
git checkout -b collaborator/alice/feat/settings-ui
```

---

## 4. Work and Commit

Do your changes, then add and commit:

```bash
git add .
git commit -m "feat: add UI for settings panel"
```

---

## 5. Push Your Branch

Push the branch to GitHub:

```bash
git push origin collaborator/<your-username>/<type>/<short-description>
```

**Example:**

```bash
git push origin collaborator/alice/feat/settings-ui
```

---

## 6. Open a Pull Request (PR)

1. Go to the repository on GitHub
2. Click **Compare & pull request**
3. Ensure the base branch is `main`
4. Submit the PR for review

> **Do not merge the PR yourself.** Only the repository owner merges into `main`.

---

## 7. Branch Cleanup

After your PR is merged:

1. GitHub will allow you to delete the branch (or auto-delete if enabled)
2. Delete your local branch:

```bash
git checkout main
git pull origin main
git branch -d collaborator/<your-username>/<type>/<short-description>
git fetch --prune
```

---

## 8. Keeping Your Branch Updated (Optional)

If `main` receives new commits while your branch is in progress, update your branch:

```bash
git checkout collaborator/<your-username>/<type>/<short-description>
git fetch origin
git merge origin/main
```

> Resolve any conflicts, then push again before opening/updating the PR.

---

**Summary of workflow**

1. Always branch from `main`
2. Follow `collaborator/<username>/<type>/<short-description>` naming, `<short-description>` must be 1–2 words
3. Work locally, commit, and push to your branch
4. Open PR to `main` for review
5. Branch is deleted after merge
6. `main` remains protected and clean

## Community Standards

- Maintain a professional, respectful tone.
- See the [Code of Conduct](CODE_OF_CONDUCT.md).

Thank you for contributing!


