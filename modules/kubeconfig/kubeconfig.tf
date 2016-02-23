resource "template_file" "kubeconfig" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
mkdir -p ./tmp && cat <<'__USERDATA__' > ./tmp/kubeconfig
${template_file.kubeconfig.rendered}
__USERDATA__
LOCAL_EXEC
  }

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
kubectl config set-cluster default-cluster \
  --server=https://${ var.master-elb } \
  --certificate-authority=${ path.cwd }/${ var.ca-pem } &&\
kubectl config set-credentials default-admin \
  --certificate-authority=${ path.cwd }/${ var.ca-pem } \
  --client-key=${ path.cwd }/${ var.admin-key-pem } \
  --client-certificate=${ path.cwd }/${ var.admin-pem } &&\
kubectl config set-context default-system \
  --cluster=default-cluster \
  --user=default-admin &&\
kubectl config use-context default-system
LOCAL_EXEC
  }

  template = <<EOF
kubectl config set-cluster default-cluster \
  --embed-certs=true \
  --server=https://${ var.master-elb } \
  --certificate-authority=${ path.cwd }/${ var.ca-pem }

kubectl config set-credentials default-admin \
  --embed-certs=true \
  --certificate-authority=${ path.cwd }/${ var.ca-pem } \
  --client-key=${ path.cwd }/${ var.admin-key-pem } \
  --client-certificate=${ path.cwd }/${ var.admin-pem }

kubectl config set-context default-system \
  --cluster=default-cluster \
  --user=default-admin
kubectl config use-context default-system

# Run this command to configure your kubeconfig:
# eval $(terraform output kubeconfig)
EOF

  vars = {
    /*cluster-name = "${var.cluster-name}"
    ca-pem = "${var.ssl.ca}"
    admin-pem = "${var.ssl.admin}"
    admin-key-pem = "${var.ssl.admin-key}"
    ip = "${aws_instance.k8s-master.public_ip}"
    server = "test-k8s"*/
    # server = "${aws_instance.k8s-master.public_ip}"
  }
}
