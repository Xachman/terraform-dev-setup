resource "aws_ebs_volume" "instance1_swap" {
  size = 4
  availability_zone   = aws_subnet.dev.availability_zone

  tags = {
    Name = "instance1-swap"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "dev-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo+nYUgx/ynX2ETFCqzeOtNjkIQisz3LSWGAhrSHQVfmPp9HfccbK5avmZEc6b0KTDbdeRKSJz5WrKpKQ8ZW5XHhIjFEqpi0iuTwIvcyBSKsOhPFQwxIaw2GxjLFvM1U5YXM+XSmk1q9VRbNvJ8QdBwmy5lOdgwLrA50buSwTymu2dHM+w/tfMyF1MZJhy8TW6uNboyNDFfH8PjX0Ifd094+aiJt7g1PN0pefNhvnJIwi2qIlenxNLgZMq+jpfLQ81KLCf0TjYbv9mpTuedTWPyoWcYDG3b65rc+bAy7D0nfUCCbDZ8jqodsDOxSHUf0U3I51ykh76XWEB8YeRYlEwM9uwt1AFbb1V4bkRgy+//M3OjLtPMsGSBGQBYZ2K+T/m3NGtOV/pRDECn0kxbYb4imUSJcIl3DmxHtYAcBGs8YxE30WORvyr45F2h2ttPI/S5OcEXeAxU2pO0lfRvUC+XGi6Ra0i7X0cM2V1huPEWRjcGMTYsL3f+vAztXNXwgby9NsULvPtzFPlwGiYqweebN/mHzYgyn5V+1KPt7tlcimCnVjz9WtfyvGRSKgIImNgNLDNWvYYzd3XFNtl69l/9pDTVpAUH4JHIOXExuS2MoX1ea+0Ivikao9XTSjagsejQQTavqkaLHtESo6OciGMmThx4kx3LJjt6gpeLedlDQ=="
}
resource "aws_instance" "instance1" {
    ami                 = "ami-042e8287309f5df03"
    instance_type       = "t3.micro"
    availability_zone   = aws_subnet.dev.availability_zone
    subnet_id           =  aws_subnet.dev.id
    vpc_security_group_ids     = [
        aws_security_group.allow_dev_ssh.id
    ]
    key_name = aws_key_pair.deployer.id
    tags                = {
        Name = "instance1"
    }

    root_block_device {
        volume_size = "10"
        tags = {
            Name = "instance1"
        }
    }
}


resource "aws_volume_attachment" "instance1_swap" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.instance1_swap.id
  instance_id = aws_instance.instance1.id
}
