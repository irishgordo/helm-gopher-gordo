resource "harvester_clusternetwork" "cluster-vlan" {
  name = var.DEPLOYMENT_NETWORK_CONFIG_NAME
}

resource "harvester_vlanconfig" "resources-vlan-nc-setup" {
  name = var.DEPLOYMENT_NETWORK_CONFIG_VLAN

  cluster_network_name = harvester_clusternetwork.cluster-vlan.name

  uplink {
    nics = [
      "eno2",
      "eno3"
    ]

    bond_mode = "active-backup"
  }
}

resource "harvester_network" "mgmt-vlan-minio" {
  name      = var.MINIOSERVER_NET_NAME
  namespace = var.MINIOSERVER_NAMESPACE_DESIRED

  vlan_id = var.MINIOSERVER_VM_NETWORK_VLAN

  route_mode           = "auto"
  route_dhcp_server_ip = ""

  cluster_network_name = harvester_clusternetwork.cluster-vlan.name
}

resource "harvester_image" "minio-img" {
  depends_on    = [harvester_network.mgmt-vlan-minio, harvester_vlanconfig.resources-vlan-nc-setup, harvester_clusternetwork.cluster-vlan]
  name         = var.MINIOSERVER_CLOUD_IMG_NAME
  namespace    = var.MINIOSERVER_NAMESPACE_DESIRED
  display_name = var.MINIOSERVER_CLOUD_IMG_DISPLAYNAME
  source_type  = "download"
  url          = var.MINIOSERVER_CLOUD_IMG_URL
}

resource "harvester_cloudinit_secret" "cloud-config-minio" {
  name      = "cloud-config-minio"
  namespace = var.MINIOSERVER_NAMESPACE_DESIRED
  user_data = <<-EOF
      #cloud-config
      password: ${var.MINIOSERVER_VM_PW}
      chpasswd:
        expire: false
      ssh_pwauth: true
      manage_etc_hosts: true
      package_update: true
      packages:
        - qemu-guest-agent
        - apt-transport-https
        - neovim
        - wget
        - ca-certificates
        - python3
        - python3-pip
        - jq
        - curl
        - gnupg-agent
        - gnupg
        - lsb-release
        - htop
        - parted
        - fdisk
        - gnupg2
        - neovim
        - software-properties-common
        - coreutils
        - sshpass
        - tmux
        - net-tools
        - unzip
      runcmd:
        - - systemctl
          - enable
          - --now
          - qemu-guest-agent.service
    EOF

  network_data = <<-EOF
      network:
        version: 2
        ethernets:
          enp1s0:
            dhcp4: true
            nameservers:
              addresses: [1.1.1.1]
  EOF

}

