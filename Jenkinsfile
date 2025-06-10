pipeline {
    agent any
    
    environment {
        DOCKER_HUB_REPO = 'reemamer/simple-app'
        DOCKER_HUB_CREDS = credentials('docker-hub-creds')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/reemahmedamer/jenkins-podman.git'
            }
        }
        
        stage('Build Image with Podman') {
            steps {
                script {
                    // Build the image
                    sh "podman build -t ${env.DOCKER_HUB_REPO}:${env.BUILD_NUMBER} ."
                    sh "podman tag ${env.DOCKER_HUB_REPO}:${env.BUILD_NUMBER} ${env.DOCKER_HUB_REPO}:latest"
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                sh "podman login -u ${env.DOCKER_HUB_CREDS_USR} -p ${env.DOCKER_HUB_CREDS_PSW} docker.io"
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    // Push both versions of the image
                    sh "podman push ${env.DOCKER_HUB_REPO}:${env.BUILD_NUMBER}"
                    sh "podman push ${env.DOCKER_HUB_REPO}:latest"
                }
            }
        }
    }
    
    post {
        always {
            // Clean up - logout from Docker Hub
            sh "podman logout docker.io"
            
            // Remove local images to save space
            script {
                sh "podman rmi ${env.DOCKER_HUB_REPO}:${env.BUILD_NUMBER} || true"
                sh "podman rmi ${env.DOCKER_HUB_REPO}:latest || true"
            }
        }
    }
}