#!/bin/sh

echo "Running stage1..."
ansible-playbook stage1.yml

echo "Running stage2..."
ansible-playbook stage2.yml

echo "System configured! It's time to reboot now. Have fun!"
