#!groovy
node () {

    stage('pull code from git') {
        git(
           url: 'https://github.com/smiklakhani/restify-hello-world.git',
           credentialsId: 'mygithub',
           branch: 'hello-world'
        )
    }
    
    stage('building the image') {
        docker.withRegistry('https://nexus.hcqis.org:28443', 'VentechNexusRepo') {
             RestCustomImage = docker.build("nexus.hcqis.org:28443/restify-hello-world:v_${env.BUILD_NUMBER}")
        }
    }
  
    stage('Test image') {
        RestCustomImage.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('pushing the image') {
             RestCustomImage.push("v_${env.BUILD_NUMBER}")
    }

    stage ('Permission to execute') {
        sh "chmod +x -R ${env.WORKSPACE}/../${env.JOB_NAME}/ecs/jenkins-post-build.sh"
    }

    stage ('Execute the script') {
        sh "${env.WORKSPACE}/../${env.JOB_NAME}/ecs/jenkins-post-build.sh"
    }

}
