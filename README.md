pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/akulasathish/jenkinscicd.git',
                    credentialsId: '3d0cda11-15ad-4126-b6f5-8677e4df4670',
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t akulasathish1997/cicd:10 .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                echo 'No tests to run for static HTML.'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-token', variable: 'DOCKER_TOKEN')]) {
                    script {
                        echo 'Pushing to Docker Hub...'
                        sh 'echo $DOCKER_TOKEN | docker login -u akulasathish1997 --password-stdin'
                        sh 'docker push akulasathish1997/cicd:10'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying...'
                    // Stop any running containers from the same image
                    def runningContainers = sh(script: 'docker ps -q --filter ancestor=akulasathish1997/cicd:10', returnStdout: true).trim()
                    if (runningContainers) {
                        sh "docker stop ${runningContainers}"
                    }
                    
                    // Remove stopped containers from the same image
                    def allContainers = sh(script: 'docker ps -a -q --filter ancestor=akulasathish1997/cicd:10', returnStdout: true).trim()
                    if (allContainers) {
                        sh "docker rm ${allContainers}"
                    }
                    
                    // Run the new container
                    sh 'docker run -d -p 80:80 akulasathish1997/cicd:10'
                }
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
