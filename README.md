# CVS-Health-POC

This is a all-in-one folder for CVS-POC v1

## CVS-VAULT
-command lines to access vault
-create dynamic users with expiry
-test users 
-create dynamic API Keys with expiry
-test API Keys

## REST-API-VAULT
-curl commands lines to access audit logs  
-curl commands lines to access mongodb logs

## Terraform 
* main.tf
  * Connects to GCP
  * Creates vpc
  * Creates 2 subnet ; 1 public 1 private
  * Create a ubuntu VM in the public subnet
  * Create  a firewall to allow ssh access to VM
  * Installs mongo shello client on the Ubuntu VM
* variables
  * store values to variable
  
 ## GCP-Build 
* main.tf
  * connects to MongoDB Atlas
  * creates Project 
  * connects this newly create project to Google KMS for encryption
  * applies the encryption Key to the Project
  * connects this newly create project to the vpc -for  peering
  * creates a peering connection from project to the to the vpc
  
* variables
  * store API Key values to variable
  


  






