#cloud-config
#********************************************************************************************
# Copyright (c) 2023, Oracle and/or its affiliates.                                                       
# Licensed under the Universal Permissive License v 1.0 as shown at  https://oss.oracle.com/licenses/upl/ 
#********************************************************************************************
  
runcmd:
  - su opc
  - cd /home/opc/
  - export LOG=/home/opc/boot.log
  - export APPDIR=/home/opc/usage_reports_to_adw
  - export CRED=$APPDIR/config.user
  - echo "Start process at `date`" > $LOG
  - chown opc:opc $LOG
  - mkdir -p $APPDIR
  - chown opc:opc $APPDIR

  # Create the properties file for app_url
  - export APP_URL=/home/opc/app_url.txt
  - echo "Post application url into $APP_URL" >> $LOG
  - echo "APP_URL=${application_url}" > $APP_URL   
  - echo "ADMIN_URL==${admin_url}" >> $APP_URL
  - echo "LB_APP_URL=${lb_application_url}" >> $APP_URL   
  - echo "LB_ADMIN_URL==${lb_admin_url}" >> $APP_URL
  - chown opc:opc $APP_URL

  # Create the properties file
  - echo "Post variables into config.user file." >> $LOG
  - echo "DATABASE_USER=USAGE" > $CRED   
  - echo "DATABASE_ID=${db_db_id}" >> $CRED
  - echo "DATABASE_NAME=${db_db_name}_low" >> $CRED
  - echo "DATABASE_SECRET_ID=${db_secret_id}" >> $CRED 
  - echo "DATABASE_SECRET_TENANT=local" >> $CRED 
  - echo "EXTRACT_DATE=${extract_from_date}" >> $CRED
  - echo "TAG_SPECIAL=${extract_tag1_special_key}" >> $CRED
  - echo "TAG2_SPECIAL=${extract_tag2_special_key}" >> $CRED
  - chown opc:opc $CRED

  # Sleep 60 seconds to wait for the policy to be created 
  - echo "Waiting 60 seconds..." >> $LOG
  - sleep 20
  - echo "Waiting 40 seconds..." >> $LOG
  - sleep 20
  - echo "Waiting 20 seconds..." >> $LOG
  - sleep 20

  # Continue Setup using initial_setup.sh
  # - curl -H 'Cache-Control: no-cache, no-store' -o /home/opc/usage_reports_to_adw/initial_setup.sh https://raw.githubusercontent.com/oracle-samples/usage-reports-to-adw/main/usage2adw_setup.sh >> $LOG

  - wget https://raw.githubusercontent.com/oracle-samples/usage-reports-to-adw/main/usage2adw_setup.sh -O $APPDIR/initial_setup.sh >>$LOG
  - chown opc:opc $APPDIR/initial_setup.sh
  - chmod +x $APPDIR/initial_setup.sh
  - su - opc -c '/home/opc/usage_reports_to_adw/initial_setup.sh -setup_full' >>$LOG

final_message: "The system is finally up, after $UPTIME seconds"
