#!/bin/bash

# Update system packages
sudo apt update -y

# Install Java 17 (OpenJDK)
sudo apt install openjdk-17-jdk -y

# Verify Java installation
java -version

# Create a directory for Tomcat
mkdir -p ~/tomcat
cd ~/tomcat

# Download Tomcat 9.0.108
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz

# Extract the archive
tar -zxvf apache-tomcat-9.0.108.tar.gz

# Set environment variable (optional)
export CATALINA_HOME=~/tomcat/apache-tomcat-9.0.108

# Configure tomcat-users.xml
TOMCAT_USERS="$CATALINA_HOME/conf/tomcat-users.xml"

# Backup original file
cp "$TOMCAT_USERS" "$TOMCAT_USERS.bak"

# Insert roles and user
sed -i '56 a\<role rolename="manager-gui"/>' "$TOMCAT_USERS"
sed -i '57 a\<role rolename="manager-script"/>' "$TOMCAT_USERS"
sed -i '58 a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' "$TOMCAT_USERS"
sed -i '59 a\</tomcat-users>' "$TOMCAT_USERS"
sed -i '56d' "$TOMCAT_USERS"

# Allow remote access to Manager app
CONTEXT_FILE="$CATALINA_HOME/webapps/manager/META-INF/context.xml"
sed -i '21d' "$CONTEXT_FILE"
sed -i '22d' "$CONTEXT_FILE"

# Make scripts executable
chmod +x "$CATALINA_HOME/bin/"*.sh

# Start Tomcat
"$CATALINA_HOME/bin/startup.sh"

echo "✅ Tomcat started. Access it at http://localhost:8080"

