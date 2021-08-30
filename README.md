# wifi_broadcast_scripts
Adição de parâmetro de controle de taxa e simplificação dos scripts

How to use:

* Copy either systemd/wbcrxd or systemd/wbctxd to /etc/systemd/system
* Enable service: sudo systemctl enable wbcrxd

Now either the rx.sh or tx.sh scripts should start automatically at boot.

Note that these scripts are expected to be under /home/pi/wifibroadcast_fpv_scripts . Otherwise you would need to adapt the wbcrxd and wbctx.
