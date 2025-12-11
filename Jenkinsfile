pipeline {
  agent any
  environment {
    DOCKERHUB_USER = "sandymass007"
    IMAGE_NAME = "${DOCKERHUB_USER}/emc-portal"
  }

  stages {

    stage('Checkout Source Code') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        script {
          IMAGE_TAG = "${env.BUILD_NUMBER}"
          sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
          sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
        }
      }
    }

    stage('Push Docker Image to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
          sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
          sh "docker push ${IMAGE_NAME}:latest"
        }
      }
    }

    stage('Deploy to EC2 Server') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
          script {
            EC2_HOST = "3.7.254.133"
            IMAGE_FULL = "${IMAGE_NAME}:${IMAGE_TAG}"
            sh "scp -o StrictHostKeyChecking=no -i ${SSH_KEY} scripts/deploy.sh ubuntu@${EC2_HOST}:/home/ubuntu/deploy.sh"
            sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${EC2_HOST} 'chmod +x /home/ubuntu/deploy.sh'"
            sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${EC2_HOST} 'sudo bash /home/ubuntu/deploy.sh ${IMAGE_FULL}'"
          }
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline complete."
    }
  }
}
