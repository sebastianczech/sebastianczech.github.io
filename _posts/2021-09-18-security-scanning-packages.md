---
layout: post
title: Security scanning tools for Python & R
categories: devops
tags: devops
---

OSS index is free catalogue of open source components. Using public REST API it's possible to [scan your dependencies](https://ossindex.sonatype.org/#integrations-tab-pane). Using Docker we can easily check our packages.

For R can be used [oysteR](https://github.com/sonatype-nexus-community/oysteR):

```bash
more Dockerfile
```
```Dockerfile
FROM centos:7
RUN yum install -y epel-release
RUN yum install -y R
RUN yum install -y libcurl-devel openssl-devel
COPY audit_packages.R /usr/local/src/audit_packages.R
COPY install_packages.R /usr/local/src/install_packages.R
RUN chmod +x /usr/local/src/install_packages.R && R -f /usr/local/src/install_packages.R
CMD ["R", "-f", "/usr/local/src/audit_packages.R"]
```
```bash
more install_packages.R
```
```R
print("Install R packages")
install.packages("jsonlite", repos = "https://cran.r-project.org")
install.packages("curl", repos = "https://cran.r-project.org")
install.packages("jsonlite", repos = "https://cran.r-project.org")
install.packages("openssl", repos = "https://cran.r-project.org")
install.packages("https://github.com/r-lib/httr/archive/refs/tags/v1.4.2.tar.gz", repos = NULL, type = 'file')
install.packages("oysteR", repos = "https://cran.r-project.org")
```
```bash
more audit_packages.R
```
```R
print("Audit R packages")
library("oysteR")
audit = audit_installed_r_pkgs()
get_vulnerabilities(audit)
```
```bash
docker build --rm -t centos-r-image .
docker run --name centos-r-container --rm -it centos-r-image
```

For Python can be used [ossaudit](https://github.com/illikainen/ossaudit):

```bash
more Dockerfile
```
```Dockerfile
FROM centos:7
RUN yum install -y python3 python-pip
COPY install_packages.bash /usr/local/src/install_packages.bash
RUN chmod +x /usr/local/src/install_packages.bash && /usr/local/src/install_packages.bash
COPY audit_packages.bash /usr/local/src/audit_packages.bash
RUN chmod +x /usr/local/src/audit_packages.bash
CMD ["/usr/local/src/audit_packages.bash"]
```
```bash
more install_packages.bash
```
```bash
#!/bin/bash
echo "Install Python packages"
python3 -m pip install --upgrade pip
python3 -m pip install Flask
python3 -m pip install ossaudit
```
```bash
more audit_packages.bash
```
```bash
#!/bin/bash
echo -e "Show Python installed packages:\n"
python3 -m pip list --format=columns
echo -e "\nAudit Python packages:\n"
LC_ALL=en_US
export LC_ALL
ossaudit -i
```
```bash
docker build --rm -t centos-python-image .
docker run --name centos-python-container --rm -it centos-python-image
```