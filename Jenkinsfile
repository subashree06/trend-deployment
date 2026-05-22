pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'subashree06'
        IMAGE_NAME         = 'trendify-app'
        IMAGE_TAG          = "${BUILD_NUMBER}"
        FULL_IMAGE         = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
        LATEST_IMAGE       = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
        AWS_REGION         = 'ap-south-1'
        EKS_CLUSTER        = 'trend-app'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/subashree06/trend-deployment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${FULL_IMAGE} -t ${LATEST_IMAGE} .
                """
            }
        }

        stage('Test Container') {
            steps {
                sh """
                    docker run -d --name trend-test -p 3001:3000 ${FULL_IMAGE}
                    sleep 10
                    docker stop trend-test || true
                    docker rm trend-test || true
                """
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${FULL_IMAGE}
                        docker push ${LATEST_IMAGE}
                    """
                }
            }
        }

        stage('Configure kubectl') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region ${AWS_REGION}

                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER}
                    """
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout status deployment/trend-app --timeout=180s
                """
            }
        }

        stage('Get URL') {
            steps {
                sh """
                    sleep 20
                    kubectl get svc trend-app-service
                """
            }
        }
    }

    post {
        always {
            sh "docker system prune -f || true"
        }
    }
}