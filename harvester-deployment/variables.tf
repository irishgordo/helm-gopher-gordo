variable "MINIOSERVER_VM_PW" {
  description = "the password for the integration vm minio-server"
  default     = "ubuntupw"
  type        = string
  sensitive   = true
}

variable "MINIOSERVER_NAMESPACE_DESIRED" {
  type        = string
  description = "the namespace for all things related to minio server"
  sensitive   = false
  default     = "default"
}

variable "DEPLOYMENT_NETWORK_CONFIG_NAME"{
    description = "the cluster network config name"
    type        = string
    sensitive   = false
    default     = "basenet"
}

variable "DEPLOYMENT_NETWORK_CONFIG_VLAN"{
    description = "the cluster network config vlan name"
    type        = string
    sensitive   = false
    default     = "basenc"
}

variable "MINIOSERVER_NET_NAME" {
  description = "the network for minio"
  type        = string
  sensitive   = false
  default     = "minio-base"
}

variable "MINIOSERVER_VM_NETWORK_VLAN" {
  description = "the base network"
  type        = number
  sensitive   = false
  default     = 1
}

variable "MINIOSERVER_VM_NETWORK_VM_NET_NAME" {
  description = "the network to use for minio off mgmt"
  type        = string
  sensitive   = false
  default     = "mgmt"
}

# TODO: check other distros besides ubuntu, most integrations sticking to focal fossa for now
variable "MINIOSERVER_CLOUD_IMG_NAME" {
  description = "the cloud image name, not display name"
  type        = string
  sensitive   = false
  default     = "ubuntu-focal-minio"
}

