#!/bin/bash
SERVICE_NAME="Flask-Signup"
#VERSION=`date +%y%m%d%H%M%S`"_"${BUILD_NUMBER}
VERSION=${BUILD_NUMBER}
TASK_FAMILY="flask-signup"
CLUSTER="ecspoc"
REGION="us-east-1"

# Create a new task definition for this build
# Replace the build number and respository URI placeholders with the constants above
TASK_FILE=ecs/flask-signup-v_${VERSION}.json
sed -e "s;%BUILD_NUMBER%;${VERSION};g" ecs/flask-signup.json > $TASK_FILE

#Register the task definition in the repository
aws ecs register-task-definition --region ${REGION} --family ${TASK_FAMILY} --cli-input-json file://$TASK_FILE

SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//' | head -1`

#Get latest revision
TASK_REVISION=`aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region us-east-1 | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`

#DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//' | head -1`

#Create or update service
if [ "$SERVICES" == "" ]; then
  echo "entered existing service"
  aws ecs create-service --service-name ${SERVICE_NAME} --desired-count 1 --task-definition ${TASK_FAMILY} --cluster ${CLUSTER} --region ${REGION}

#elif [ "${DESIRED_COUNT}" = "0" ]; then
else
  DESIRED_COUNT="2"
  #stop existing tasks
  TASKS=$(aws ecs list-tasks --cluster ${CLUSTER} --output text --query taskArns --region ${REGION})
  echo Stopping old tasks : $TASKS
  for T in $TASKS; do aws ecs stop-task --cluster ${CLUSTER} --region ${REGION} --task $T; done

  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
fi
