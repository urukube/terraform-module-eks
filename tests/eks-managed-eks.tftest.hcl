
run "setup" {
  module {
    source = "./tests/setup"
  }

  variables {
    region = "us-east-1"
  }
}

run "plan" {
  command = plan

  variables {
    env                       = "test"
    bu_id                     = "test-bu"
    app_id                    = "test-app"
    vpc_id                    = run.setup.vpc_id
    private_subnet_ids        = run.setup.subnet_ids
    is_eks_managed_node_group = true
  }

  assert {
    condition     = module.eks.cluster_name == "root-test-bu-test-app-eks"
    error_message = "Cluster name did not match expected value"
  }

}
