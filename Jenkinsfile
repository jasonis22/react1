pipeline {
  agent {
    label 'ubuntu'
  }

  options {
    skipStagesAfterUnstable()
    disableConcurrentBuilds()
    parallelsAlwaysFailFast()
  }

  stages {
    stage('Production') {
      // when {
      //   branch 'main'
      // }
      stages {
        stage('Env File') {
          steps {
            echo 'Creating env file'
            sh 'echo "VUE_APP_BASE_URL=http://3.127.104.45:5010/" > .env' // Create env file
          }
        }
        stage('Build') {
          steps {
            echo 'Running build phase'
            sh 'docker build -t my-react-app:latest .' // Docker build image
          }
        }
        stage('Deploy') {
          steps {
            echo 'Running deploy phase'
            // input message: 'Do you want to deploy the web site? (Click "Proceed" to continue)'
            sh 'docker rm -f my-react-app || true'
            sh 'docker run -d -p 8080:80 my-react-app:latest' //Run docker container
          }
        }
        stage('Prune') {
          steps {
            echo 'Running prune phase'
            sh 'docker image prune --force'
          }
        }
      }
    }
  }

  // Post-build action`
  post {
    success {
      echo 'This build was successful'
    }
    failure {
      echo 'This build has failed'
    }
    unstable {
      echo 'This build is unstable'
    }
    always {
      // Clean jenkins workspace
      cleanWs()
    }
  }
}