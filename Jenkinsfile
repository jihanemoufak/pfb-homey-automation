pipeline {
    agent any

    stages {
        stage('Récupération du code') {
            steps {
                checkout scm
            }
        }

        stage('Installation des dépendances') {
            steps {
                bat 'python -m pip install -r requirements.txt'
            }
        }

        stage('Exécution des tests') {
            steps {
                bat 'python -m robot -d results tests'
            }
        }
    }

    post {
        always {
            robot outputPath: 'results'
            archiveArtifacts artifacts: 'results/*.html, results/output.xml', allowEmptyArchive: true
        }
    }
}