variable "MINIOSERVER_CLOUD_IMG_URL" {
  description = "the url to download the cloud image"
  type        = string
  sensitive   = false
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "MINIOSERVER_CLOUD_IMG_DISPLAYNAME" {
  description = "the cloud img display name"
  type        = string
  sensitive   = false
  default     = "ubuntu-focal-minio"
}

variable "MINIOSERVER_NAME" {
  type        = string
  description = "vm name"
  default     = "minio-server-vm"
  sensitive   = false
}

variable "MINIOSERVER_DESIRED_CPU" {
  type        = number
  default     = 2
  sensitive   = false
  description = "cpu for minio-server"
}

variable "MINIOSERVER_DESIRED_MEM" {
  description = "amount of Gi for the minio-server"
  default     = "4Gi"
  sensitive   = false
  type        = string
}

variable "MINIOSERVER_DISK_SIZE" {
  type        = string
  default     = "10Gi"
  description = "the Gi amount of the root disk size for minio-server vm"
  sensitive   = false
}

variable "MINIOSERVER_ANSIBLE_VAR_FILES_PATH" {
  type        = list(string)
  default     = ["ansible/minio-server-variables.yaml"]
  sensitive   = false
  description = "the list of strings that point to minio-server variable files"
}

variable "MINIOSERVER_STORAGE_DISK_SIZE" {
  type        = string
  description = "the disk size desired that backs all minio buckets that will be created, as this is a single-node single-disk setup"
  sensitive   = false
  default     = "20Gi"
}

variable "MINIOSERVER_STORAGE_DISK_NAME" {
  type        = string
  description = "the name of the disk to build for the harvester_virtualmachine that is the disk that backs all buckets created on the single minio node"
  default     = "miniodisk"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_DISK_SIZE_IN_G" {
  description = "minio server disk size in `G`, for Ansible auto disk formatting"
  default     = "20G"
  sensitive   = false
  type        = string
}

variable "MINIOSERVER_CONFIG_DISK_DEVICE" {
  description = "minio server disk device name eg: 'vdb' for Ansible to autoformat"
  default     = "vdb"
  type        = string
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_DISK_MOUNT_POINT" {
  description = "minio server config mount point, where the vm mounts the disk"
  default     = "/mnt/minio-data"
  type        = string
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_DISK_MOUNT_POINT_FOLDER" {
  description = "folder name to build on mount point for storage disk"
  type        = string
  sensitive   = false
  default     = "data"
}

variable "MINIOSERVER_CONFIG_WEB_CONSOLE_PORT" {
  type        = number
  default     = 9001
  description = "web console port for minio"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_API_PORT" {
  type        = number
  default     = 9000
  description = "api port for minio"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_HTTPS_ENABLED" {
  type        = bool
  default     = true
  description = "whether to enable https or not for minio"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_USER" {
  type        = string
  default     = "minioadmin"
  description = "user for minio login to be built"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_PASSWORD" {
  type        = string
  default     = "minioadmin"
  description = "password for minio to be built"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_REGION" {
  type        = string
  default     = "sample-test-1"
  description = "minio region"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_CLI_CLIENT_BINARY_URL" {
  type        = string
  default     = "https://dl.min.io/client/mc/release/linux-amd64/mc"
  description = "the binary url to fetch the minio client binary url, mc, could be versioned if desired"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_BUCKET_NAME" {
  type        = string
  default     = "generic-bucket"
  description = "the minio bucket to be automatically built for harvester vm backups"
  sensitive   = false
}

variable "MINIOSERVER_CONFIG_MINIO_BINARY_URL" {
  default     = "https://dl.min.io/server/minio/release/linux-amd64/minio"
  description = "the minio binary to use"
  sensitive   = false
  type        = string
}

variable "MINIOSERVER_CONFIG_CERTGEN_BINARY_URL" {
  default     = "https://github.com/minio/certgen/releases/download/v1.2.1/certgen-linux-amd64"
  description = "the minio certgen binary to use, could be versioned, uses v1.2.1 currently, certgen is used to quickly stand up certs for https"
  sensitive   = false
  type        = string
}

variable "MINIOSERVER_CONFIG_ACCESS_KEY" {
  default     = "myuserserviceaccount"
  sensitive   = false
  type        = string
  description = "the access key that we build automatically for the minio instance for Harvester to use"
}
variable "MINIOSERVER_CONFIG_SECRET_KEY" {
  default     = "myuserserviceaccountsecret"
  type        = string
  sensitive   = false
  description = "the secret key that gets built for minio instance for Harvester to use automatically"
}


variable "api_url" {
  description = "api url for rancher"
  sensitive   = false
  type        = string
  default     = "https://rancher.192.168.104.126.sslip.io/v3"
}

# https://docs.harvesterhci.io/v1.4/rancher/rancher-terraform/

variable "api_access_key" {
  description = "bearer token first portion for rancher"
  sensitive   = true
  type        = string
}

variable "api_secret_key" {
  description = "bearer token second portion for rancher"
  sensitive   = true
  type        = string
}


variable "rke2_vm_ssh_user" {
  description = "value for the ssh user for the rke2 vm"
  type        = string
  sensitive   = false
  default     = "ubuntu"
}

variable "rke2_vm_password" {
  type        = string
  sensitive   = false
  default     = "password"
  description = "the password for the rke2 vm"
}

variable "name_of_harvester_cluster_imported_already" {
  type        = string
  description = "the name of the harvester cluster that is already imported"
  sensitive   = false
  default     = "harvester141"

}

variable "vm_image_url" {
  type        = string
  description = "the url to download the cloud image"
  sensitive   = false
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "vm_image_name" {
  type        = string
  description = "the cloud image name, not display name"
  sensitive   = false
  default     = "rke2-jammy-img"
}

variable "rke2_k8s_version" {
  description = "rke2 k8s version"
  default     = "v1.29.12+rke2r1"
  sensitive   = false
  type        = string
}

variable "rke2_pool_node_cpu" {
  type        = string
  description = "the cpu for the rke2 pool node"
  default     = "4"
  sensitive   = false
}

variable "rke2_pool_node_mem" {
  type        = string
  description = "the mem for the rke2 pool node"
  default     = "8"
  sensitive   = false
}

variable "rke2_pool_node_disk_size" {
  type        = number
  description = "the disk size for the rke2 node"
  default     = 40
  sensitive   = false
}