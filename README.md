# Mailifier

Linux service that allows other applications to send notifications to a client as E-Mail.

## Installation

Clone repository, change to directory, make installer executable and execute installer:

```
git clone https://monkeyson.dyn.nwrk.biz/git/MonkeySon/mailifier.git
cd mailifier
chmod +x install_mailifier.sh
sudo ./install_mailifier.sh
```

## Configure the service

Configure Mailifier after installation by changing its configuration file located at `/etc/mailifier/mailifier.conf`.

Following settings are available:

```
[SERVICE]
PIPE_PATH   = /var/run/mailifier  # Path to the named pipe that will be created for IPC
SENDER_NAME = Mailifier           # Sender name used by the notification E-Mail

[SMTP]
SERVER   = smtp.mail.com          # SMTP server address of your provider
PORT     = 587                    # SMTP server port of your provider
MAIL     = name@mail.com          # SMTP mail address for login and sender address
PASSWORD = s3c3tp455w0rd          # SMTP password for login
```

After that, restart the service with `sudo systemctl restart mailifier.service`

## Usage

Other processes can send a notification mail to a user by either writing to the named pipe defined in `/etc/mailifier/mailifier.conf` (default: `/var/run/mailifier`) in the format `MAIL_SUBJECT;MAIL_TEXT_BODY` or by using the convenience executable `mailifier_notify`.

Example:

`mailifier_notify -s "Subject of notification mail" -b "This is a example text body for a notification mail."`