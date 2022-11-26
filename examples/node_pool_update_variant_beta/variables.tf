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

variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = ""
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "asia-south1"
}

#variable "zones" {
#  type        = list(string)
#  description = "The zone to host the cluster in (required if is a zonal cluster)"
#}

variable "network" {
  description = "The VPC network to host the cluster in"
  default     = "k8stest"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default     = "test"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = "pods"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  default     = "services"
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint for master"
  default     = "true"
}

variable "enable_private_nodes" {
  type        = bool
  description = "Enable private GKE nodes"
  default     = "true"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Master IPV4 CIDR Range"
  default     = "172.16.0.16/28"
}

variable "compute_engine_service_account" {
  description = "Service account to associate to the nodes in the cluster"
  default     = "gke-sa@sadaindia-tvm-poc-de.iam.gserviceaccount.com"
}

variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources = list(object({
      resource_type = string
      minimum       = number
      maximum       = number
    }))
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
    gpu_resources       = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}
