pipeline {
    agent any

    tools{
        maven "M3"
    }
    environment {
        // Define environment variables
        DOCKER_IMAGE = "manuellarbi/eureka-server-image"
        DOCKER_CREDENTIALS_ID = "dockerlogin"
        K8S_NAMESPACE= "eureka-namespace"
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
                    appImage = docker.build(DOCKER_IMAGE)
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_CREDENTIALS_ID}") {
                         appImage.push("latest")
                    }
                }
            }
        }

        stage('Code Coverage') {
            steps {
                script {
                    bat "mvn clean test jacoco:report"
                    junit '**/target/surefire-reports/TEST-*.xml'
                    jacoco(execPattern: '**/target/jacoco.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java', inclusionPattern: '**/src/main/java/**/*.java')
                }
            }
        }

        stage('Debug Branch Name') {
            steps{
                script{
                    echo "Current branch is: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Start Container') {
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

    stage('Deploy App to Kubernetes') {
        steps {
            kubeconfig(credentialsId: 'kubernetesCred') {
                bat "kubectl apply -f eureka-deployment.yaml -n ${env.K8S_NAMESPACE}"
                bat "kubectl apply -f eureka-config.yaml -n ${env.K8S_NAMESPACE}"
            }

//             withCredentials([string(credentialsId: 'kubernetesCred', variable: 'kubeconfig-cred')]) {
//                 // some block
//             }
        }
    }

    post {
        always {
            // Clean up
            cleanWs()
        }
    }
}