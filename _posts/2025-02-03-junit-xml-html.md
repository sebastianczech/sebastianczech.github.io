---
layout: post
title: Convert Junit XML reports into HTML
categories: devops, cicd
tags: devops, cicd
---

If you are searching for simple tool, which can convert Junit XML reports into HTML, then[junit2html](https://github.com/kitproj/junit2html) might be the right and simple solution. It can be installed on MacOS with simple commands:

```bash
brew tap kitproj/junit2html --custom-remote https://github.com/kitproj/junit2html
brew install junit2html
```

Then it can be installed as below to convert XML to HTML report:

```bash
junit2html < report.xml > report.html
open report.html
```
