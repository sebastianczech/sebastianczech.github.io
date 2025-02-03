---
layout: post
title: Convert JUnit XML reports into HTML
categories: devops, cicd
tags: devops, cicd
---

If you are searching for a simple tool that can convert JUnit XML reports into HTML, then [junit2html](https://github.com/kitproj/junit2html) might be the right and simple solution. It can be installed on macOS with the following commands:

```bash
brew tap kitproj/junit2html --custom-remote https://github.com/kitproj/junit2html
brew install junit2html
```

Then it can be used as shown below to convert an XML report to an HTML report:

```bash
junit2html < report.xml > report.html
open report.html
```
