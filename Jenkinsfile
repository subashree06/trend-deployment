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

        stage('1 - Checkout') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main',
                    url: 'https://github.com/subashree06/trend-deployment.git'
            }
        }

        stage('2 - Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
                    docker build -t ${FULL_IMAGE} -t ${LATEST_IMAGE} .
                    echo "Built: ${FULL_IMAGE}"
                """
            }
        }

        stage('3 - Test Container') {
            steps {
                echo 'Testing container...'
                sh """
                    docker rm -f trend-test || true
                    docker run -d --name trend-test -p 3001:3000 ${FULL_IMAGE}
                    sleep 8
                    docker ps | grep trend-test
                    docker stop trend-test || true
                    docker rm trend-test || true
                    echo "Test passed!"
                """
            }
        }

        stage('4 - Push to DockerHub') {
            steps {
                echo 'Pushing to DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${FULL_IMAGE}
                        docker push ${LATEST_IMAGE}
                        echo "Pushed: ${FULL_IMAGE}"
                    """
                }
            }
        }

        stage('5 - Configure kubectl') {
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

        stage('6 - Deploy to EKS') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh """
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl rollout status deployment/trend-app --timeout=120s
                    echo "Deployment complete!"
                """
            }
        }

        stage('7 - Get App URL') {
            steps {
                echo 'Getting LoadBalancer URL...'
                sh """
                    sleep 30
                    kubectl get svc trend-app-service

                    LB=\$(kubectl get svc trend-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    echo "APP URL: http://\$LB"
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! Trend app is live!'
        }

        failure {
            echo 'Pipeline failed. Check logs.'
        }

        always {
            sh 'docker logout || true'
            sh 'docker image prune -f || true'
        }
    }
}