pipeline {
    agent { label 'iti-slave-node' }
    stages {
        stage('build') {
            steps {
                echo 'build'
                script{
                    if (BRANCH_NAME == "dev" || BRANCH_NAME == "test" || BRANCH_NAME == "preprod") {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-acc', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh '''
                                docker login -u ${USERNAME} -p ${PASSWORD}
                                docker build -t ahmedlsheriff/iti-bakehouse:v${BUILD_NUMBER} .
                                docker push ahmedlsheriff/iti-bakehouse:v${BUILD_NUMBER}
                                echo ${BUILD_NUMBER} > ../build.txt
                            '''
                        }
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                echo 'deploy'
                script {
                    if (BRANCH_NAME == "release" || BRANCH_NAME == "dev") {
                        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                            sh '''
                                export BUILD_NUMBER=$(cat ../build.txt)
                                release=$(helm list --short | grep "^bake-house")
                                if [[ -z $release ]]:
                                    then
                                        helm install bake-house ./bake-house --values bake-house/${BRANCH_NAME}-values.yaml \
                                        --set BUILD_NUMBER=${BUILD_NUMBER}
                                    else
                                        helm upgrade bake-house ./bake-house --values bake-house/${BRANCH_NAME}-values.yaml \
                                        --set BUILD_NUMBER=${BUILD_NUMBER}
                                fi
                            '''
                        }
                    }
                }
            }
        }
    }
}