pipeline {
    agent any

    environment {
        // Define environment variables
        DOCKER_IMAGE = "eureka-server-image"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                git url: 'https://github.com/manuel-larbi/spring-cloud-eureka-server.git', branch: 'main'
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
