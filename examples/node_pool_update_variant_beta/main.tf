/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  cluster_type = "node-pool-update-variant-beta"
}

provider "google-beta" {}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                  = "../../modules/beta-private-cluster-update-variant"
  project_id              = var.project_id
  name                    = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                = true
  region                  = var.region
  #zones                   = var.zones
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  create_service_account  = false
  service_account         = var.compute_engine_service_account
  enable_private_endpoint = true
  enable_private_nodes    = true
  remove_default_node_pool = true
  master_ipv4_cidr_block  = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]

  node_pools = [
    {
      name               = "pool-1"
      machine_type       = "e2-micro"
      min_count          = 1
      max_count          = 2
      disk_size_gb       = 30
      #node_locations     = "${var.region}-b,${var.region}-c"
      autoscaling        = true
      node_count         = 2
      disk_type          = "pd-standard"
      auto_upgrade       = true
      service_account    = var.compute_engine_service_account
      pod_range          = "np1"
     # sandbox_enabled    = true
     # cpu_manager_policy = "static"
     # cpu_cfs_quota      = true
    },
    {
      name               = "pool-2"
      machine_type       = "e2-micro"
      min_count          = 1
      max_count          = 2
      disk_size_gb       = 30
      #node_locations     = "${var.region}-b,${var.region}-c"
      autoscaling        = true
      node_count         = 2
      disk_type          = "pd-standard"
      auto_upgrade       = true
      service_account    = var.compute_engine_service_account
      pod_range          = "np2"
     # sandbox_enabled    = true
     # cpu_manager_policy = "static"
     # cpu_cfs_quota      = true
    },
    {
      name               = "pool-3"
      machine_type       = "e2-micro"
      min_count          = 1
      max_count          = 2
      disk_size_gb       = 30
      #node_locations     = "${var.region}-b,${var.region}-c"
      autoscaling        = true
      node_count         = 2
      disk_type          = "pd-standard"
      auto_upgrade       = true
      service_account    = var.compute_engine_service_account
      pod_range          = "np3"
     # sandbox_enabled    = true
     # cpu_manager_policy = "static"
     # cpu_cfs_quota      = true
    },
    {
      name               = "pool-4"
      machine_type       = "e2-micro"
      min_count          = 1
      max_count          = 2
      disk_size_gb       = 30
      #node_locations     = "${var.region}-b,${var.region}-c"
      autoscaling        = true
      node_count         = 2
      disk_type          = "pd-standard"
      auto_upgrade       = true
      service_account    = var.compute_engine_service_account
      pod_range          = "np4"
     # sandbox_enabled    = true
     # cpu_manager_policy = "static"
     # cpu_cfs_quota      = true
    },
  ]

  node_pools_oauth_scopes = {
    all     = []
    pool-01 = []
    pool-02 = []
  }

  node_pools_metadata = {
    all = {}
    pool-01 = {
      shutdown-script = file("${path.module}/data/shutdown-script.sh")
    }
    pool-02 = {}
  }

  node_pools_labels = {
    all = {
      all-pools-example = true
    }
    pool-01 = {
      pool-01-example = true
    }
    pool-02 = {}
  }

  node_pools_taints = {
    all = [
      {
        key    = "all-pools-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    pool-01 = [
      {
        key    = "pool-01-example"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    pool-02 = []
  }

  node_pools_tags = {
    all = [
      "all-node-example",
    ]
    pool-01 = [
      "pool-01-example",
    ]
    pool-02 = []
  }
}