pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/khalilarfaoui/Dockorize-spring-mysql-Dockerfile-dockercompose.git'
        APP_NAME = 'spring-boot-app'
        DOCKER_COMPOSE_PATH = './docker-compose.yml'
        DOCKER_IMAGE_NAME = 'spring-boot-app'
        SERVER_IP = '102.211.209.173'  // L'IP de votre VPS
        SSH_CREDENTIALS_ID = 'jenkins-vps-access'
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupérer le code depuis GitHub
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Construire l'image Docker pour l'application
                    sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
                }
            }
        }

        stage('Deploy on VPS') {
            steps {
                // Déployer via SSH sur le VPS
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'VPS-Deployment',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: '**/*',
                                    remoteDirectory: '/home/app',  // Chemin de déploiement sur votre VPS
                                    removePrefix: '',
                                    execCommand: """
                                        cd /home/app &&
                                        docker-compose down &&
                                        docker-compose up -d --build
                                    """
                                )
                            ],
                            usePromotionTimestamp: false,
                            verbose: true
                        )
                    ]
                )
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé !'
        }
    }
}
