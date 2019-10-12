resource "aws_key_pair" "personalawskey" {
  key_name = "mykey"
  public_key = "${file("${var.PATH_T0_PUBLIC_KEY}")}"
}


resource "aws_instance" "web" {
  ami           = "${lookup(var.AMIS, var.region)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.personalawskey.key_name}"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }

//  provisioner "remote-exec" {
//    inline = [
//      "chmod +x /tmp/script.sh",
//      "sudo /tmp/script.sh"
//    ]
//  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} >> privateips.txt"
  }
  connection {
    user = "${var.instance_username}"
    host = self.public_ip
    private_key = "${file("${var.PATH_T0_PRIVATE_KEY}")}"
  }
}

output "publicip" {
  value = "${aws_instance.web.public_ip}"
}


