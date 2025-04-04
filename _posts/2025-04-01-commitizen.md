---
layout: post
title: Commitizen
categories: git
tags: devops, git
---

If you're looking for a tool that enforces a specific way of committing changes to `git`, such as following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard, then the tool [commitizen](https://commitizen-tools.github.io/commitizen/) seems to be one of the strong candidates. Installation is straightforward, for example, on `macOS`:

```bash
brew install commitizen
```

The next step is to configure `commitizen`:

```bash
cz init
```

and then use it:

```bash
cz commit # or: cz commit -a
```

