pipeline {
    agent any

    

    stages {

        

        stage ('TF Initialize') {
            steps {
                sh "terraform init -input=false"
            }
        }

        stage ('Pre Checks') {
            steps {
                sh "terraform version && terraform fmt -recursive && terraform validate"
            }
        }

        stage ('Plan') {
            steps {
                script {
                    sh "terraform workspace select test || terraform workspace new test"
                    env.CHANGES = sh (
                        script: 'terraform plan -input=false -var-file=env.tfvars/dev-env.tfvars -detailed-exitcode',
                        returnStdout: false, returnStatus: true
                    )
                    if (env.CHANGES == '1') {
                        echo 'Plan contain ERRORS !!'
                        sh "exit 1"
                    } else if (env.CHANGES == '0') {
                        echo 'NO Chnages to apply !!'
                    } else {
                        echo '** Changes to apply !!'
                    }
                }
            }
        }

        stage ('Apply') {
            when {
                expression { env.CHANGES == '2' }
            }
            steps {
                sh "terraform apply -auto-approve"
            }
        }
    }
}
