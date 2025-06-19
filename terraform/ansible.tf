resource "null_resource" "inventory_and_knownhosts" {

  provisioner "local-exec" {
    command =  "echo [web_servers] > ../ansible/inventory.ini && echo ${azurerm_linux_virtual_machine.main.public_ip_address} >> ../ansible/inventory.ini"
  }

  provisioner "local-exec" {
    command =  "ssh-keyscan -H ${azurerm_linux_virtual_machine.main.public_ip_address} >> $HOME/.ssh/known_hosts && echo 'SSH key added to known_hosts'"
  }
  
  triggers = {
    script_version = "1.0.0"  
  }
}


resource "null_resource" "ansible_provisioner" {
  provisioner "remote-exec" {
    inline = [ "sudo apt update -y", "echo Done!",
               "curl http://'deltronfr:${var.dns_password}'@freedns.afraid.org/nic/update?hostname=deltronfr.mooo.com&myip=${azurerm_linux_virtual_machine.main.public_ip_address} && echo Success && sleep 120" ]

    connection {
      host = "${azurerm_linux_virtual_machine.main.public_ip_address}"
      type = "ssh"
      user = var.admin_username
      private_key = file(var.ssh_pri_key)
    }
  }

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbook.yaml"
  }

   triggers = {
    script_version = "1.0.0"  
  }

  depends_on = [ azurerm_linux_virtual_machine.main,
                 azurerm_public_ip.public_ip,
                 azurerm_network_security_group.nsg,
                 null_resource.inventory_and_knownhosts
               ]
}
