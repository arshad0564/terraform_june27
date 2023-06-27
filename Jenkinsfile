pipeline {
    agent any
    stages {
        stage('Initialize') {
            steps {
                dir('tf_resource') {
                    script {
                        def isFirstRun = !fileExists('terraform_initialized')
                        
                        if (isFirstRun) {
                            // Execute 'terraform init'
                            sh 'terraform init'
                            
                            // Create the flag file to mark initialization
                            writeFile file: 'terraform_initialized', text: ''
                        } else {
                            // Skip 'terraform init'
                            echo 'Skipping terraform init'
                        }
                    }
                }
            }
        }
        
        stage('action') {
            steps {
                    echo "terraform action -->${action}"
                dir('tf_resource') {
                    sh 'terraform ${action} --auto-approve'
                }
            }
        }
    }
}

