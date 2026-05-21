// ============================================================
// Jenkinsfile – Declarative CI/CD Pipeline – Trend App
// Stages: Checkout → Build → Test → Push → Deploy → Verify
// ============================================================

pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'YOUR_DOCKERHUB_USERNAME'   // ← CHANGE THIS
        IMAGE_NAME         = 'trend-app'
        IMAGE_TAG          = "${BUILD_NUMBER}"
        FULL_IMAGE         = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
        LATEST_IMAGE       = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
        AWS_REGION         = 'us-east-1'
        EKS_CLUSTER        = 'trend-app'
    }

    stages {

        stage('1 — Checkout') {
            steps {
                echo '📥 Cloning repository...'
                git branch: 'main',
                    url: 'https://github.com/YOUR_GITHUB_USERNAME/trend-deployment.git'  // ← CHANGE THIS
            }
        }

        stage('2 — Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh """
                    docker build -t ${FULL_IMAGE} -t ${LATEST_IMAGE} .
                    echo "✅ Built: ${FULL_IMAGE}"
                """
            }
        }

        stage('3 — Test Container') {
            steps {
                echo '🧪 Testing container starts correctly...'
                sh """
                    docker run -d --name trend-test -p 3001:3000 ${FULL_IMAGE}
                    sleep 8
                    docker ps | grep trend-test && echo "✅ Container is running"
                    docker stop trend-test && docker rm trend-test
                """
            }
        }

        stage('4 — Push to DockerHub') {
            steps {
                echo '⬆️  Pushing to DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push ${FULL_IMAGE}
                        docker push ${LATEST_IMAGE}
                        echo "✅ Pushed: ${FULL_IMAGE}"
                    """
                }
            }
        }

        stage('5 — Configure kubectl') {
            steps {
                echo '⚙️  Connecting kubectl to EKS...'
                sh """
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER}
                    kubectl get nodes
                """
            }
        }

        stage('6 — Deploy to EKS') {
            steps {
                echo '🚀 Deploying to Kubernetes...'
                sh """
                    sed -i 's|YOUR_DOCKERHUB_USERNAME/trend-app:latest|${FULL_IMAGE}|g' kubernetes/deployment.yaml
                    kubectl apply -f kubernetes/deployment.yaml
                    kubectl apply -f kubernetes/service.yaml
                    kubectl rollout status deployment/trend-app --timeout=120s
                    echo "✅ Deployment complete!"
                """
            }
        }

        stage('7 — Get App URL') {
            steps {
                echo '🌐 Retrieving LoadBalancer URL...'
                sh """
                    sleep 30
                    kubectl get svc trend-app-service
                    LB=\$(kubectl get svc trend-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    echo "======================================"
                    echo "  🌍 APP URL: http://\${LB}"
                    echo "======================================"
                """
            }
        }
    }

    post {
        success { echo '🎉 Pipeline succeeded! Trend app is live on EKS.' }
        failure { echo '❌ Pipeline failed. Check the stage logs above.' }
        always  {
            sh 'docker logout || true'
            sh 'docker image prune -f || true'
        }
    }
}
