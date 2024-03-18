pipeline {
    agent any
        stages {
            stage ("checkout from git") {
                steps {
                    git branch: 'main', url: 'https://github.com/mounicamettupalli/infraterraform.git'
                }
            }
            stage("Install Terraform"){
                steps {
                    script {
                        sh 'sudo apt-get update && sudo apt-get install -y gnupg software-properties-common'
                        sh 'wget -O- https://apt.releases.hashicorp.com/gpg | \
                            gpg --dearmor | \
                            sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null'
                        sh 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
                            https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
                            sudo tee /etc/apt/sources.list.d/hashicorp.list'
                        sh 'sudo apt update'
                        sh 'sudo apt-get install terraform -y'
                    }
                }
            }
          stage("Run Terraform") {
            steps {
                script {
                    sh 'terraform --version'
                }
            }
          }
          stage("Terraform Init") {
            steps {
                script {
                    sh 'terraform init'
                }
            }
          }
        stage("Terraform Plan") {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
         stage("Terraform Apply") {
            steps {
                script {
                    sh 'terraform apply --auto-approve'
                }
            }
         }
        stage("Approve To Destroy") {
            steps {
                input message: "Approve to Destroy", ok: "Destroy"
            }
        
        }
       stage("Terraform Destroy") {
            steps {
                script {
                    sh 'terraform destroy --auto-approve'
                }
            }
         }
    }
}
