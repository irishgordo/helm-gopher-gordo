output "general_info" {
  value = nonsensitive(<<-EOF
        Hello!

        This is the information output!

        This is MinIO Output Content :) !

        IP Address: ${harvester_virtualmachine.minio-vm.network_interface[0].ip_address}
        Username For VM: ubuntu
        Password For VM: ${var.MINIOSERVER_VM_PW}
        Web Console Port: ${var.MINIOSERVER_CONFIG_WEB_CONSOLE_PORT}
        API Port: ${var.MINIOSERVER_CONFIG_API_PORT}
        HTTPS Enabled: ${var.MINIOSERVER_CONFIG_HTTPS_ENABLED}
        Region: ${var.MINIOSERVER_CONFIG_REGION}
        Disk Mount Point: ${var.MINIOSERVER_CONFIG_DISK_MOUNT_POINT}
        MinIO Web User Name: ${var.MINIOSERVER_CONFIG_USER}
        MinIO Web Password: ${var.MINIOSERVER_CONFIG_PASSWORD}
        MinIO Bucket: ${var.MINIOSERVER_CONFIG_BUCKET_NAME}
        MinIO Access Key: ${var.MINIOSERVER_CONFIG_ACCESS_KEY}
        MinIO Secret Key: ${var.MINIOSERVER_CONFIG_SECRET_KEY}

        This is the rancher2_cluster_v2 Output Content :) !

        Cluster ID: ${rancher2_cluster_v2.rke2-terraform.id}
        Cluster Name: ${rancher2_cluster_v2.rke2-terraform.name}
        Verson OF RKE2 Installed: ${var.rke2_k8s_version}
        Each Node In The Cluster Username For SSH: ${var.rke2_vm_ssh_user}
        Each Node In The Cluster Password For SSH: ${var.rke2_vm_password}

    EOF
  )
}