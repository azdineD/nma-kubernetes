pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "lina2015/flask-nmak:latest"
    KUBECONFIG = "/var/lib/jenkins/.kube/config" // à adapter si Jenkins tourne sous un autre utilisateur
  }

  stages {

    stage('Clone GitHub Repo') {
      steps {
        echo '📥 Clonage du dépôt GitHub...'
        withCredentials([usernamePassword(credentialsId: 'github-access', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
          sh 'rm -rf nma-kubernetes'
          sh 'git clone https://$GIT_USER:$GIT_TOKEN@github.com/azdineD/nma-kubernetes.git'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('nma-kubernetes') {
          echo '🐳 Construction de l’image Docker...'
          sh 'docker build -t $DOCKER_IMAGE .'
        }
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
        echo '📤 Envoi de l’image vers Docker Hub...'
        sh 'docker push $DOCKER_IMAGE'
      }
    }

    stage('Déploiement Kubernetes') {
      steps {
        dir('nma-kubernetes') {
          echo '☸️ Déploiement dans Kubernetes...'
          sh 'kubectl apply -f deployment.yaml'
          sh 'kubectl apply -f service.yaml'
        }
      }
    }
  }

  post {
    success {
      echo '✅ Pipeline terminé avec succès.'
    }
    failure {
      echo '❌ Échec du pipeline.'
    }
  }
}
