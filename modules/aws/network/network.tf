//VPC For the Rancher env in this region.
module "vpc" {
  source = "./vpc"
  name   = "${var.vpc_name}-vpc"
  cidr   = "${var.vpc_cidr}"
}

module "public_subnets" {
  source = "./public_subnet"

  name   = "${var.public_subnet_name}"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.public_subnet_cidrs}"
  azs    = "${var.azs}"
}

module "nat" {
  source = "./nat"

  name              = "${var.vpc_name}-nat"
  azs               = "${var.azs}"
  public_subnet_ids = "${module.public_subnets.subnet_ids}"
}

module "private_subnets" {
  source = "./private_subnet"

  name            = "${var.private_subnet_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  cidrs           = "${var.private_subnet_cidrs}"
  azs             = "${var.azs}"
  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}

module "security_groups" {
  source               = "./security_groups"
  vpc_id               = "${module.vpc.vpc_id}"
  private_subnet_cidrs = "${var.public_subnet_cidrs}"
}

module "elb" {
  source          = "./elb"
  name            = "${var.vpc_name}"
  public_subnets  = "${module.public_subnets.subnet_ids}"
  security_groups = "${module.security_groups.elb_sg_id}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnet_ids" {
  value = "${module.private_subnets.subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.public_subnets.subnet_ids}"
}

output "compute_security_groups" {
  value = "${module.security_groups.compute_node_sgs}"
}

output "public_elbs" {
  value = "${module.elb.management_elb_id}"
}
