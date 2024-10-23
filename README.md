//this is sample jenkins file 

pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/akulasathish/jenkinscicd.git',
                    credentialsId: 'git-hub-credentials',  // GitHub credentials ID
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t akulasathish1997/cicd:html-deploy .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub using the stored credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_TOKEN')]) {
                        // Log in using the Docker Hub username and access token
                        sh 'echo $DOCKER_TOKEN | docker login -u $DOCKER_USERNAME --password-stdin'
                        
                        // Push the Docker image to Docker Hub
                        sh 'docker push akulasathish1997/cicd:html-deploy'
                    }
                }
            }
        }

        stage('Stop and Remove Existing Container') {
            steps {
                script {
                    // Stop and remove the existing container if it exists
                    sh 'docker stop my-running-app || true'
                    sh 'docker rm my-running-app || true'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container
                    sh 'docker run -d --name my-running-app -p 80:80 akulasathish1997/cicd:html-deploy'
                }
            }
        }

        stage('Deploy HTML App') {
            steps {
                script {
                    echo 'Deploying the application...'
                    // Add your deployment steps here if needed
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}
