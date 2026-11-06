# ROSSetupTrail

An Ubuntu 24.04 development environment packaged as a Docker image, built by
GitHub Actions and published to the GitHub Container Registry (GHCR).

## What's in the image

- Ubuntu 24.04 LTS
- Common tools: `git`, `curl`, `wget`, `build-essential`, `python3` (+ `pip`, `venv`), `vim`, `nano`, `htop`
- Non-root user `dev` (UID 1000) with passwordless `sudo`
- Working directory: `/home/dev/workspace`

## Use the published image

```bash
docker pull ghcr.io/swagat2001in/rossetuptrail:latest
docker run -it --rm -v "$PWD":/home/dev/workspace ghcr.io/swagat2001in/rossetuptrail:latest
```

> The package is private by default. To pull without logging in, make it public under
> GitHub → your profile → Packages → `rossetuptrail` → Package settings → Change visibility.
> Otherwise log in first: `echo <PAT> | docker login ghcr.io -u swagat2001in --password-stdin`
> (the token needs the `read:packages` scope).

## Build locally

```bash
docker build -t rossetuptrail .
docker run -it --rm rossetuptrail
```

Use a different Ubuntu-based base image, for example ROS 2 Jazzy:

```bash
docker build --build-arg BASE_IMAGE=ros:jazzy-ros-base -t rossetuptrail:jazzy .
```

## How publishing works

`.github/workflows/docker-publish.yml` runs on every push, on version tags (`v*`), on
pull requests to `main`, and on manual dispatch:

| Event                     | Tags pushed to `ghcr.io/swagat2001in/rossetuptrail` |
|---------------------------|-----------------------------------------------------|
| Push to default branch    | `latest`, `<branch>`, `sha-<short>`                 |
| Push to other branch      | `<branch>`, `sha-<short>`                           |
| Tag `v1.2.3`              | `1.2.3`, `sha-<short>`                              |
| Pull request              | built only, not pushed                              |

Authentication uses the built-in `GITHUB_TOKEN`, so no secrets need to be configured.