resource "harvester_virtualmachine" "minio-vm" {
  depends_on = [
    harvester_cloudinit_secret.cloud-config-minio, harvester_image.minio-img, harvester_network.mgmt-vlan-minio
  ]
  name                 = var.MINIOSERVER_NAME
  namespace            = var.MINIOSERVER_NAMESPACE_DESIRED
  restart_after_update = true

  description = "MINIO VM for Integrations of Harvester"
  tags = {
    ssh-user                      = "ubuntu"
    ssh-user-pw                   = var.MINIOSERVER_VM_PW
    minio_config_disk_size        = var.MINIOSERVER_CONFIG_DISK_SIZE_IN_G
    minio_config_disk_device      = var.MINIOSERVER_CONFIG_DISK_DEVICE
    minio_config_web_console_port = var.MINIOSERVER_CONFIG_WEB_CONSOLE_PORT
    minio_config_api_port         = var.MINIOSERVER_CONFIG_API_PORT
    minio_config_https_enabled    = var.MINIOSERVER_CONFIG_HTTPS_ENABLED
    minio_config_user             = var.MINIOSERVER_CONFIG_USER
    minio_config_password         = var.MINIOSERVER_CONFIG_PASSWORD
    minio_config_region           = var.MINIOSERVER_CONFIG_REGION
    minio_config_bucket_name      = var.MINIOSERVER_CONFIG_BUCKET_NAME
    minio_config_access_key       = var.MINIOSERVER_CONFIG_ACCESS_KEY
    minio_config_secret_key       = var.MINIOSERVER_CONFIG_SECRET_KEY
  }

  connection {
    type     = "ssh"
    host     = self.network_interface[0].ip_address
    user     = "ubuntu"
    password = var.MINIOSERVER_VM_PW
  }

  # IMPORTANT: We need to wait for cloud-init on Harvester VMs to complete before running Ansible
  # Additionally, cloud-init shouldn't take too long, ideally most configuration should be done in Ansible for better levels of control
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }

  cpu    = var.MINIOSERVER_DESIRED_CPU
  memory = var.MINIOSERVER_DESIRED_MEM

  efi         = true
  secure_boot = false

  run_strategy = "RerunOnFailure"
  hostname     = var.MINIOSERVER_NAME
  machine_type = "q35"

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
    model          = "virtio"
    type           = "bridge"
    network_name   = harvester_network.mgmt-vlan-minio.id
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = var.MINIOSERVER_DISK_SIZE
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.minio-img.id
    auto_delete = true
  }


  disk {
    name = var.MINIOSERVER_STORAGE_DISK_NAME
    type = "disk"
    size = var.MINIOSERVER_STORAGE_DISK_SIZE
    bus  = "virtio"

    auto_delete = true
  }

  cloudinit {
    user_data_secret_name    = harvester_cloudinit_secret.cloud-config-minio.name
    network_data_secret_name = harvester_cloudinit_secret.cloud-config-minio.name
  }
}

resource "ansible_playbook" "minio-vm-ansible-playbook" {
  depends_on = [
    harvester_virtualmachine.minio-vm
  ]

  playbook = "ansible/minio-server.yaml"

  name = "${var.MINIOSERVER_NAME} ansible_password=${var.MINIOSERVER_VM_PW} ansible_host=${harvester_virtualmachine.minio-vm.network_interface[0].ip_address} ansible_sudo_pass=${var.MINIOSERVER_VM_PW} ansible_ssh_user=ubuntu ansible_ssh_common_args='-o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null' ansible_ssh_extra_args='-o StrictHostKeyChecking=no' ANSIBLE_TIMEOUT=180" # name of the host to use for inventory configuration


  check_mode = false
  diff_mode  = false
  var_files  = var.MINIOSERVER_ANSIBLE_VAR_FILES_PATH
  # allows for us to be able to see what failed... ?
  ignore_playbook_failure = false

  # Connection configuration and other vars
  extra_vars = {
    minio_server_ip                   = harvester_virtualmachine.minio-vm.network_interface[0].ip_address
    host_vm_name                      = var.MINIOSERVER_NAME
    minio_config_disk_size            = var.MINIOSERVER_CONFIG_DISK_SIZE_IN_G
    minio_config_disk_device          = var.MINIOSERVER_CONFIG_DISK_DEVICE
    minio_config_mount_point          = var.MINIOSERVER_CONFIG_DISK_MOUNT_POINT
    minio_config_mount_point_folder   = var.MINIOSERVER_CONFIG_DISK_MOUNT_POINT_FOLDER
    minio_config_web_console_port     = var.MINIOSERVER_CONFIG_WEB_CONSOLE_PORT
    minio_config_api_port             = var.MINIOSERVER_CONFIG_API_PORT
    minio_config_https_enabled        = var.MINIOSERVER_CONFIG_HTTPS_ENABLED
    minio_config_user                 = var.MINIOSERVER_CONFIG_USER
    minio_config_password             = var.MINIOSERVER_CONFIG_PASSWORD
    minio_config_region               = var.MINIOSERVER_CONFIG_REGION
    minio_config_bucket_name          = var.MINIOSERVER_CONFIG_BUCKET_NAME
    minio_config_client_mc_binary_url = var.MINIOSERVER_CONFIG_CLI_CLIENT_BINARY_URL
    minio_config_certgen_binary_url   = var.MINIOSERVER_CONFIG_CERTGEN_BINARY_URL
    minio_config_access_key           = var.MINIOSERVER_CONFIG_ACCESS_KEY
    minio_config_secret_key           = var.MINIOSERVER_CONFIG_SECRET_KEY
    minio_binary_url                  = var.MINIOSERVER_CONFIG_MINIO_BINARY_URL
  }

  replayable = false
  verbosity  = 6
}

