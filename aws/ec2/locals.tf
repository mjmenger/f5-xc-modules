locals {
  userdata_content = templatefile(format("%s/templates/%s", path.module, var.aws_ec2_instance_script_template), var.aws_ec2_instance_data.template_data)
}

