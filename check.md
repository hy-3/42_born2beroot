# AppArmor
## check status
```
$ sudo systemctl status apparmor
```

<br>

# Partition
```
$ lsblk
```

<br>

# SSH
## install
```
$ sudo apt-get install openssh-server -y
```

## check status (& listing port)
```
$ sudo systemctl status ssh
```

## check which port is opend.
```
$ sudo grep Port /etc/ssh/sshd_config
```

## connect with ssh
```
$ ssh <USER>@<IP_ADDRESS> -p <PORT>
```

<br>

# UFW
## install
```
$ sudo apt update && sudo apt install ufw
```

## enable
```
$ sudo ufw enable
```

## allow ssh
```
$ sudo ufw allow ssh
```

## open port
```
$ sudo ufw allow <PORT>
```

## delete port
```
$ sudo ufw delete <NUMBER>
```

## check status with number
```
$ sudo ufw status numbered
```

<br>

# Hostname
## check info
```
$ hostnamectl
```

## change
```
$ sudo hostnamectl set-hostname <NEW_NAME>
$ sudo vi /etc/hosts
127.0.0.1	localhost
127.0.1.1	<NEW_NAME>

$ sudo reboot
```

<br>

# User & Group
## add user

## check users

## add group

## check groups

## add user to group

## check which users belong to specific group

<br>

# Password
## install
```
$ sudo apt-get install libpam-pwquality
```

## macro
- Expire in 30days
- Need to wait 2days after change
- Warn 7days before expire

For new user
```
$ sudo vi /etc/login.defs (reboot the server required)

PASS_MAX_DAYS	30
PASS_MIN_DAYS	2
PASS_WARN_AGE	7
```

For existing user
```
$ chage -l <USER>
$ sudo chage -l <USER>
```

## micro
- More than 10 char long : `minlen`
- Should contain an upper case & a number : `ucredit, dcredit`
- No more than 3 consecutive identical chars : `maxrepeat`
- Shouldn't include user name : `usercheck`
- Must not have 7char from last password : `difok`
- Apply same policy to root user : `enforce_for_root`
```
$ sudo vi /etc/pam.d/common-password

password	requisite			pam_pwquality.so retry=3 lcredit=-1 ucredit=-1 dcredit=-1 maxrepeat=3 usercheck=0 difok=7 enforce_for_root
password	[success=1 default=ignore]	pam_unix.so obscure use_authtok try_first_pass sha512 minlen=10
```

## change password
```
$ passwd <USER>
```

<br>

# SUDO
- 3 attempts with incorrect password : `passwd_tries`
- custom message when wrong password entered : `badpass_message`
- log input & output of sudo commands to /vat/log/sudo/ : `log_input,log_output,logfile`
- TTY mode has to be enabled : `requiretty`
- paths can be used by sudo must be restricted : `secure_path`
```
$ apt install sudo
$ su -
# visudo
Defaults        badpass_message="Password is wrong."
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
Defaults        passwd_tries=3
Defaults        logfile="/var/log/sudo/sudo.log"
Defaults        log_input,log_output
Defaults        requiretty
```

# monitoring.sh
## script
TODO: link to monitoring.sh

## cron


TODO
- difference between pam_pwquality.so and pam_unix.so
- check if monitoring.sh is ok
- 