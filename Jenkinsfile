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

        stage('Package Application'){
            steps{
                script{
                   bat "mvn -Dmaven.test.failure.ignore=true clean package"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([file(credentialsId: 'ENV', variable: 'ENV_FILE')]) {
                    script {
                        // Create .env file
                        bat "copy %ENV_FILE% src\\main\\resources\\.env"

                        // Stop the existing containers
                        bat "docker-compose down"

                        // Start the containers
                        bat "docker-compose up -d"
                    }
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