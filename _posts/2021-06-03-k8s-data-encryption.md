---
layout: post
title: K8s tips - generating a data encryption config for Kubernetes
categories: devops
tags: devops, kubernetes
---

```
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml << EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

scp encryption-config.yaml cloud_user@<controller 1 public ip>:~/
scp encryption-config.yaml cloud_user@<controller 2 public ip>:~/
```
