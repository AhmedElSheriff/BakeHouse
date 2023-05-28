pipeline {
    agent { label 'iti-slave-node' }
    stages {
        stage('build') {
            steps {
                script {
                   withCredentials([usernamePassword(credentialsId: 'dockerhub-acc', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                       sh """
                            docker login -u $USERNAME -p $PASSWORD
                            docker build -t ahmedlsheriff/iti-bakehouse:${BUILD_NUMBER} .
                            docker push ahmedlsheriff/iti-bakehouse:${BUILD_NUMBER}
                       """
                   }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                  withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                      sh """
                          mv Deployment/deploy.yaml Deployment/deploy.yaml.tmp
                          cat Deployment/deploy.yaml.tmp | envsubst > Deployment/deploy.yaml
                          rm -f Deployment/deploy.yaml.tmp
                          kubectl apply -f Deployment -n default
                        """
                  }
                }
            }
        }
    }
}
