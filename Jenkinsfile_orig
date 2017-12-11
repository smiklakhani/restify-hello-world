#!groovy
node () {

  properties([pipelineTriggers([pollSCM('* * * * *')])])

  def branch = "develop"

    git(
       url: 'https://git.hcqis.org/le9266/restify-hello-world.git',
       credentialsId: 'hcqisgit',
       branch: 'hello-world'
    )

    stage ('Build and Push Docker Image') {
      withCredentials([[$class: "UsernamePasswordMultiBinding", usernameVariable: 'NEXUSREPO_USERNAME', passwordVariable: 'NEXUSREPO_PASSWORD', credentialsId: 'NexusRepo']]) {
        sh "docker login --username $NEXUSREPO_USERNAME --password $NEXUSREPO_PASSWORD 10.137.84.145:8082"
        sh "docker build -t 10.137.84.145:8082/flask-signup:v_${BUILD_NUMBER} ."
        sh "docker push 10.137.84.145:8082/flask-signup:v_${BUILD_NUMBER}"
        sh "docker rmi -f 10.137.84.145:8082/flask-signup:v_${BUILD_NUMBER}"
      }
        sh 'docker logout'
    }

    stage ('Permission to execute') {
        sh "chmod +x -R ${env.WORKSPACE}/../${env.JOB_NAME}/ecs/jenkins-post-build.sh"
    }

    stage ('Execute the script') {
        sh "${env.WORKSPACE}/../${env.JOB_NAME}/ecs/jenkins-post-build.sh"
    }
}
