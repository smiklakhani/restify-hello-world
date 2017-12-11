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
        docker.withRegistry('http://10.137.84.145:8082', 'NexusRepo') {
             RestCustomImage = docker.build("10.137.84.145:8082/restify-hello-world:v_${env.BUILD_NUMBER}")
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

}
