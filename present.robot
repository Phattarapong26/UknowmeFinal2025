*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Library    OtpLibrary.py

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost:5173/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots

*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png

*** Test Cases ***
Test Trader And Admin Flow
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    
    # Trader Login
    Click Element    //*[@id="role-btn-trader"]
    Input Text    //*[@id="email-input"]    phattarapong.phe@spumail.net
    Input Text    //*[@id="password-input"]    1329900959999
    Sleep    1s
    Capture Step Screenshot    trader_login
    Click Element    //*[@id="login-submit-btn"]
    Sleep    1s
    Capture Step Screenshot    after_login
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เข้าสู่ระบบสำเร็จ!
    Capture Step Screenshot    user_login_success
    Click Element    css:.swal2-confirm
    # Scroll Operations
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s
    
    # Course Slider Operations
    ${slider}=    Get WebElement    //*[@id="main-content"]
    Drag And Drop By Offset    ${slider}    500    0
    Sleep    1s
    Drag And Drop By Offset    ${slider}    -500    0
    Sleep    1s
    
    # Course Selection and Registration
    Click Element   //*[@id="course-card-6729774aed0b44b753cafb4e"]
    Sleep    1s
    Capture Step Screenshot    course_selection
    Click Element    //*[@id="register-course-btn"]
    Sleep    1s
    Capture Step Screenshot    course_registration
    Click Element    css:.swal2-confirm
    Sleep    1s
    Capture Step Screenshot    after_registration
    
    # Learning Flow
    Click Element    //*[@id="start-learning-btn"]
    Sleep    1s
    Capture Step Screenshot    start_learning
    Click Element    css:.swal2-confirm
    Sleep    1s
    Capture Step Screenshot    after_start_learning
    
    # Cancel Enrollment
    Click Element    //*[@id="cancel-enrollment-btn"]
    Sleep    1s
    Capture Step Screenshot    cancel_enrollment
    Click Element    css:.swal2-confirm
    Sleep    1s
    Capture Step Screenshot    after_success
    
    # Wait for SweetAlert2 button to be clickable
    Wait Until Element Is Visible    css:.swal2-confirm
    Execute JavaScript    document.querySelector('.swal2-confirm').click();
    Sleep    2s
    
    # Wait for SweetAlert2 container to disappear
    Wait Until Element Is Not Visible    css:.swal2-container
    Sleep    1s
    
    Click Element    css:#user-menu-btn
    Sleep    1s
    Capture Step Screenshot    user_section
    Click Element    //*[@id="profile-btn"]
    Sleep    3s
    Capture Step Screenshot    profile
    Click Element    //*[@id="my-courses-link"]
    Sleep    3s
    Capture Step Screenshot    my_courses
    Click Element    //*[@id="close-history-btn"]
    
    # Schedule Navigation
    Click Element    //*[@id="user-nav-schedule"]
    Sleep    3s
    Capture Step Screenshot    schedule
    Click Element    //*[@id="start-course-btn-0"]
    Sleep    2s
    Capture Step Screenshot    start_course
    Click Element    css:.swal2-confirm
    
    # Change Password
    Click Element    //*[@id="user-section"]
    Sleep    2s
    Capture Step Screenshot    before_password_change
    Click Element    //*[@id="change-password-btn"]
    Input Text    //*[@id="swal-old-password"]    1329900959999
    Input Text    //*[@id="swal-new-password"]    0966566414
    Sleep    5s
    Capture Step Screenshot    password_change

    Click Element    css:.swal2-confirm
    Sleep    1s
    
    # Wait for SweetAlert2 button to be clickable
    Wait Until Element Is Visible    css:.swal2-confirm
    Execute JavaScript    document.querySelector('.swal2-confirm').click();
    Sleep    2s
    
    # Wait for SweetAlert2 container to disappear
    Wait Until Element Is Not Visible    css:.swal2-container
    Sleep    1s
    
    Capture Step Screenshot    after_password_change
    
    # Logout
    Click Element    css:#user-menu-btn
    Sleep    1s
    Wait Until Element Is Visible    css:#logout-btn
    Click Element    css:#logout-btn
    Sleep    1s
    Capture Step Screenshot    logout
    
    # Admin Login
    Click Element    //*[@id="role-btn-admin"]
    Input Text    //*[@id="email-input"]    PhattarapongUknowme@gmail.com
    Input Text    //*[@id="password-input"]    65041785
    Sleep    3s
    Capture Step Screenshot    admin_login
    Click Element    //*[@id="login-submit-btn"]
    Sleep    5s
    Capture Step Screenshot    after_admin_login
    Click Element    css:.swal2-confirm
    
    # Admin Course Management
    Click Element    //*[@id="course-card-672976dbed0b44b753cafb49"]
    Sleep    3s
    Capture Step Screenshot    admin_course_view
    Click Element    //*[@id="show-participants-btn"]
    Sleep    3s
    Click Element    //*[@id="check-participant-67dc41d258cdf8f0d4cae527"]
    Sleep    5s
    Capture Step Screenshot    participant_check
    Click Element    //*[@id="save-participants"]
    Sleep    3s
    Click Element    //*[@id="close-check-name"]
    
    # Course Edit
    Click Element    //*[@id="nav-courses"]
    Click Element    //*[@id="edit-btn-6729751eed0b44b753cafb3a"]
    Sleep    3s
    Capture Step Screenshot    course_edit
    Input Text    //*[@id="trainingLocation-edit-modal-6729751eed0b44b753cafb3a"]    University
    Sleep    3s
    Capture Step Screenshot    location_edit
    
    # Schedule and Participants
    Click Element    //*[@id="nav-schedule"]
    Sleep    3s
    Capture Step Screenshot    schedule_view
    Click Element    //*[@id="view-participants-672976dbed0b44b753cafb49"]
    Sleep    3s
    Capture Step Screenshot    participants_view
    Click Element    //*[@id="close-check-name"]