# build out the harvester network and resources as well for RKE2

resource "harvester_network" "mgmt-vlan-jammy" {
  depends_on = [ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  name       = "jmy-vlan-rke2"
  namespace  = "default"

  vlan_id = 1

  route_mode           = "auto"
  route_dhcp_server_ip = ""

  cluster_network_name = harvester_clusternetwork.cluster-vlan.name
}

resource "harvester_image" "rke2-jammy-img" {
  depends_on   = [harvester_network.mgmt-vlan-jammy, ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  name         = var.vm_image_name
  namespace    = "default"
  display_name = var.vm_image_name
  source_type  = "download"
  url          = var.vm_image_url
}

# build out the rancher content rke2 stuff

# pending: https://github.com/harvester/terraform-provider-harvester/pull/78
# NOTE: Currently YOU MUST Have your Harvester Cluster ALREADY Imported into Rancher
# or else this will fail entirely
data "rancher2_cluster_v2" "harvester141" {
  name = var.name_of_harvester_cluster_imported_already
}

# Create a new Cloud Credential for an imported Harvester cluster
resource "rancher2_cloud_credential" "cc-harvester141" {
  depends_on = [harvester_network.mgmt-vlan-jammy, harvester_image.rke2-jammy-img, ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  name       = "cc-harvester141"
  harvester_credential_config {
    cluster_id         = data.rancher2_cluster_v2.harvester141.cluster_v1_id
    cluster_type       = "imported"
    kubeconfig_content = data.rancher2_cluster_v2.harvester141.kube_config
  }
}


data "template_file" "userdata" {
  template = <<EOF
#cloud-config
password: ${var.rke2_vm_password}
chpasswd:
  expire: false
ssh_pwauth: true
package_update: true
packages:
  - qemu-guest-agent
  - iptables
runcmd:
  - - systemctl
    - enable
    - '--now'
    - qemu-guest-agent.service
EOF
}

# Create a new rancher2 machine config v2 using harvester node_driver
resource "rancher2_machine_config_v2" "rke2-machine" {
  depends_on    = [harvester_network.mgmt-vlan-jammy, harvester_image.rke2-jammy-img, ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  generate_name = "rke2-machine"
  harvester_config {
    vm_namespace = "default"
    cpu_count    = var.rke2_pool_node_cpu
    memory_size  = var.rke2_pool_node_mem

    disk_info = <<EOF
{
    "disks": [{
        "imageName": "${harvester_image.rke2-jammy-img.id}",
        "size": ${var.rke2_pool_node_disk_size},
        "bootOrder": 1
    }]
}
EOF

    network_info = <<EOF
{
    "interfaces": [{
        "networkName": "default/${harvester_network.mgmt-vlan-jammy.name}"
    }]
}
EOF
    ssh_user     = var.rke2_vm_ssh_user
    user_data    = base64encode(data.template_file.userdata.rendered)
  }
}


resource "rancher2_cloud_credential" "minio-cc" {
  name        = "minio-cc"
  depends_on  = [harvester_network.mgmt-vlan-jammy, harvester_image.rke2-jammy-img, ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  description = "minio credentials"
  s3_credential_config {
    access_key              = var.MINIOSERVER_CONFIG_ACCESS_KEY
    secret_key              = var.MINIOSERVER_CONFIG_SECRET_KEY
    default_bucket          = var.MINIOSERVER_CONFIG_BUCKET_NAME
    default_skip_ssl_verify = true
    default_region          = var.MINIOSERVER_CONFIG_REGION
    default_endpoint        = "${harvester_virtualmachine.minio-vm.network_interface[0].ip_address}:${var.MINIOSERVER_CONFIG_API_PORT}"
  }
}

# in this example, x-ref the cloud-provider-config, but was generated w/ ./harvester-deployment-prereqs/generate_addon.sh test-rke2 default
# then the name section is set to that
resource "rancher2_cluster_v2" "rke2-terraform" {
  depends_on         = [rancher2_cloud_credential.minio-cc, harvester_network.mgmt-vlan-jammy, harvester_image.rke2-jammy-img, ansible_playbook.minio-vm-ansible-playbook, harvester_virtualmachine.minio-vm]
  name               = "test-rke2-default-default"
  kubernetes_version = var.rke2_k8s_version
  rke_config {
    machine_pools {
      name                           = "pool1"
      cloud_credential_secret_name   = rancher2_cloud_credential.cc-harvester141.id
      control_plane_role             = true
      etcd_role                      = true
      worker_role                    = true
      quantity                       = 3
      unhealthy_node_timeout_seconds = 0
      machine_config {
        kind = rancher2_machine_config_v2.rke2-machine.kind
        name = rancher2_machine_config_v2.rke2-machine.name
      }
    }

    # !NOTE!: VERY IMPORTANT ABOUT MACHINE_SELECTOR_CONFIG WITH HARVESTER
    # in order to get the value for "cloud-provider-config" you must do the following
    # 1. on a main node of Harvester (not worker), get `/etc/rancher/rke2/rke2.yaml` (REMEMBER TO REPLACE LOCALHOST/LOOPBACK WITH YOUR HARVESTER VIP IPV4) and stash somewhere
    # 2. take wherever you've stashed it and point your KUBECONFIG var to it like, `export KUBECONFIG=~/.kube/myharvester.yaml`
    # 3. grab the "raw" of this: https://github.com/harvester/cloud-provider-harvester/blob/master/deploy/generate_addon.sh
    # 4. once you've grabbed the raw, make it executable somewhere like `chmod +x generate_addon.sh`
    # 5. then using the KUBECONFIG execute the script with something like `./generate_addon.sh <the name of the rancher2_cluster_v2.name, whatever you're going to be naming it> <default or another namespace>`
    # 6. Then inside the `EOF` flags put the entire "cloud config" that is output, don't worry abou the cloud-init stuff
    # 7. Make sure that the rancher2_cluster_v2.name does MATCH EXACTLY to what is output from the Cloud Config Output dump's `context[0].name` very important
    # 8. Then if all that is in place you should be good to go, this is a needed effort to get Harvester Cloud Provider working correctly with RKE2 otherwise it's just going to fall flat on it's face and you'll see nothing but taints on the node in RKE2 from Harvester Cloud Provider if this is setup incorrectly
    machine_selector_config {
      config = yamlencode({
        cloud-provider-config = file("${path.module}/cloud-provider-config.yaml")
        cloud-provider-name   = "harvester"
      })
    }

    machine_global_config = <<EOF
cni: "calico"
disable-kube-proxy: false
etcd-expose-metrics: false
EOF

    upgrade_strategy {
      control_plane_concurrency = "1"
      worker_concurrency        = "1"
    }

    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention     = 5
      s3_config {
        bucket                = var.MINIOSERVER_CONFIG_BUCKET_NAME
        endpoint              = "${harvester_virtualmachine.minio-vm.network_interface[0].ip_address}:${var.MINIOSERVER_CONFIG_API_PORT}"
        cloud_credential_name = rancher2_cloud_credential.minio-cc.id
        skip_ssl_verify       = true
        region                = var.MINIOSERVER_CONFIG_REGION
      }
    }
    chart_values = <<EOF
harvester-cloud-provider:
  cloudConfigPath: /var/lib/rancher/rke2/etc/config-files/cloud-provider-config
  clusterName: rke2-terraform
EOF
  }
}