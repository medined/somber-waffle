# somber-waffle

Using ansible to generate aws resources

## Prequisites

* Install pycrypto

```
sudo apt install -y python3 python3-pip
sudo pip install -y cryptography pycrypto

```

* Update Ansible

```
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
```

## Encrypting File

```
ansible-vault \
 --vault-password-file ~/.ansible-vault-pass.txt \
 create vault.yml
 ```

## Viewing File

```
ansible-vault \
 --vault-password-file ~/.ansible-vault-pass.txt \
 view vault.yml
```

## Editing File

```
ansible-vault \
  --vault-password-file ~/.ansible-vault-pass.txt \
  edit vault.yml
```
