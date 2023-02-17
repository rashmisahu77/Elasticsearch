provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = aws_instance.example.public_ip
      user        = "ubuntu"
      private_key = file("id_rsa")
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install openjdk-8-jre-headless -y",
      "wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-linux-x86_64.tar.gz",
      "tar -xzf elasticsearch-7.10.2-linux-x86_64.tar.gz",
      "sudo mv elasticsearch-7.10.2 /usr/local/elasticsearch",
      "sudo chown -R ubuntu:ubuntu /usr/local/elasticsearch",
      "cd /usr/local/elasticse…
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# Install ElasticSearch
provisioner "remote-exec" {
  connection {
    type     = "ssh"
    host     = aws_instance.example.public_ip
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  inline = [
    "sudo apt-get update",
    "sudo apt-get install openjdk-8-jre-headless -y",
    "wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-linux-x86_64.tar.gz",
    "tar -xzf elasticsearch-7.10.2-linux-x86_64.tar.gz",
    "sudo mv elasticsearch-7.10.2 /usr/local/elasticsearch",
    "sudo chown -R ubuntu:ubuntu /usr/local/elasticsearch",
  ]
}

# Configure ElasticSearch
provisioner "file" {
  source      = "elasticsearch.yml"
  destination = "/usr/local/elasticsearch/config/elasticsearch.yml"

  connection {
    type     = "ssh"
    host     = aws_instance.example.public_ip
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
}

# Start ElasticSearch
provisioner "remote-exec" {
  inline = [
    "sudo /usr/local/elasticsearch/bin/elasticsearch",
  ]

  connection {
    type     = "ssh"
    host     = aws_instance.example.public_ip
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
}

# Test ElasticSearch
provisioner "local-exec" {
  command = "curl -u user:pass http://${aws_instance.example.public_ip}:9200/_cat/health
  }