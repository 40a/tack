module "vpc" {
  source = "./modules/vpc"

  azs = "${ var.aws.azs }"
  cidr = "${ var.cidr.vpc }"
  name = "${ var.name }"
  region = "${ var.aws.region }"
}

module "route53" {
  source = "./modules/route53"

  etcd-ips = "${ var.etcd-ips }"
  name = "${ var.name }"
  internal-tld = "${ var.internal-tld }"
  vpc-id = "${ module.vpc.id }"
}

module "bastion" {
  source = "./modules/bastion"

  ami-id = "${ var.coreos-aws.ami }"
  cidr-allow-ssh = "${ var.cidr.allow-ssh }"
  instance-type = "${ var.instance-type.bastion }"
  key-name = "${ var.aws.key-name }"
  name = "${ var.name }"
  subnet-ids = "${ module.vpc.subnet-ids }"
  vpc-id = "${ module.vpc.id }"
}

module "etcd" {
  source = "./modules/etcd"

  ami-id = "${ var.coreos-aws.ami }"
  etcd-ips = "${ var.etcd-ips }"
  instance-type = "${ var.instance-type.etcd }"
  internal-tld = "${ var.internal-tld }"
  key-name = "${ var.aws.key-name }"
  name = "${ var.name }"
  /*region = "${ var.region }"*/
  subnet-ids = "${ module.vpc.subnet-ids }"
  vpc-id = "${ module.vpc.id }"
}
