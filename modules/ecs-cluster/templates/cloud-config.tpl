#cloud-config
# vim: syntax=yaml

package_upgrade: true

write_files:
  - path: /etc/ecs/ecs.config
    owner: root:root
    permissions: 0644
    content: |
      # ecs.config
      ECS_CLUSTER=${ecs_cluster}
      ECS_ENABLE_TASK_IAM_ROLE=true
      # Expouse various container metadata within ECS task containers
      ECS_ENABLE_CONTAINER_METADATA=true
  - path: /etc/resolv.dnsmasq.conf
    owner: root:root
    permissions: 0644
    content: |
      ${nameservers}
      nameserver 169.254.169.253
  - path: /etc/dnsmasq.d/custom
    owner: root:root
    permissions: 0644
    content: |
      resolv-file=/etc/resolv.dnsmasq.conf
packages:
  - build-essential
  - curl
  - gnupg2
  - htop
  - git-core
  - apt-transport-https
  - ca-certificates
  - vim-nox
  - tmux
  - rsync
  - keychain
  - awscli
  - nfs-utils
  - dnsmasq
  - bind-utils

output: { all : '| tee -a /var/log/cloud-init-output.log' }

final_message: "The system is finally up, after $UPTIME seconds"
