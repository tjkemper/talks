# DevOps demo

    Leverage AWS to create a CI/CD Pipeline using Jenkins

## Project Goals
* Demonstrate the benefits of cloud, DevOps, CI/CD
* Demonstrate AWS basics
* Demonstrate Jenkins basics

## Prerequisites
* [Install Java](https://java.com/en/download/help/index_installing.xml)
* [Install Maven](http://maven.apache.org/install.html)
* [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* AWS account and AWS CLI
  1. [Getting Set Up with the AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html)
  + [Installing the AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
  + [Configuring the AWS Command Line Interface (Quick Configuration)](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration)
* SSH client
  * Demo will assume you can: [Connect to Your Linux Instance](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html)

## Notes
* **This talk is focused on learning the broad strokes.**  This means the talk is fast-paced and it may be difficult to complete the demo during the talk.
* During the talk, it is recommended to **take notes and ask questions**.  If you want to do the demo, do it before or after the talk when you can set your own pace.
* I am using a Mac.  I will do my best to provide helpful links for Windows users.
* Common ways to use AWS:
  1. [AWS CLI](https://aws.amazon.com/cli/)
  + [AWS Console](https://console.aws.amazon.com)
* During this demo we will use the AWS CLI
  
## Demo

### 1. Make sure everything is installed.  Open command line and enter these commands:
`java -version`  
`mvn -version`  
`git version`  
`aws --version`  

<br/>
### 2. Run the Java Application locally
> Under the `app/` folder, there is a Java application.  Let's get it running.  

```
cd /<path>/app/
mvn clean package
java -jar target/app-0.1.0.jar
```
Using your browser, enter the following url: `http://localhost:8080`

<br/>

### 3. Set up AWS key pair and security group  

[Creating a key pair](http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html#creating-a-key-pair) - click link if using Windows
```
aws ec2 create-key-pair --key-name demo-key-pair --query 'KeyMaterial' --output text > demo-key-pair.pem
```
Restrict permissions (optional but recommended)
```
chmod 400 demo-key-pair.pem
```
Creating a Security Group
```
aws ec2 create-security-group --group-name demo-sg --description "Demo security group"
aws ec2 authorize-security-group-ingress --group-name demo-sg --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name demo-sg --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name demo-sg --protocol tcp --port 8080 --cidr 0.0.0.0/0
```

<br/>
### 4. Launch EC2 instance for Jenkins

Launch Jenkins EC2 instance
```
aws ec2 run-instances --image-id ami-40d28157 --instance-type t2.micro --key-name demo-key-pair --security-groups demo-sg
```
Get Jenkins instanceId.  
The instanceId will look like: `i-051ac82e682fe22de`.  We will call this: `<jenkinsId>`.  
```
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, Tags[*]]' --filters "Name=instance-type,Values=t2.micro"
```
Tag Jenkins EC2 instance
```
aws ec2 create-tags --resources <jenkinsId> --tags "Key=Name,Value=jenkins"
```

Get Public DNS Name for our Jenkins EC2 instance (may take a few minutes).  
The Public DNS Name will look like: `ec2-54-225-193-182.compute-1.amazonaws.com`.  We will call this `<jenkinsDnsName>`.
```
aws ec2 describe-instances --query 'Reservations[].Instances[].[PublicDnsName, Tags[*]]' --filters "Name=instance-type,Values=t2.micro"
```

<br/>
### 5. Connect to Jenkins EC2 instance

SSH into the Jenkins EC2 instance
```
ssh -i demo-key-pair.pem ubuntu@<jenkinsDnsName>
```
Type in `yes` and press `Enter`  
![AWS SSH question](pictures/aws-ssh.png)

<br/>
### 6. Install Jenkins on EC2 instance

While logged into the EC2 instance, run the commands in `ec2-jenkins.sh`.

Using your browser, enter the following url: `http://<jenkinsDnsName>:8080`

Find the default Jenkins password
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Enter default Jenkins password

Install suggested plugins

Enter admin info

<br/>
### 7. Launch EC2 instance for our Java App

Launch Java App EC2 instance
```
aws ec2 run-instances --image-id ami-40d28157 --instance-type t2.micro --key-name demo-key-pair --security-groups demo-sg
```
Get Java App instanceId.  
The instanceId will look like: `i-051ac82e682fe22de`.  We will call this: `<appId>`.  
```
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, Tags[*]]' --filters "Name=instance-type,Values=t2.micro"
```
Tag Java App EC2 instance (use `<appId>`)
```
aws ec2 create-tags --resources <appId> --tags "Key=Name,Value=app"
```

Get Public DNS Name for our Java App EC2 instance (may take a few minutes).  
The Public DNS Name will look like: `ec2-54-225-193-182.compute-1.amazonaws.com`.  We will call this `<appDnsName>`.
```
aws ec2 describe-instances --query 'Reservations[].Instances[].[PublicDnsName, Tags[*]]' --filters "Name=instance-type,Values=t2.micro"
```

<br/>
### 8. Create Jenkins job
> Finally Jenkins is set up.  Let's create a Jenkins job to build and deploy our app.

