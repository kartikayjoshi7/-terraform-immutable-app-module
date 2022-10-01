#!/bin/bash

if [ -d /home/roboshop ]; then
  COMPONENT=$(ls -l /home/roboshop/)
  if [ -f /etc/systemd/system/${COMPONENT}.service ]; then
    sed -i -e 's/ENV/prod/' /etc/systemd/system/${COMPONENT}.service /etc/filebeat/filebeat.yml
    set-hostname -skip-apply ${COMPONENT}-prod
    systemctl daemon-reload
    systemctl enable ${COMPONENT}
    systemctl restart ${COMPONENT}
  fi
  fi


if [ -f /etc/ngnx/default.d/roboshoop.conf ]; then
  sed -i -e 's/ENV/prod/' /etc/ngix/default.d.roboshop.conf /etc/filebeat/filebeat.yml
  set-hostname -skip-apply frontend-prod
  systemctl restart nginx
  fi
  