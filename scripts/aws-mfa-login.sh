#!/bin/bash

checkNull() {
    ARGUMENT_NAME=$1
    ARGUMENT_VALUE=$2

    if [[ -z ${ARGUMENT_VALUE} ]]
    then
        echo "Required argument '${ARGUMENT_NAME}' is null. Exiting..."
        exit 1
    else
        echo "${ARGUMENT_NAME} ${ARGUMENT_VALUE}"
    fi
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
      -d|--mfa-device-arn)
      mfa_arn="$2"
      shift # past argument
      shift # past value
      ;;
      -t|--token)
      token="$2"
      shift # past argument
      shift # past value
      ;;
      -p|--profile)
      profile="$2"
      shift # past argument
      shift # past value
      ;;
      -sd|--session-duration)
      duration="$2"
      shift # past argument
      shift # past value
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

mfa_arn=${mfa_arn:-$AWS_MFA_DEVICE_ARN}
profile=${profile:-default}
duration=${duration:-43200}  # 12 hr * 3600 sec/hr = 43200 sec

checkNull "-d|--mfa-device-arn" ${mfa_arn}
checkNull "-t|--token" ${token}

aws_credentials=$(aws --profile $profile sts get-session-token --serial-number $mfa_arn --token-code $token --duration-seconds $duration)

aws_access_key_id=$(echo $aws_credentials | jq -r '.Credentials.AccessKeyId')
aws_secret_access_key=$(echo $aws_credentials | jq -r '.Credentials.SecretAccessKey')
aws_session_token=$(echo $aws_credentials | jq -r '.Credentials.SessionToken')

echo "export AWS_ACCESS_KEY_ID=$aws_access_key_id"
echo "export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key"
echo "export AWS_SESSION_TOKEN=$aws_session_token"

export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
export AWS_SESSION_TOKEN=$aws_session_token
