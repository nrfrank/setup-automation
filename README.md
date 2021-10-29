# setup-automation

> Scripts and methods to setup and automate my workstation.

## Scripts

### AWS Multi-Factor Authentication Login
This script uses an assigned MFA device to generate AWS credentials, namely the 
`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` environment variables.

##### Setup

The script requires the AWS CLI and jq.
* jq can be installed on a Mac using Homebrew:
      
    > brew install jq

* Instructions for installing the AWS CLI depend on the version used and can be found
  [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html). AWS CLI v1 can be
  installed using `pip`:
  
    > pip install awscli

##### Usage
The script must be sourced rather than executed as in the example below in order for the exported 
environment variables to persist in the active shell session.

* Parameters:
    * `mfa-device-arn`: The ARN of the assigned MFA device.
    * `token`: Up to date one time token from the MFA device.
    * `profile`: Profile name for AWS credentials file. Default: default.
    * `session-duration`: The duration of the session in seconds. Default: 43200 (12 hours).
    
Example:
```shell script
$ source aws-mfa-login.sh --profile default --mfa-device-arn $AWS_MFA_DEVICE_ARN --token 123456
```
