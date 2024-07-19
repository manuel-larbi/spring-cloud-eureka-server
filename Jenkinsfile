pipeline {
    agent any

    tools{
        maven "M3"
    }
    environment {
        // Define environment variables
        DOCKER_IMAGE = "eureka-server-image"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                git branch: 'main', url: 'https://github.com/manuel-larbi/spring-cloud-eureka-server.git'
            }
        }

        stage('Maven Build'){
            steps{
                script{
                   bat "mvn -Dmaven.test.failure.ignore=true clean package"
                }
            }
        }

        stage('Build') {
            steps {
                // Build the Docker image
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Deploy') {
            steps {
                // Deploy the application using Docker Compose
                script {
                    docker.compose.down
                    docker.compose.up
                }
            }
        }
    }

    post {
        always {
            // Clean up
            cleanWs()
        }
    }
}