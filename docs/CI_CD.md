# Rubia Customer app — CI/CD and environments

Package `com.rubia.user`. Written 29 Oct 2026. No passwords or tokens are kept in this file.

## 1. Where the code lives

| Place | Address |
|---|---|
| GitLab (main CI/CD attempt) | `gitlab.com/rubia-services-group/rubia-app-customer-flutter` |
| GitHub (builds and releases) | `github.com/anjaniservices369/rubia-app-customer-flutter` |

Work goes to the `develop` branch first. `git push all develop` pushes to both. Other branches: `staging` (staging builds) and `main` (releases).

## 2. Which pipeline builds what

| | GitHub Actions | GitLab CI |
|---|---|---|
| File | `.github/workflows/ci.yml`, `cd.yml` | `.gitlab-ci.yml` |
| Checks (analyze, test) | works | `verify` works |
| Debug APK | works (CI) | **fails** (see section 5) |
| Signed release build | works (`dev` run on 29 Oct 2026 succeeded) | **fails** (same cause) |

**Use GitHub Actions for app builds.** GitLab is useful for `verify` only until its runner problem is fixed.

## 3. Environments and triggers

| Trigger | Environment | Output |
|---|---|---|
| push to `develop` | `dev` | signed APK, kept 14 days |
| push to `staging` | `staging` | signed APK, kept 14 days |
| push a tag like `v1.2.3` | `production` | signed AAB + APK, GitHub Release, Google Play upload if `PLAY_SERVICE_ACCOUNT_JSON` is set |
| run by hand (Actions > CD > Run workflow) | any of the three | same as above |

## 4. Variables and secrets (names only)

**Signing (all environments).** GitHub: repository secrets. GitLab: CI/CD variables, one set for each of `dev`, `staging`, `production`.

| Name | Meaning |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | the `.jks` file as base64 (`base64 -w0 vgow.jks`) |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias (`upload`) |
| `ANDROID_KEY_PASSWORD` | key password |

- All three environments use the same keystore `jks/vgow.jks` (git-ignored; also used by the driver app). **Before the first Play release, confirm it is the upload key registered in Play Console.**
- `PLAY_SERVICE_ACCOUNT_JSON` (optional, production only): Google Play service-account JSON.

**Per environment (GitHub: Environment variables; GitLab: variable with that environment scope).**

| Name | `dev` | `staging` | `production` |
|---|---|---|---|
| `API_BASE_URL` | `https://staging.rubiaservices.org/api` | `https://staging.rubiaservices.org/api` | not set: the app's built-in `https://rubiaservices.org/api` is used |
| `ONESIGNAL_APP_ID`, `SENTRY_DSN` | optional | optional | optional |

`dev` uses the staging server because no dev API exists yet. When one does (planned `dev.rubiaservices.org`), change only the `dev` value. `dev.rubia.services` is a website, not the API.

Production on GitHub has a required reviewer (you); GitHub may not enforce this on a private repository on a free plan.

## 5. Known problem: GitLab runner and `android-37`

The app compiles against Android API 37. GitLab's build image fails with `Failed to find target with hash string 'android-37'` even after installing the platform and linking `android-37.0` to `android-37`. The same code builds on GitHub's runner. Options if GitLab builds are wanted: set `compileSdk` to 36, or use a newer build image. Not done.

## 6. Adding a secret or variable

GitLab: Settings > CI/CD > Variables (set "Environment scope"). GitHub: Settings > Secrets and variables > Actions, and Settings > Environments > `<name>` for per-environment values. Do not put passwords in files in the repository.
