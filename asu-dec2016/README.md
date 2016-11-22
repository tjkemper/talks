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
#### Java
`java -version`
#### Maven
`mvn -version`
#### Git
`git version`
#### AWS CLI
`aws --version`

<br/>
### 2. Run the Java Application locally
Under the `app/` folder, there is a Java application.  Let's get it running.  
<br/>
###### Commands
Go into the `app/` directory
```
cd app/
```
Build the Java application
```
mvn clean package
```
Run the Java application
```
java -jar target/app-0.1.0.jar
```
Using your browser, enter the following url: `http://localhost:8080`

<br/>
> Our goal is to deploy this application in the cloud.

<br/>
### 3. Launch EC2 instance
Let's launch our first EC2 instance.
<br/>
###### Commands
[Creating a key pair](http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html#creating-a-key-pair)
```
aws ec2 create-key-pair --key-name demo-key-pair --query 'KeyMaterial' --output text > demo-key-pair.pem
```
Restrict permissions (optional but recommended)
```
chmod 400 demo-key-pair.pem
```
Check if the key pair was created
```
aws ec2 describe-key-pairs
```
Creating a Security Group and Allow SSH to `demo-sg` Security Group
```
aws ec2 create-security-group --group-name demo-sg --description "Demo security group"
aws ec2 authorize-security-group-ingress --group-name demo-sg --protocol tcp --port 22 --cidr 0.0.0.0/0
```
Launch EC2 instance
```
aws ec2 run-instances --image-id ami-b73b63a0 --instance-type t2.micro --key-name demo-key-pair --security-groups demo-sg
```
Get Public DNS Name for our EC2 instance (takes a few minutes)
```
aws ec2 describe-instances --query 'Reservations[].Instances[].PublicDnsName'
aws ec2 describe-instances --query 'Reservations[].Instances[].PublicDnsName' --filters "Name=instance-type,Values=t2.micro"
```

<br/>
### 4. Connect to EC2 instance
SSH into the EC2 instance
```
ssh -i demo-key-pair.pem ec2-user@ec2-54-225-193-182.compute-1.amazonaws.com
```


<br/>
### 5. Install Jenkins on EC2 instance


<br/>
### 6. Configure Jenkins to achieve Continuous Integration (CI) and Continuous Deployment (CD)

