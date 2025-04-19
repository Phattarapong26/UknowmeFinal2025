pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/Phattarapong26/UknowmeFinal2025.git'
        GIT_BRANCH = 'main'
        PATH = "/usr/local/bin:${env.PATH}"
        APP_PORT = '5173'
        ROBOT_REPORTS_DIR = 'robot-reports'
        VENV_PATH = 'robot-venv'
        MONGODB_PORT = '27017'
        MAX_WAIT_TIME = '300' // 5 minutes
    }

    stages {
        stage('Git Clone') {
            steps {
                cleanWs()
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}",
                    credentialsId: 'git-credentials'
            }
        }

        stage('Check Node') {
            steps {
                bat '''
                    node -v
                    npm -v
                '''
            }
        }

        stage('Prepare Test Environment') {
            steps {
                bat '''
                    python -m venv %VENV_PATH%
                    call %VENV_PATH%\\Scripts\\activate
                    pip install --upgrade pip
                    pip install robotframework robotframework-seleniumlibrary pyotp
                '''
            }
        }

        stage('Check Docker') {
            steps {
                bat 'docker info'
            }
        }

        stage('Clean Up Containers') {
            steps {
                bat 'docker-compose down'
            }
        }


        stage('Build Docker Images') {
            steps {
                bat 'docker-compose build'
            }
        }

        stage('Deploy Containers') {
            steps {
                bat 'docker-compose up -d'
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat '''
                    robot -d %ROBOT_REPORTS_DIR% \
                        PositiveSuperAdmin.robot \
                        PositiveBond.robot \
                        PositiveAdmin.robot \
                        NegativeSuperAdmin.robot \
                        NegativeBond.robot \
                        NegativeAdmin.robot
                '''
            }
        }

        stage('Docker Compose Logs') {
            steps {
                bat 'docker-compose logs --tail=50'
            }
        }

        stage('Check MongoDB') {
            steps {
                bat '''
                    echo "กำลังตรวจสอบการเชื่อมต่อ MongoDB..."
                    timeout %MAX_WAIT_TIME% /t
                    curl -f telnet://localhost:%MONGODB_PORT% || exit 1
                '''
            }
        }

        stage('Wait for Application') {
            steps {
                bat '''
                    echo "กำลังรอให้แอปพลิเคชันพร้อมใช้งาน..."
                    timeout %MAX_WAIT_TIME% /t
                    curl -f http://localhost:%APP_PORT% || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline สำเร็จ! แอปพลิเคชันกำลังทำงานที่ http://localhost:${APP_PORT}"
            echo "รายงานการทดสอบ Robot Framework อยู่ในโฟลเดอร์ ${ROBOT_REPORTS_DIR}"
            archiveArtifacts artifacts: 'robot-reports/**/*', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline ล้มเหลว! กรุณาตรวจสอบบันทึกเพื่อดูรายละเอียด'
            archiveArtifacts artifacts: 'robot-reports/**/*', allowEmptyArchive: true
        }
        always {
            cleanWs()
        }
    }
}
