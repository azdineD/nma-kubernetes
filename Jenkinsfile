pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "lina2015/flask-nmak:latest"
    KUBECONFIG = "/home/azureuser/.kube/config"  // à adapter selon ton utilisateur Jenkins
  }

  stages {
    stage('Clone') {
      steps {
        echo '📥 Clonage du dépôt GitHub...'
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        echo '🐳 Construction de l’image Docker...'
        sh 'docker build -t $DOCKER_IMAGE .'
      }
    }

    stage('Docker Hub Login') {
      steps {
        echo '🔐 Connexion à Docker Hub...'
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        echo '📤 Push de l’image sur Docker Hub...'
        sh 'docker push $DOCKER_IMAGE'
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        echo '☸️ Déploiement dans Kubernetes...'
        sh 'kubectl apply -f deployment.yaml'
        sh 'kubectl apply -f service.yaml'
      }
    }
  }

  post {
    failure {
      echo '❌ Échec du pipeline.'
    }
    success {
      echo '✅ Pipeline terminé avec succès.'
    }
  }
}
