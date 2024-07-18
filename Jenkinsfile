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
                sh 'mvn clean package'
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
                    sh '''
                    docker-compose down
                    docker-compose pull
                    docker-compose up -d
                    '''
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