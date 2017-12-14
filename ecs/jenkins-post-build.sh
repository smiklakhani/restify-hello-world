SERVICE_NAME="rest"
#VERSION=`date +%y%m%d%H%M%S`"_"${BUILD_NUMBER}
VERSION=${BUILD_NUMBER}
TASK_FAMILY="rest"
CLUSTER="rest"
REGION="us-east-1"
COUNT="4"

# Create a new task definition for this build
# Replace the build number
#TASK_FILE=ecs/tasks/rest-task-v_${VERSION}.json
TASK_FILE=ecs/tasks/rest-task.json
sed -i "s;%BUILD_NUMBER%;${VERSION};g" ecs/tasks/rest-task.json
#sed -e "s;%BUILD_NUMBER%;${VERSION};g" ecs/tasks/rest-task.json > $TASK_FILE

# Replace the desired count
SERVICE_FILE="ecs/services/rest-service.json"
sed -i "s;%DESIRED_COUNT;${COUNT};g" ecs/services/rest-service.json

#Register the task definition in the repository
#aws ecs register-task-definition --region ${REGION} --family ${TASK_FAMILY} --cli-input-json file://$TASK_FILE

SERVICES=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
#Get latest revision
TASK_REVISION=`aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region ${REGION} | jq .taskDefinition.revision`

#Create or update service
#if [ "$SERVICES" == "" ]; then
if [ "$SERVICES" == "" ] || [ "$SERVICES" == "0" ] ; then
  echo "Creating the service"
  aws ecs create-service --region ${REGION} --cli-input-json file://$SERVICE_FILE
else
  echo "Updating the service desired count"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
  if [ ${DESIRED_COUNT} = 0 ]; then
    DESIRED_COUNT="${COUNT}"
  else
    DESIRED_COUNT="${COUNT}"
  fi
#  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT}
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY} --desired-count ${DESIRED_COUNT}
fi
