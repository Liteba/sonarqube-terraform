resource "aws_instance" "sonarqube_server" {
  ami                    = "ami-07fb9d5c721566c65"
  instance_type          = "t2.medium"
  key_name               = "realmen12345"
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]

  user_data = <<-EOF
    #!/bin/bash

    sudo useradd sonar
    sudo echo "sonar ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonar

    sudo hostnamectl set-hostname sonar
    sudo su - sonar << EOC
    sudo passwd sonar

    sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
    sudo service sshd restart

    cd /opt
    sudo yum -y install unzip wget git
    sudo yum install java-11-openjdk-devel -y

    sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.8.zip
    sudo unzip sonarqube-7.8.zip
    sudo rm -rf sonarqube-7.8.zip
    sudo mv sonarqube-7.8 sonarqube

    sudo chown -R sonar:sonar /opt/sonarqube/
    sudo chmod -R 775 /opt/sonarqube/

    sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start
    sh /opt/sonarqube/bin/linux-x86-64/sonar.sh status
    EOC
  EOF

  tags = {
    Name = "sonarqube"
  }
}
