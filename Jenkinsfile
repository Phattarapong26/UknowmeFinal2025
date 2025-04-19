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
        PYTHON_PATH = '/usr/local/bin/python3'
    }

    stages {
        stage('Git Clone') {
            steps {
                cleanWs()
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}"
            }
        }

        stage('Create Environment File') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            echo "MONGODB_URI=mongodb://localhost:27017/uknowme" > .env
                            echo "JWT_SECRET=your_jwt_secret" >> .env
                            echo "PORT=3000" >> .env
                            echo "NODE_ENV=development" >> .env
                        '''
                    } else {
                        bat '''
                            echo MONGODB_URI=mongodb://localhost:27017/uknowme > .env
                            echo JWT_SECRET=your_jwt_secret >> .env
                            echo PORT=3000 >> .env
                            echo NODE_ENV=development >> .env
                        '''
                    }
                }
            }
        }

        stage('Check Node') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            which node
                            node -v
                            npm -v
                        '''
                    } else {
                        bat '''
                            where node
                            node -v
                            npm -v
                        '''
                    }
                }
            }
        }

        stage('Prepare Test Environment') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            which python3
                            python3 -m venv ${VENV_PATH} || exit 1
                            . ${VENV_PATH}/bin/activate
                            python -m pip install --upgrade pip
                            pip install --no-cache-dir robotframework robotframework-seleniumlibrary pyotp
                        '''
                    } else {
                        bat '''
                            where python
                            python -m venv %VENV_PATH% || exit 1
                            call %VENV_PATH%\\Scripts\\activate
                            python -m pip install --upgrade pip
                            pip install --no-cache-dir robotframework robotframework-seleniumlibrary pyotp
                        '''
                    }
                }
            }
        }

        stage('Check Docker') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            which docker
                            docker info || exit 1
                        '''
                    } else {
                        bat '''
                            where docker
                            docker info || exit 1
                        '''
                    }
                }
            }
        }

        stage('Clean Up Containers') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            docker-compose down || true
                            docker system prune -f || true
                        '''
                    } else {
                        bat '''
                            docker-compose down || exit 0
                            docker system prune -f || exit 0
                        '''
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            docker-compose build --no-cache || exit 1
                            docker-compose config || exit 1
                        '''
                    } else {
                        bat '''
                            docker-compose build --no-cache || exit 1
                            docker-compose config || exit 1
                        '''
                    }
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            docker-compose up -d
                            sleep 10
                        '''
                    } else {
                        bat '''
                            docker-compose up -d
                            timeout /t 10
                        '''
                    }
                }
            }
        }

        stage('Check MongoDB') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            echo "กำลังตรวจสอบการเชื่อมต่อ MongoDB..."
                            for i in $(seq 1 30); do
                                if nc -z localhost ${MONGODB_PORT}; then
                                    echo "MongoDB พร้อมใช้งาน"
                                    exit 0
                                fi
                                echo "รอ MongoDB... ($i/30)"
                                sleep 10
                            done
                            echo "ไม่สามารถเชื่อมต่อ MongoDB ได้"
                            exit 1
                        '''
                    } else {
                        bat '''
                            echo "กำลังตรวจสอบการเชื่อมต่อ MongoDB..."
                            for /l %%i in (1,1,30) do (
                                curl -f telnet://localhost:%MONGODB_PORT% && (
                                    echo MongoDB พร้อมใช้งาน
                                    exit /b 0
                                ) || (
                                    echo รอ MongoDB... (%%i/30)
                                    timeout /t 10 /nobreak
                                )
                            )
                            echo ไม่สามารถเชื่อมต่อ MongoDB ได้
                            exit /b 1
                        '''
                    }
                }
            }
        }

        stage('Wait for Application') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            echo "กำลังรอให้แอปพลิเคชันพร้อมใช้งาน..."
                            for i in $(seq 1 30); do
                                if curl -f http://localhost:${APP_PORT}; then
                                    echo "แอปพลิเคชันพร้อมใช้งาน"
                                    exit 0
                                fi
                                echo "รอแอปพลิเคชัน... ($i/30)"
                                sleep 10
                            done
                            echo "ไม่สามารถเชื่อมต่อแอปพลิเคชันได้"
                            exit 1
                        '''
                    } else {
                        bat '''
                            echo "กำลังรอให้แอปพลิเคชันพร้อมใช้งาน..."
                            for /l %%i in (1,1,30) do (
                                curl -f http://localhost:%APP_PORT% && (
                                    echo แอปพลิเคชันพร้อมใช้งาน
                                    exit /b 0
                                ) || (
                                    echo รอแอปพลิเคชัน... (%%i/30)
                                    timeout /t 10 /nobreak
                                )
                            )
                            echo ไม่สามารถเชื่อมต่อแอปพลิเคชันได้
                            exit /b 1
                        '''
                    }
                }
            }
        }

        stage('Run Robot Tests') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            . ${VENV_PATH}/bin/activate
                            robot -d ${ROBOT_REPORTS_DIR} \
                                PositiveSuperAdmin.robot \
                                PositiveBond.robot \
                                PositiveAdmin.robot \
                                NegativeSuperAdmin.robot \
                                NegativeBond.robot \
                                NegativeAdmin.robot
                        '''
                    } else {
                        bat '''
                            call %VENV_PATH%\\Scripts\\activate
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
            }
        }

        stage('Docker Compose Logs') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'docker-compose logs --tail=50'
                    } else {
                        bat 'docker-compose logs --tail=50'
                    }
                }
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
            script {
                if (isUnix()) {
                    sh 'docker-compose down || true'
                } else {
                    bat 'docker-compose down || exit 0'
                }
            }
            cleanWs()
        }
    }
}
