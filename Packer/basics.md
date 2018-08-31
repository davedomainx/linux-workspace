Get port forwarded in debug
ssh -p 3022 me@127.0.0.1

# -on-error=ask is best friend

PACKER_LOG=1 PACKER_LOG_PATH="LOGS/$$.log" packer build -on-error=ask -var download_location=rpm_server vbox.json
