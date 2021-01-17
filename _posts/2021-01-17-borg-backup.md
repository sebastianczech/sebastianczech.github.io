---
layout: post
title: Borg backup
categories: backup
tags: backup
---

[BorgBackup](https://borgbackup.readthedocs.io/en/stable/) is a deduplicating backup program. Optionally, it supports compression and authenticated encryption.

The main goal of Borg is to provide an efficient and secure way to backup data. The data deduplication technique used makes Borg suitable for daily backups since only changes are stored. The authenticated encryption technique makes it suitable for backups to not fully trusted targets.