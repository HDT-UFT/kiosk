#!/bin/bash

# Install X.org, OpenBox, Firefox
sudo apt install --no-install-recommends -y xorg openbox firefox

# Write X.org startup script to /opt/kiosk/kiosk.sh
sudo mkdir /opt/kiosk
echo "#!/bin/bash
xset s
xset -dpms
off openbox-session &
while true;
do
  /usr/bin/firefox --kiosk --height 1080 --width 1920 --private-window 'https://aghu.hdt-uft.ebserh/'
done" | sudo tee /opt/kiosk/kiosk.sh

# Write service file to /etc/systemd/system/kiosk.service
echo "[Unit]
Description=Start kiosk
[Service]
Type=simple
ExecStart=sudo startx /etc/X11/Xsession /opt/kiosk/kiosk.sh
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/kiosk.service

# Add permissions to the files
sudo chmod 644 /etc/systemd/system/kiosk.service
sudo chmod +x /opt/kiosk/kiosk.sh

# Enable the service on startup
sudo systemctl daemon-reload
sudo systemctl enable kiosk
sudo systemctl start kiosk

# Finish
echo "Edit /opt/kiosk/kiosk.sh to change the website.
Run 'sudo systemctl start kiosk' to start the kiosk."